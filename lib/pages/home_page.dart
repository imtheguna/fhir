import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fhir_demo/modals/constants.dart';
import 'package:fhir_demo/modals/users.dart';
import 'package:fhir_demo/pages/home.dart';
import 'package:fhir_demo/pages/membersetup.dart';
import 'package:fhir_demo/provider/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class TestClass {
  static void callback(String id, DownloadTaskStatus status, int progress) {}
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool islodaing = false;
  bool isAccCreated = false;
  Person? resource;
  Users? users;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ReceivePort _port = ReceivePort();

  static downloadingCallBack(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloadingGK");
    sendPort!.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(_port.sendPort, "downloadingG");
    _port.listen((message) {
      print(message[2]);
    });
    FlutterDownloader.registerCallback(TestClass.callback);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<Person?> getResource() async {
    try {
      setState(() {
        islodaing = true;
      });

      if (Constants.memberidtest.text.isEmpty) {
        Constants.showInSnackBar(
            _scaffoldKey, "Please Enter Member ID", Colors.red);
      } else if (Constants.memberidtest.text.length < 3) {
        Constants.showInSnackBar(
            _scaffoldKey, "Provide Minimum 3 Character", Colors.red);
      } else {
        var request = FhirRequest.read(
          base: Uri.parse(Constants.fhirapilink),
          type: R4ResourceType.Person,
          id: Id(Constants.memberidtest.text),
        );
        Resource? response = await request
            .request(headers: {'content-type': 'application/fhir+json'});
        print(response);
        if (response!.id == null) {
          Constants.showInSnackBar(
              _scaffoldKey, "Member not exist", Colors.red);
          setState(() {
            islodaing = false;
          });
          return null;
        }
        setState(() {
          islodaing = false;
        });
        return (response as Person);
      }
      setState(() {
        islodaing = false;
      });
      return null;
    } catch (e) {
      setState(() {
        islodaing = false;
      });
      print(e);
      Constants.showInSnackBar(_scaffoldKey, "Try Again!", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (cts, snapshot) {
            if (snapshot.hasData) {
              return Center(child: Home());
            } else if (snapshot.hasError) {
              return Container(
                child: const Text("Error"),
              );
            }
            return Center(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 350,
                        child: const Image(
                          image: AssetImage("images/login.jpg"),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 15,
                          top: 5,
                          bottom: 5,
                        ),
                        child: TextFormField(
                          controller: Constants.memberidtest,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Member ID',
                            alignLabelWithHint: true,
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (isAccCreated)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 15,
                            top: 5,
                            bottom: 5,
                          ),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              validator: (input) {
                                if (input!.isEmpty == 0)
                                  return '*Fill the password please!';
                                if (input.length < 6)
                                  return 'Provide Minimum 6 Character';
                              },
                              controller: Constants.password,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Password',
                                alignLabelWithHint: true,
                                prefixIcon: Icon(
                                  Icons.key,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (isAccCreated)
                        const SizedBox(
                          height: 20,
                        ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: RaisedButton(
                          onPressed: isAccCreated
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (resource == null || users == null) {
                                      resource = await getResource();
                                      users = await AuthenticationService()
                                          .readUsers(resource!.id!.value!);
                                    }
                                    Constants.showInSnackBar(
                                      _scaffoldKey,
                                      "Connecting...",
                                      Colors.green,
                                    );
                                    try {
                                      await AuthenticationService().signin(
                                          users!.email,
                                          Constants.password.text,
                                          context,
                                          _scaffoldKey);
                                      _scaffoldKey.currentState!
                                          .removeCurrentSnackBar();
                                      Constants.showInSnackBar(
                                        _scaffoldKey,
                                        "Welcome Back",
                                        Colors.green,
                                      );
                                      setState(() {
                                        isAccCreated = false;
                                        islodaing = false;
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      Constants.showInSnackBar(
                                        _scaffoldKey,
                                        e.message!,
                                        Colors.red,
                                      );
                                      setState(() {
                                        islodaing = false;
                                      });
                                    }
                                  }
                                }
                              : () async {
                                  resource ??= await getResource();

                                  if (resource != null) {
                                    Users? users = await AuthenticationService()
                                        .readUsers(resource!.id!.value!);
                                    if (users == null) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MemberSetupPage(
                                                      resource: resource!)));
                                    } else {
                                      setState(() {
                                        isAccCreated = !isAccCreated;
                                      });
                                      Constants.showInSnackBar(
                                        _scaffoldKey,
                                        "ID Verified!, Please Enter Password",
                                        Colors.green,
                                      );
                                    }
                                  }
                                },
                          child: Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Center(
                                child: islodaing
                                    ? CircularProgressIndicator(
                                        color: isAccCreated
                                            ? Colors.white
                                            : Colors.blue,
                                      )
                                    : Text(isAccCreated ? "Login" : 'Verify',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          color: isAccCreated ? Colors.blue : Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}

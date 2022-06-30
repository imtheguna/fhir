import 'package:fhir_demo/modals/constants.dart';
import 'package:fhir_demo/provider/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';

class MemberSetupPage extends StatefulWidget {
  final Person resource;
  const MemberSetupPage({Key? key, required this.resource}) : super(key: key);

  @override
  State<MemberSetupPage> createState() => _MemberSetupPageState();
}

class _MemberSetupPageState extends State<MemberSetupPage> {
  void setvalue() {
    Constants.email.text = widget.resource.telecom![0].value!;
  }

  bool islodaing = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    setvalue();
  }

  Future<void> signup(BuildContext context) async {
    await AuthenticationService().signup(widget.resource.id!.value!,
        widget.resource.name![0].given!.first, context, _scaffoldKey);
    setState(() {
      islodaing = !islodaing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Hello \n${widget.resource.name![0].given!.first} ${widget.resource.name![0].family}",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    enabled: false,
                    controller: Constants.email,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 145, 148, 233),
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: TextFormField(
                          validator: (input) {
                            if (input!.isEmpty == 0)
                              return '*Fill the password please!';
                            if (input.length < 6)
                              return 'Provide Minimum 6 Character';
                          },
                          enabled: true,
                          obscureText: true,
                          controller: Constants.pass1,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "New Password",
                            alignLabelWithHint: true,
                            prefixIcon: Icon(Icons.key),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: TextFormField(
                          validator: (input) {
                            if (input!.isEmpty)
                              return '*Fill the password please!';
                            if (input.length < 6)
                              return 'Provide Minimum 6 Character';
                            if (input != Constants.pass1.text)
                              return 'Passwords do not match';
                          },
                          onFieldSubmitted: (v) {},
                          enabled: true,
                          obscureText: true,
                          controller: Constants.pass2,
                          decoration: const InputDecoration(
                            hintText: "Confirm Password",
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                            prefixIcon: Icon(Icons.key),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () async {
                    try {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          islodaing = !islodaing;
                        });
                        signup(context);
                      }
                    } catch (e) {
                      setState(() {
                        islodaing = false;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: islodaing
                            ? const CircularProgressIndicator()
                            : const Text('Create Account',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

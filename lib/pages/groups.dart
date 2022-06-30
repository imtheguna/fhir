import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:fhir_demo/api/fhirapi.dart';
import 'package:fhir_demo/modals/constants.dart';
import 'package:fhir_demo/modals/temp.dart';
import 'package:fhir_demo/pages/profile_page.dart';
import 'package:flutter/material.dart';

class GroupList extends StatefulWidget {
  final List<dynamic> list;
  final List<Patient> patients;
  const GroupList({Key? key, required this.list, required this.patients})
      : super(key: key);

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  // List<Patient> patients = [];
  // getMember() async {
  //   for (int i = 0; i < widget.list.length; i++) {
  //     Patient p = await FhirApi.hapiReadPatient(Id(widget.list[i]));
  //     patients.add(p);
  //   }
  //   print(patients);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getMember();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Group Members',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: !widget.patients.isEmpty
          ? Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListView.builder(
                  itemCount: widget.patients.length,
                  itemBuilder: (ctx, idx) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Card(
                        child: ProfilePage(
                          patient: widget.patients[idx],
                        ),
                      ),
                    );
                  }),
            )
          : Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.history,
                      size: 210,
                      color: Colors.white30,
                    ),
                    Text(
                      'There\'s Nothing to Show',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

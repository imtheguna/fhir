import 'package:fhir_at_rest/r4.dart';
import 'package:fhir_demo/modals/constants.dart';
import 'package:fhir_demo/modals/temp.dart';
import 'package:fhir_demo/modals/users.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_demo/pages/app_page.dart';
import 'package:fhir_demo/pages/appointements_list.dart';
import 'package:fhir_demo/pages/groups.dart';
import 'package:fhir_demo/pages/reports.dart';
import 'package:fhir_demo/pages/timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fhir_demo/api/fhirapi.dart';
import 'package:fhir_demo/pages/member_pro.dart';
import 'package:flutter/rendering.dart';

class GridWidget extends StatefulWidget {
  final List<String> list;
  final List<String> listImage;
  final int count;
  final Users users;
  final List<Patient> patients;
  final List<Appointment> appointment;
  final List<String> listMbrforapp;
  final Person person;
  const GridWidget(
      {Key? key,
      required this.users,
      required this.patients,
      required this.appointment,
      required this.listMbrforapp,
      required this.listImage,
      required this.list,
      required this.count,
      required this.person})
      : super(key: key);

  @override
  State<GridWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<GridWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> list = ['Group', 'Appointments', 'Timeline', 'Reports'];
    return (widget.count > 1)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  if (widget.list[0] == 'My Profile') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            memberProfile(person: widget.person)));
                  } else if (widget.list[0] == 'My Timeline') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TimelinePage(
                          mbrid: widget.person.id!.value!,
                          appointment: widget.appointment,
                          listMbr: widget.listMbrforapp,
                          patients: widget.patients,
                        ),
                      ),
                    );
                  }
                },
                child: Card(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.46,
                    height: MediaQuery.of(context).size.height * 0.23,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8, top: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: MediaQuery.of(context).size.height * 0.20,
                              child: Image(
                                image: AssetImage(widget.listImage[0]),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 9),
                            child: Text(widget.list[0]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      3,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (widget.list[1] == 'My Group') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GroupList(
                              list: widget.users.grpmbrlist,
                              patients: widget.patients,
                            )));
                  } else if (widget.list[1] == 'My Reports') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Reports(
                          mbrid: widget.person.id!.value!,
                          patient: widget.patients,
                        ),
                      ),
                    );
                  }
                },
                child: Card(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.46,
                    height: MediaQuery.of(context).size.height * 0.23,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8, top: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: MediaQuery.of(context).size.height * 0.20,
                              child: Image(
                                image: AssetImage(widget.listImage[1]),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 9),
                            child: Text(widget.list[1]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      3,
                    ),
                  ),
                ),
              ),
            ],
          )
        : InkWell(
            onTap: () {
              if (widget.list[0] == 'My Appointments') {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AppPage(
                          appointment: widget.appointment,
                          listMbr: widget.listMbrforapp,
                          patients: widget.patients,
                        )));
              } else if (widget.list[0] == 'My Medications') {}
            },
            child: Card(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.93,
                height: MediaQuery.of(context).size.height * 0.23,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8, top: 8),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.20,
                          child: Image(
                            image: AssetImage(widget.listImage[0]),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 9),
                        child: Text(widget.list[0]),
                      ),
                    ),
                  ],
                ),
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  3,
                ),
              ),
            ),
          );
  }
}


/*
GridView.builder(
        itemCount: widget.count,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.count > 1 ? 2 : 1,
        ),
        itemBuilder: (ctx, idx) {
          return InkWell(
            onTap: () {
              if (widget.list[idx] == 'Group') {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GroupList(
                          list: widget.users.grpmbrlist,
                          patients: widget.patients,
                        )));
              } else if (widget.list[idx] == 'Appointments') {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AppPage(
                          appointment: widget.appointment,
                          listMbr: widget.listMbrforapp,
                          patients: widget.patients,
                        )));
              } else if (list[idx] == 'Timeline') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TimelinePage(),
                  ),
                );
              } else {
                FirebaseAuth.instance.signOut();
              }
              ;
            },
            child: Card(
              child: Container(
                height: 200,
                child: Center(
                  child: Text(widget.list[idx]),
                ),
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  3,
                ),
              ),
            ),
          );
        });
         */
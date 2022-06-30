import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:fhir_demo/api/fhirapi.dart';
import 'package:fhir_demo/data/appointment_details.dart';
import 'package:fhir_demo/modals/constants.dart';
import 'package:fhir_demo/modals/users.dart';
import 'package:fhir_demo/pages/book_appointment.dart';
import 'package:fhir_demo/pages/edit_app.dart';
import 'package:fhir_demo/provider/google_sign_in.dart';
import 'package:flutter/material.dart';

class CanAPPList extends StatefulWidget {
  final List<Appointment> appointment;
  final List<Patient> patients;
  final List<String> listMbr;
  final GlobalKey<ScaffoldState> sf;
  const CanAPPList(
      {Key? key,
      required this.sf,
      required this.appointment,
      required this.patients,
      required this.listMbr})
      : super(key: key);

  @override
  State<CanAPPList> createState() => _AppListState();
}

class _AppListState extends State<CanAPPList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  getApp() async {
    Users? users = await AuthenticationService().readUsersbasedonEmail();
    Constants.appointment = [];
    for (int i = 0; i < users!.applist.length; i++) {
      var newVariable = await FhirApi.hapiReadAppointment(Id(users.applist[i]));
      Appointment p = newVariable;
      if (!Constants.appointment.contains(p)) Constants.appointment.add(p);
    }
  }

  int count = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Constants.appointment.forEach((element) {
      if (element.status == AppointmentStatus.cancelled) {
        count++;
      }
      setState(() {});
    });
    //getApp();
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, Appointment appointment) async {
    return showDialog(
        context: context,
        builder: (context) {
          bool isload = false;
          return AlertDialog(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text('Cancelation'),
              content: TextField(
                onChanged: (value) {},
                controller: Constants.cancel,
                decoration: const InputDecoration(hintText: "Enter Reason"),
              ),
              actions: <Widget>[
                FlatButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                if (isload) CircularProgressIndicator.adaptive(),
                if (!isload)
                  FlatButton(
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () async {
                        setState(() {
                          isload = true;
                        });
                        //Appointment appointment =
                        // Constants.appointment[idx];
                        if (Constants.cancel.text.isEmpty) {
                          Constants.showInSnackBar(
                              _scaffoldKey, "Please Enter Reason", Colors.red);
                          return;
                        }
                        Constants.showInSnackBar(
                            _scaffoldKey, "Updating...", Colors.green);
                        print(appointment.id!.value);

                        AppointmentDetails appointmentDetails =
                            AppointmentDetails(
                                appointmentType: appointment.appointmentType!,
                                created: appointment.created!,
                                id: appointment.id!,
                                participant: appointment.participant,
                                specialty: appointment.specialty!,
                                start: appointment.start!,
                                status: AppointmentStatus.cancelled,
                                cancelationReason: CodeableConcept(coding: [
                                  Coding(display: Constants.cancel.text)
                                ]),
                                end: appointment.end,
                                identifier: appointment.identifier,
                                serviceType: appointment.serviceType);
                        Appointment a = Appointment(
                          participant: appointmentDetails.participant,
                          id: appointmentDetails.id,
                          status: appointmentDetails.status,
                          serviceCategory: appointmentDetails.serviceCategory,
                          serviceType: appointmentDetails.serviceType,
                          specialty: appointmentDetails.specialty,
                          appointmentType: appointmentDetails.appointmentType,
                          start: appointmentDetails.start,
                          created: appointmentDetails.created,
                          end: appointmentDetails.end,
                          cancelationReason:
                              appointmentDetails.cancelationReason,
                          description: appointmentDetails.description,
                          priority: appointmentDetails.priority,
                          slot: appointmentDetails.slot,
                          identifier: appointmentDetails.identifier,
                          reasonCode: appointmentDetails.reasonCode,
                          minutesDuration: appointmentDetails.minutesDuration,
                          patientInstruction:
                              appointmentDetails.patientInstruction,
                          supportingInformation:
                              appointmentDetails.supportingInformation,
                          meta: appointmentDetails.meta,
                          language: appointmentDetails.language,
                          resourceType: appointmentDetails.resourceType,
                          basedOn: appointmentDetails.basedOn,
                          comment: appointmentDetails.comment,
                          reasonReference: appointmentDetails.reasonReference,
                          requestedPeriod: appointmentDetails.requestedPeriod,
                        );
                        var request = FhirRequest.update(
                          base: Uri.parse(Constants.fhirapilink),
                          resource: a,
                        );
                        var response = await request.request(headers: {
                          'content-type': 'application/fhir+json;charset=UTF-8'
                        });

                        debugPrint(request.toString());
                        Navigator.pop(context);
                        Users? users = await AuthenticationService()
                            .readUsersbasedonEmail();
                        Constants.appointment = [];
                        for (int i = 0; i < users!.applist.length; i++) {
                          var newVariable = await FhirApi.hapiReadAppointment(
                              Id(users.applist[i]));
                          Appointment p = newVariable;
                          if (!Constants.appointment.contains(p))
                            Constants.appointment.add(p);
                        }

                        print(appointment.id!.value);
                        setState(() {
                          isload = false;
                        });
                      }),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Appointments',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: (!Constants.appointment.isEmpty && count != 0)
          ? Container(
              child: ListView.builder(
                  itemCount: Constants.appointment.length,
                  itemBuilder: (cts, idx) {
                    if (Constants.appointment[idx].status ==
                        AppointmentStatus.cancelled) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 10, right: 5),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 6, left: 10, right: 10),
                            child: Container(
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Person Name        : " +
                                        Constants.appointment[idx]
                                            .participant[0].actor!.display
                                            .toString(),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                      "Specialty                : " +
                                          Constants.appointment[idx]
                                              .specialty![0].coding![0].display
                                              .toString(),
                                      style: const TextStyle(fontSize: 15)),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                      "Apointment Type : " +
                                          Constants
                                              .appointment[idx]
                                              .appointmentType!
                                              .coding![0]
                                              .code!
                                              .value!
                                              .toString(),
                                      style: const TextStyle(fontSize: 15)),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "Time                       : " +
                                        Constants
                                            .appointment[idx].start!.value!.day
                                            .toString() +
                                        "/" +
                                        Constants.appointment[idx].start!.value!
                                            .month
                                            .toString() +
                                        " " +
                                        Constants
                                            .appointment[idx].start!.value!.hour
                                            .toString() +
                                        ":" +
                                        Constants.appointment[idx].start!.value!
                                            .minute
                                            .toString(),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Divider(
                                    height: 5,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment:
                                          Constants.appointment[idx].status !=
                                                  AppointmentStatus.booked
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (Constants.appointment[idx].status ==
                                            AppointmentStatus.booked)
                                          TextButton.icon(
                                              onPressed: () async {
                                                await Navigator.of(context)
                                                    .push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditAppointment(
                                                      sf: widget.sf,
                                                      list: widget.listMbr,
                                                      patients: widget.patients,
                                                      editAppointment: Constants
                                                          .appointment[idx],
                                                    ),
                                                  ),
                                                );
                                                setState(() {});
                                              },
                                              icon: const Icon(Icons.edit),
                                              label: const Text(
                                                "Edit",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                ),
                                              )),
                                        if (Constants.appointment[idx].status ==
                                            AppointmentStatus.booked)
                                          TextButton.icon(
                                              onPressed: () async {
                                                _displayTextInputDialog(context,
                                                    Constants.appointment[idx]);
                                              },
                                              icon: const Icon(
                                                Icons
                                                    .cancel_schedule_send_sharp,
                                                color: Colors.red,
                                              ),
                                              label: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              )),
                                        if (Constants.appointment[idx].status !=
                                            AppointmentStatus.booked)
                                          Center(
                                              child: TextButton.icon(
                                            onPressed: null,
                                            icon: const Icon(
                                                Icons.free_cancellation_rounded,
                                                color: Colors.red),
                                            label: const Text(
                                              "Cancelled",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ))
                                      ],
                                    ),
                                  ),
                                  // const SizedBox(
                                  //   height: 3,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Container();
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
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

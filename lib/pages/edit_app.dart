import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:fhir_demo/api/fhirapi.dart';
import 'package:fhir_demo/data/appointment_details.dart';
import 'package:fhir_demo/modals/constants.dart';
import 'package:fhir_demo/modals/temp.dart';
import 'package:fhir_demo/modals/users.dart';
import 'package:fhir_demo/provider/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:textfield_search/textfield_search.dart';

class EditAppointment extends StatefulWidget {
  final List<String> list;
  final List<Patient> patients;
  final GlobalKey<ScaffoldState> sf;
  final Appointment editAppointment;
  const EditAppointment(
      {Key? key,
      required this.list,
      required this.patients,
      required this.editAppointment,
      required this.sf})
      : super(key: key);

  @override
  State<EditAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<EditAppointment> {
  String? patientname;
  String? specialty = '';
  String? typeofvisit = '';
  String? patientId;
  String? selectVal;
  String? doctor;
  String? starttime = '';
  String? endtime = '';
  DateTime? start;
  DateTime? end;
  bool isloading = false;
  bool isHosSeleted = false;
  bool? iswait;
  List<DropdownMenuItem<String>> dropDownItems = [];
  String? currentItem;
  String? currentItemPt;
  String? currentType;
  bool isload = false;
  getdo1c() async {
    print(widget.editAppointment.identifier![0].value.toString());
    Constants.result = await FirebaseFirestore.instance
        .collection("bcbsmn")
        .doc("Doctor")
        .collection(widget.editAppointment.identifier![0].value.toString());
  }

  setvalue() async {
    setState(() {
      isload = true;
    });
    // getMember();
    selectVal = widget.list[0];
    patientId = widget.list[0].split('(')[1].split(')')[0];
    patientname = widget.editAppointment.participant[0].actor!.display! +
        "(" +
        widget.editAppointment.participant[0].actor!.reference!
            .split("/")
            .last +
        ")";
    specialty = Constants.specialty[0];
    typeofvisit = Constants.typeofvisit[0];

    print("currentItemPt");
    print(widget.editAppointment.participant[0].actor!.display!);
    // currentItemPt = widget.editAppointment.participant[0].actor!.display! +
    //     "(" +
    //     widget.editAppointment.participant[0].actor!.reference!
    //         .split("/")
    //         .last +
    //     ")";

    for (int i = 0; i < widget.list.length; i++) {
      if (widget.list[i]
          .contains(widget.editAppointment.participant[0].actor!.display!)) {
        currentItemPt = widget.list[i];
        break;
      }
    }
    print(currentItemPt);
    starttime = widget.editAppointment.start.toString();
    Constants.hospitalTx.text =
        widget.editAppointment.identifier![0].value.toString();
    print(widget.editAppointment.specialty![0].coding![0].display.toString());

    getdo1c();
    List<String> l = [];
    for (int i = 0;
        i < Constants.specialtyDoc![Constants.hospitalTx.text]!.length;
        i++) {
      l.add(Constants.specialtyDoc![Constants.hospitalTx.text]![i].toString());
    }
    Constants.specialty = l;

    getdoc(Constants.hospitalTx.text);

    Constants.result!.get().then((snapshot) {
      snapshot.docs.forEach((element) {
        Constants.doctor = element.data()["names"][
            widget.editAppointment.specialty![0].coding![0].display.toString()];
      });
    });
    print(widget.editAppointment.specialty![0].coding![0].display.toString());
    currentItem =
        widget.editAppointment.specialty![0].coding![0].display.toString();
    Constants.doctorTx.text =
        widget.editAppointment.identifier![0].assigner!.display!.toString();

    currentType =
        widget.editAppointment.appointmentType!.coding![0].display.toString();

    iswait = true;
    await Future.delayed(const Duration(seconds: 3));
    isload = false;

    setState(() {});
    print("Kll");
  }

  @override
  void initState() {
    super.initState();
    setvalue();
  }

  getdoc(String hos) async {
    Constants.result = await FirebaseFirestore.instance
        .collection("bcbsmn")
        .doc("Doctor")
        .collection(hos);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //Constants.doctorTx.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(
              Icons.arrow_back,
            )),
        title: const Text(
          "Edit Appointment",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
      ),
      body: isload
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.white,
            ))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 13,
                              bottom: 13,
                            ),
                            child: Text(
                              "Person Details",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.blue,
                            height: 5,
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String>(
                              value: currentItemPt,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                ),
                              ),
                              hint: const Text('Person Name'),
                              items: widget.list.map((item) {
                                // bool isSeleted = selectVal == item.toString();
                                return DropdownMenuItem(
                                    alignment: Alignment.center,
                                    value: item,
                                    child: Container(
                                      // margin:
                                      //     const EdgeInsets.only(left: 20.0, right: 20.0),
                                      child: Text(
                                        item.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ));
                              }).toList(),
                              onChanged: (v) => setState(() {
                                setState(() {
                                  patientId = v!.split('(')[1].split(')')[0];
                                  patientname = v.split('(')[0];
                                  print(patientId! + patientname!);
                                });
                              }),
                            ),
                          ),
                          const Divider(
                            color: Colors.blue,
                            height: 2,
                          ),
                          NotificationListener(
                            onNotification: (_) {
                              if (Constants.hospitalTx.text.isNotEmpty) {
                                setState(() {
                                  isHosSeleted = true;
                                  List<String> l = [];
                                  // currentItem = Constants.specialtyDoc![
                                  //         Constants.hospitalTx.text]![0]
                                  //     .toString();

                                  for (int i = 0;
                                      i <
                                          Constants
                                              .specialtyDoc![
                                                  Constants.hospitalTx.text]!
                                              .length;
                                      i++) {
                                    l.add(Constants.specialtyDoc![
                                            Constants.hospitalTx.text]![i]
                                        .toString());
                                  }
                                  Constants.specialty = l;
                                });
                                getdoc(Constants.hospitalTx.text);
                              }

                              return true;
                            },
                            child: AbsorbPointer(
                              absorbing: true,
                              child: TextFieldSearch(
                                initialList: Constants.hospital,
                                label: '     Hospital Name',
                                decoration: const InputDecoration(
                                    hintText: 'Hospital Name',
                                    prefixIcon: Icon(
                                      Icons.health_and_safety,
                                      color: Colors.blue,
                                    )),
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                                controller: Constants.hospitalTx,
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.blue,
                            height: 2,
                          ),
                          NotificationListener(
                            onNotification: (V) {
                              if (Constants.result != null) {
                                print("K");

                                var res = Constants.result!.get();

                                Constants.result!.get().then((snapshot) {
                                  snapshot.docs.forEach((element) {
                                    Constants.doctor =
                                        element.data()["names"][specialty];
                                    setState(() {});
                                  });
                                });
                              }
                              return true;
                            },
                            child: DropdownButtonFormField<String>(
                              value: currentItem,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.accessible,
                                  color: Colors.blue,
                                ),
                              ),
                              hint: const Text('Select Specialty'),
                              items: Constants.specialty.map((item) {
                                // bool isSeleted = selectVal == item.toString();
                                return DropdownMenuItem(
                                    alignment: Alignment.center,
                                    value: item,
                                    child: Text(
                                      item.toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ));
                              }).toList(),
                              onChanged: (v) => setState(() => specialty = v),
                            ),
                          ),
                          TextFieldSearch(
                            initialList: Constants.doctor,
                            label: '     Doctor Name',
                            decoration: const InputDecoration(
                                hintText: 'Doctor Name',
                                prefixIcon: Icon(
                                  Icons.person_pin_rounded,
                                  color: Colors.blue,
                                )),
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w400),
                            controller: Constants.doctorTx,
                          ),
                          const Divider(
                            color: Colors.blue,
                            height: 2,
                          ),
                          InkWell(
                            onTap: () {
                              DatePicker.showDateTimePicker(
                                context,
                                theme: const DatePickerTheme(
                                  backgroundColor: Colors.white,
                                ),
                                showTitleActions: true,
                                onChanged: (date) {
                                  print('change $date in time zone ' +
                                      date.timeZoneOffset.inHours.toString());
                                },
                                onConfirm: (date) {
                                  print('confirm $date');
                                  setState(() {
                                    start = date;
                                    starttime = start
                                            .toString()
                                            .replaceAll(RegExp(r" "), "T") +
                                        "Z";
                                  });
                                },
                              );
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 12, bottom: 12, right: 10, left: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Appointment Time",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        if (starttime != '')
                                          Text(
                                              starttime!
                                                  .replaceAll("T", " ")
                                                  .replaceAll(".000Z", ''),
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 10,
                                              ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.blue,
                            height: 2,
                          ),
                          DropdownButtonFormField<String>(
                            value: currentType,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.add_home_work_rounded,
                                color: Colors.blue,
                              ),
                            ),
                            hint: const Text('Type of visit'),
                            items: Constants.typeofvisit.map((item) {
                              // bool isSeleted = selectVal == item.toString();
                              return DropdownMenuItem(
                                  alignment: Alignment.center,
                                  value: item,
                                  child: Text(
                                    item.toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                                  ));
                            }).toList(),
                            onChanged: (v) => setState(() => typeofvisit = v),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      child: RaisedButton(
                        onPressed: () async {
                          try {
                            setState(() {
                              isloading = true;
                            });
                            if (starttime == '' ||
                                Constants.doctorTx.text.isEmpty ||
                                Constants.hospitalTx.text.isEmpty ||
                                specialty == '' ||
                                typeofvisit == '') {
                              setState(() {
                                isloading = false;
                              });
                              return;
                            }
                            AppointmentDetails appointmentDetails =
                                AppointmentDetails(
                              identifier: [
                                Identifier(
                                    assigner: Reference(
                                      display: Constants.doctorTx.text.trim(),
                                    ),
                                    value: Constants.hospitalTx.text)
                              ],
                              appointmentType: CodeableConcept(
                                coding: [
                                  Coding(
                                    code: Code(typeofvisit!),
                                    display: typeofvisit,
                                  )
                                ],
                              ),

                              status: AppointmentStatus.booked,

                              start:
                                  Instant(DateTime.parse(starttime.toString())),
                              end: Instant(
                                  DateTime.parse('2022-09-07T11:29:12+02:00')),
                              created: FhirDateTime(DateTime.now()),
                              id: Id('1000'),
                              //slot: [Reference(display: "")],
                              participant: [
                                AppointmentParticipant(
                                    actor: Reference(
                                      display: patientname!
                                          .split('(')[0]
                                          .trim()
                                          .toString(),
                                      reference: Constants.fhirapilink +
                                          'Patient/${patientId.toString()}',
                                    ),
                                    status:
                                        AppointmentParticipantStatus.accepted,
                                    required_: AppointmentParticipantRequired
                                        .required_,
                                    type: [
                                      CodeableConcept(
                                        coding: [
                                          Coding(
                                            code: Code("ATND"),
                                            system: FhirUri(
                                                "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"),
                                          )
                                        ],
                                      ),
                                    ]),
                              ],

                              specialty: [
                                CodeableConcept(
                                  coding: [
                                    Coding(
                                      system: FhirUri('http://snomed.info/sct'),
                                      code: Code("394814009"),
                                      display: specialty,
                                    )
                                  ],
                                ),
                              ],
                            );
                            // Appointment app = await FhirApi.hapiAppointmentCreate(
                            //     appointmentDetails);
                            // String appID = app.id!.value!;
                            // Constants.users!.applist =
                            //     Constants.users!.applist + [appID];
                            // await FirebaseFirestore.instance
                            //     .collection('users')
                            //     .doc(Constants.memberid)
                            //     .update({'applist': Constants.users!.applist})
                            //     .then((_) => print('Success'))
                            //     .catchError((error) => print('Failed: $error'));
                            Appointment appointment = Appointment(
                              participant: appointmentDetails.participant,
                              id: widget.editAppointment.id,
                              status: appointmentDetails.status,
                              serviceCategory:
                                  appointmentDetails.serviceCategory,
                              serviceType: appointmentDetails.serviceType,
                              specialty: appointmentDetails.specialty,
                              appointmentType:
                                  appointmentDetails.appointmentType,
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
                              minutesDuration:
                                  appointmentDetails.minutesDuration,
                              patientInstruction:
                                  appointmentDetails.patientInstruction,
                              supportingInformation:
                                  appointmentDetails.supportingInformation,
                              meta: appointmentDetails.meta,
                              language: appointmentDetails.language,
                              resourceType: appointmentDetails.resourceType,
                              basedOn: appointmentDetails.basedOn,
                              comment: appointmentDetails.comment,
                              reasonReference:
                                  appointmentDetails.reasonReference,
                              requestedPeriod:
                                  appointmentDetails.requestedPeriod,
                            );
                            var request = FhirRequest.update(
                              base: Uri.parse(Constants.fhirapilink),
                              resource: appointment,
                            );
                            var response = await request.request(headers: {
                              'content-type':
                                  'application/fhir+json;charset=UTF-8'
                            });
                            debugPrint(request.toString());
                            Users? users = await AuthenticationService()
                                .readUsersbasedonEmail();
                            Constants.appointment = [];
                            for (int i = 0; i < users!.applist.length; i++) {
                              var newVariable =
                                  await FhirApi.hapiReadAppointment(
                                      Id(users.applist[i]));
                              Appointment p = newVariable;
                              if (!Constants.appointment.contains(p))
                                Constants.appointment.add(p);
                            }
                            print(widget.editAppointment.id);
                            await FirebaseFirestore.instance
                                .collection('timeline')
                                .doc(Constants.memberid)
                                .collection("Appointment")
                                .doc(widget.editAppointment.id!.value)
                                .update({
                              "task": {
                                "isdone": false,
                                "report": "",
                                "time": Timestamp.now(),
                                "title":
                                    "Appointment for ${patientname!.split('(')[0].trim().toString()}",
                                "type": "Appointment",
                                "appid": widget.editAppointment.id!.value,
                                "status": "Booked",
                                'isEdited': true,
                              }
                            });

                            setState(() {
                              isloading = false;
                            });
                            Navigator.pop(context, true);
                            Constants.showInSnackBar(
                                widget.sf, "Appointment Edited!", Colors.green);
                          } catch (e) {
                            Constants.showInSnackBar(
                                widget.sf, "Try again!", Colors.red);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Center(
                              child: isloading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text('Submit',
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
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

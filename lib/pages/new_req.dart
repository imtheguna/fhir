import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_demo/modals/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewReport extends StatefulWidget {
  final String mbrid;
  final GlobalKey<ScaffoldState> sf;
  const NewReport({Key? key, required this.mbrid, required this.sf})
      : super(key: key);

  @override
  State<NewReport> createState() => _NewReportState();
}

class _NewReportState extends State<NewReport> {
  List<Appointment> app = [];
  List<String> appList = [];
  Appointment? selectAPP;
  String id = '';
  void getApp() {
    for (int i = 0; i < Constants.appointment.length; i++) {
      if (Constants.appointment[i].status == AppointmentStatus.fulfilled) {
        if (!app.contains(Constants.appointment[i])) {
          app.add(Constants.appointment[i]);
          appList.add(Constants.appointment[i].id!.value!);
        }
      }
    }
  }

  void getAppSel() {
    for (int i = 0; i < Constants.appointment.length; i++) {
      if (Constants.appointment[i].id!.value == id) {
        selectAPP = Constants.appointment[i];
        setState(() {});
        return;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Request"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.blueAccent,
      body: app.length != 0
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: NotificationListener(
                      onNotification: (_) {
                        getAppSel();
                        return true;
                      },
                      child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.accessible,
                              color: Colors.blue,
                            ),
                          ),
                          hint: const Text('Select Appointment ID'),
                          items: appList.map((item) {
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
                          onChanged: (v) {
                            setState(() {
                              id = v!;
                            });
                          }),
                    ),
                  ),
                ),
                if (id != '' && selectAPP != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 9.5,
                      right: 9.5,
                    ),
                    child: Card(
                        child: Container(
                      width: double.infinity,
                      height: 60,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Person Name : "),
                              Text(selectAPP!.participant.first.actor!.display!
                                  .toString())
                            ],
                          ),
                        ),
                      ),
                    )),
                  ),
                if (id != '' && selectAPP != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 9.5,
                      right: 9.5,
                    ),
                    child: Card(
                        child: Container(
                      width: double.infinity,
                      height: 60,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Appointment Date : "),
                              Text(selectAPP!.start!.value!.year.toString() +
                                  "-" +
                                  selectAPP!.start!.value!.month.toString() +
                                  "-" +
                                  selectAPP!.start!.value!.day.toString())
                            ],
                          ),
                        ),
                      ),
                    )),
                  ),
                if (id != '' && selectAPP != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 9.5,
                      right: 9.5,
                    ),
                    child: Card(
                        child: Container(
                      width: double.infinity,
                      height: 60,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Docter Name : "),
                              Text(selectAPP!
                                  .identifier!.first.assigner!.display!
                                  .toString())
                            ],
                          ),
                        ),
                      ),
                    )),
                  ),
                if (id != '' && selectAPP != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 9.5,
                      right: 9.5,
                    ),
                    child: Card(
                        child: Container(
                      width: double.infinity,
                      height: 60,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Hostital Name : "),
                              Text(selectAPP!.identifier!.first.value!
                                  .toString())
                            ],
                          ),
                        ),
                      ),
                    )),
                  ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RaisedButton(
                    onPressed: (id == '')
                        ? null
                        : () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                });
                            await FirebaseFirestore.instance
                                .collection('Report_req')
                                .doc(widget.mbrid)
                                .collection("report")
                                .add({
                              "new": {
                                "status": true,
                                "Appid": selectAPP!.id!.value.toString(),
                                "pat_id": selectAPP!
                                    .participant.first.actor!.reference!
                                    .split("/")
                                    .last,
                                "pat_name": selectAPP!
                                    .participant.first.actor!.display
                                    .toString(),
                                "time": selectAPP!.start!.value,
                                "Hostital": selectAPP!.identifier!.first.value!
                                    .toString(),
                                "Docter": selectAPP!
                                    .identifier!.first.assigner!.display!
                                    .toString()
                              }
                            });
                            await Future.delayed(Duration(milliseconds: 500));
                            Constants.showInSnackBar(
                                widget.sf, "Request Submitted", Colors.green);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                    child: Container(
                      width: double.infinity,
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Center(
                          child: Text('Submit',
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
                ),
              ],
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

import 'package:fhir/r4.dart';
import 'package:fhir_demo/api/fhirapi.dart';
import 'package:fhir_demo/modals/constants.dart';
import 'package:fhir_demo/modals/users.dart';
import 'package:fhir_demo/pages/appointements_list.dart';
import 'package:fhir_demo/pages/book_appointment.dart';
import 'package:fhir_demo/pages/can_app.dart';
import 'package:fhir_demo/provider/google_sign_in.dart';
import 'package:flutter/material.dart';

class AppPage extends StatefulWidget {
  final List<Appointment> appointment;
  final List<Patient> patients;
  final List<String> listMbr;
  const AppPage(
      {Key? key,
      required this.appointment,
      required this.patients,
      required this.listMbr})
      : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApp();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  getApp() async {
    Users? users = await AuthenticationService().readUsersbasedonEmail();
    Constants.appointment = [];
    for (int i = 0; i < users!.applist.length; i++) {
      var newVariable = await FhirApi.hapiReadAppointment(Id(users.applist[i]));
      Appointment p = newVariable;
      if (!Constants.appointment.contains(p)) Constants.appointment.add(p);
    }
  }

  List list = [
    "Book an Appointment",
    "View Appointments",
    "Cancelled Appointments",
  ];
  List listInage = [
    "images/book.png",
    "images/insurance.png",
    "images/can.png",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
      body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (ctx, idx) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                right: 8,
                left: 8,
              ),
              child: InkWell(
                onTap: () async {
                  if (list[idx] == "View Appointments") {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AppList(
                          sf: scaffoldKey,
                          appointment: widget.appointment,
                          listMbr: widget.listMbr,
                          patients: widget.patients,
                        ),
                      ),
                    );

                    setState(() {});
                  } else if (list[idx] == "Cancelled Appointments") {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CanAPPList(
                          sf: scaffoldKey,
                          appointment: widget.appointment,
                          listMbr: widget.listMbr,
                          patients: widget.patients,
                        ),
                      ),
                    );
                  } else {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BookAppointment(
                            sf: scaffoldKey,
                            list: widget.listMbr,
                            patients: widget.patients),
                      ),
                    );

                    setState(() {});
                  }
                },
                child: Card(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.92,
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
                                image: AssetImage(listInage[idx]),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 9),
                            child: Text(list[idx]),
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
            );
          }),
    );
  }
}

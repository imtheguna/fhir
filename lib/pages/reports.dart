import 'package:fhir/r4.dart';
import 'package:fhir_demo/pages/cam_req.dart';
import 'package:fhir_demo/pages/new_req.dart';
import 'package:fhir_demo/pages/viewreports.dart';
import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  final String mbrid;
  final List<Patient> patient;
  const Reports({Key? key, required this.mbrid, required this.patient})
      : super(key: key);

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List listRpt = ["View Reports", "Request New Report", "Cancel Request"];
  List listInage = [
    "images/viewrt.png",
    "images/newrt.png",
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
          'Reports',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: 3,
          itemBuilder: (ctx, idx) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                right: 8,
                left: 8,
              ),
              child: InkWell(
                onTap: () async {
                  if (listRpt[idx] == "View Reports") {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ViewReport(
                          mbrid: widget.mbrid,
                          patient: widget.patient,
                        ),
                      ),
                    );
                  }
                  if (listRpt[idx] == "Request New Report") {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NewReport(
                          mbrid: widget.mbrid,
                          sf: scaffoldKey,
                        ),
                      ),
                    );
                  }
                  if (listRpt[idx] == "Cancel Request") {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CanReq(
                          mbrid: widget.mbrid,
                          patient: widget.patient,
                        ),
                      ),
                    );
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
                            child: Text(listRpt[idx]),
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

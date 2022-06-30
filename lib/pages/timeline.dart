import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_demo/api/download_api.dart';
import 'package:fhir_demo/pages/appointements_list.dart';
import 'package:fhir_demo/pages/can_app.dart';

import 'package:flutter/material.dart';

class TimelinePage extends StatefulWidget {
  final String mbrid;

  final List<Appointment> appointment;
  final List<Patient> patients;

  final List<String> listMbr;
  const TimelinePage(
      {Key? key,
      required this.mbrid,
      required this.appointment,
      required this.listMbr,
      required this.patients})
      : super(key: key);

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    //getAppDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Timeline"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection("timeline")
              .doc(widget.mbrid)
              .collection("Appointment")
              .get(),
          builder: (cts, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Please check the network"),
              );
            }

            return snapshot.data!.docs.length == 0
                ? Center(
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
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, idx) {
                      DocumentSnapshot doc = snapshot.data!.docs[idx];

                      return snapshot.data!.docs.isEmpty
                          ? Center(
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
                            )
                          : InkWell(
                              onTap: doc["task"]["type"] == "Appointment"
                                  ? () async {
                                      if (doc["task"]["status"] !=
                                          "Cancelled") {
                                        await Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => AppList(
                                            sf: _scaffoldKey,
                                            appointment: widget.appointment,
                                            listMbr: widget.listMbr,
                                            patients: widget.patients,
                                          ),
                                        ));
                                      }
                                      if (doc["task"]["status"] ==
                                          "Cancelled") {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => CanAPPList(
                                              sf: _scaffoldKey,
                                              appointment: widget.appointment,
                                              listMbr: widget.listMbr,
                                              patients: widget.patients,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                              child: Card(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    width: double.infinity,
                                    height: ((doc["task"]["type"] ==
                                                    "Appointment" &&
                                                doc["task"]["isdone"]
                                                        .toString() ==
                                                    "true" &&
                                                doc["task"]["status"] !=
                                                    "Cancelled") ||
                                            (doc["task"]["type"] == "Report" &&
                                                doc["task"]["isdone"]
                                                        .toString() ==
                                                    "true"))
                                        ? 140
                                        : 90,
                                    child: Stack(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                color: Colors.deepPurple[50],
                                                padding:
                                                    new EdgeInsets.all(5.0),
                                                child: Text(
                                                  (idx + 1).toString(),
                                                  style: const TextStyle(
                                                    color: Colors.deepPurple,
                                                    fontSize: 25.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                            const SizedBox(width: 15.0),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        doc["task"]["title"],
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                          fontSize: 15.0,
                                                          color: Colors.black,
                                                          letterSpacing: 1.5,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        doc["task"]["type"] +
                                                            " " +
                                                            doc["task"]
                                                                ["appid"],
                                                        style: const TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.black54,
                                                          letterSpacing: 1.5,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        ((doc["task"]["time"]
                                                                    as Timestamp)
                                                                .toDate()
                                                                .year
                                                                .toString() +
                                                            "-" +
                                                            (doc["task"]["time"]
                                                                    as Timestamp)
                                                                .toDate()
                                                                .month
                                                                .toString() +
                                                            "-" +
                                                            (doc["task"]["time"]
                                                                    as Timestamp)
                                                                .toDate()
                                                                .day
                                                                .toString() +
                                                            " " +
                                                            (doc["task"]["time"]
                                                                    as Timestamp)
                                                                .toDate()
                                                                .hour
                                                                .toString() +
                                                            ":" +
                                                            (doc["task"]["time"]
                                                                    as Timestamp)
                                                                .toDate()
                                                                .minute
                                                                .toString()),
                                                        style: const TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.black54,
                                                          letterSpacing: 1.5,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      if ((doc["task"][
                                                                      "type"] ==
                                                                  "Appointment" &&
                                                              doc["task"]["isdone"]
                                                                      .toString() ==
                                                                  "true" &&
                                                              doc["task"][
                                                                      "status"] !=
                                                                  "Cancelled") ||
                                                          (doc["task"][
                                                                      "type"] ==
                                                                  "Report" &&
                                                              doc["task"]["isdone"]
                                                                      .toString() ==
                                                                  "true"))
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          child:
                                                              TextButton.icon(
                                                                  onPressed:
                                                                      () {
                                                                    String time1 = DateTime
                                                                            .now()
                                                                        .toString()
                                                                        .replaceAll(
                                                                            " ",
                                                                            "_");
                                                                    String t = time1
                                                                        .replaceAll(
                                                                            ":",
                                                                            "_")
                                                                        .replaceAll(
                                                                            ".",
                                                                            "_");
                                                                    DownloadAPI.downloadReport(
                                                                        _scaffoldKey,
                                                                        doc["task"]
                                                                            [
                                                                            "report"],
                                                                        "/storage/emulated/0/Downloads/Report",
                                                                        t);
                                                                  },
                                                                  icon:
                                                                      const Icon(
                                                                    Icons
                                                                        .download,
                                                                    size: 15,
                                                                  ),
                                                                  label: const Text(
                                                                      "Download Report")),
                                                        )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 20.0),
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(
                                                  color: doc["task"]["isdone"]
                                                              .toString() ==
                                                          "true"
                                                      ? const Color.fromARGB(
                                                          255, 0, 116, 4)
                                                      : Colors.red,
                                                  width: 5,
                                                )),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (doc["task"]["type"] ==
                                            "Appointment")
                                          Align(
                                              alignment: Alignment.bottomRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0,
                                                    bottom: 8,
                                                    right: 10),
                                                child: Text(
                                                  doc["task"]["status"]
                                                          .toString() +
                                                      (doc["task"][
                                                                  "isEdited"] ==
                                                              true
                                                          ? " - Edited"
                                                          : ''),
                                                  style: TextStyle(
                                                    color: doc["task"]["isdone"]
                                                                .toString() ==
                                                            "true"
                                                        ? const Color.fromARGB(
                                                            255, 0, 116, 4)
                                                        : Colors.red,
                                                  ),
                                                ),
                                              ))
                                      ],
                                    ),
                                  )),
                            );
                    });
          },
        ),
      ),
    );
  }
}

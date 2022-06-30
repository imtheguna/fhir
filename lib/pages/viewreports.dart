import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:fhir_demo/api/download_api.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:fhir_demo/api/fhirapi.dart';

class ViewReport extends StatefulWidget {
  final String mbrid;
  final List<Patient> patient;
  const ViewReport({Key? key, required this.mbrid, required this.patient})
      : super(key: key);

  @override
  State<ViewReport> createState() => _ViewReportState();
}

class _ViewReportState extends State<ViewReport> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );
  Patient? getpt(String id) {
    for (int i = 0; i < widget.patient.length; i++) {
      if (widget.patient[i].id!.value == id) {
        return widget.patient[i];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Reports"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection("reports")
              .doc(widget.mbrid)
              .collection("reports")
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

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, idx) {
                  DocumentSnapshot doc = snapshot.data!.docs[idx];
                  Patient? ps = getpt(doc["report"]["pat_id"]);
                  print(ps!.id!.value);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpansionTileCard(
                      leading: CircleAvatar(
                        child: CachedNetworkImage(
                          imageUrl: ps.photo![0].url!.value.toString(),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.fitHeight),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      title: Text(doc["report"]["title"]),
                      subtitle: Text((doc["report"]["app_time"] as Timestamp)
                              .toDate()
                              .year
                              .toString() +
                          "-" +
                          (doc["report"]["app_time"] as Timestamp)
                              .toDate()
                              .month
                              .toString() +
                          "-" +
                          (doc["report"]["app_time"] as Timestamp)
                              .toDate()
                              .day
                              .toString()),
                      children: <Widget>[
                        const Divider(
                          thickness: 1.0,
                          height: 1.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Person Name: " + doc["report"]["pat_name"],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontSize: 14),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "Docter Name: " + doc["report"]["dr"],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontSize: 14),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "Hostital Name: " + doc["report"]["hos_name"],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontSize: 14),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "Specialty : " + doc["report"]["specialty"],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontSize: 14),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "Appointment Type: " + doc["report"]["type"],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceAround,
                          buttonHeight: 52.0,
                          buttonMinWidth: 90.0,
                          children: <Widget>[
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {},
                              child: Column(
                                children: const <Widget>[
                                  Icon(Icons.open_in_new),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Text('View'),
                                ],
                              ),
                            ),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () async {
                                String time1 = DateTime.now()
                                    .toString()
                                    .replaceAll(" ", "_");
                                String t = time1
                                    .replaceAll(":", "_")
                                    .replaceAll(".", "_");
                                DownloadAPI.downloadReport(
                                    _scaffoldKey,
                                    doc["report"]["link"],
                                    "/storage/emulated/0/Downloads/Report",
                                    doc["report"]["app_id"] +
                                        "_" +
                                        doc["report"]["pat_name"] +
                                        "_" +
                                        t);
                              },
                              child: Column(
                                children: const <Widget>[
                                  Icon(Icons.download),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Text('Download'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}

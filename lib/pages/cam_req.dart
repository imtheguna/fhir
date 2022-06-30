import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_demo/modals/constants.dart';
import 'package:flutter/material.dart';

class CanReq extends StatefulWidget {
  final String mbrid;

  final List<Patient> patient;
  const CanReq({Key? key, required this.mbrid, required this.patient})
      : super(key: key);

  @override
  State<CanReq> createState() => _CanReqState();
}

class _CanReqState extends State<CanReq> {
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardB = new GlobalKey();
  List<GlobalKey<ExpansionTileCardState>> keys = [];
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
  void initState() {
    // TODO: implement initState
    super.initState();
    keys = [];
    for (int i = 0; i < widget.patient.length; i++) {
      keys.add(GlobalKey());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              .collection("Report_req")
              .doc(widget.mbrid)
              .collection("report")
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

            return (snapshot.data!.docs.isNotEmpty)
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, idx) {
                      DocumentSnapshot doc = snapshot.data!.docs[idx];
                      Patient? ps = getpt(doc["new"]["pat_id"]);
                      print(ps!.id!.value);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ExpansionTileCard(
                          leading: CircleAvatar(
                            child: CachedNetworkImage(
                              imageUrl: ps.photo![0].url!.value.toString(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fitHeight),
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
                          title: Row(
                            children: [
                              Text(doc["new"]["pat_name"]),
                              Text(
                                (doc["new"]["status"] == true)
                                    ? " Submiited"
                                    : " Cancelled",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: (doc["new"]["status"] == true)
                                        ? Color.fromARGB(255, 0, 128, 4)
                                        : Color.fromARGB(255, 197, 17, 4)),
                              )
                            ],
                          ),
                          subtitle: Text((doc["new"]["time"] as Timestamp)
                                  .toDate()
                                  .year
                                  .toString() +
                              "-" +
                              (doc["new"]["time"] as Timestamp)
                                  .toDate()
                                  .month
                                  .toString() +
                              "-" +
                              (doc["new"]["time"] as Timestamp)
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
                                      "Person Name: " + doc["new"]["pat_name"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(fontSize: 14),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "Docter Name: " + doc["new"]["Docter"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(fontSize: 14),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "Hostital Name: " +
                                          doc["new"]["Hostital"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(fontSize: 14),
                                    ),
                                    const SizedBox(
                                      height: 3,
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
                                  onPressed: (doc["new"]["status"] != true)
                                      ? null
                                      : () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              });
                                          await FirebaseFirestore.instance
                                              .collection('Report_req')
                                              .doc(widget.mbrid)
                                              .collection("report")
                                              .doc(snapshot.data!.docs[idx].id)
                                              .update({
                                            "new": {
                                              "status": false,
                                              "Appid": doc["new"]["Appid"],
                                              "pat_id": doc["new"]["pat_id"],
                                              "pat_name": doc["new"]
                                                  ["pat_name"],
                                              "time": doc["new"]["time"],
                                              "Hostital": doc["new"]
                                                  ["Hostital"],
                                              "Docter": doc["new"]["Docter"]
                                            }
                                          });
                                          setState(() {});

                                          Navigator.pop(context);
                                        },
                                  child: Column(
                                    children: const <Widget>[
                                      Icon(Icons.cancel_outlined),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Text('Cancel'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    })
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
                  );
          },
        ),
      ),
    );
  }
}

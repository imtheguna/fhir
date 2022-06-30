import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:fhir_demo/api/fhirapi.dart';
import 'package:fhir_demo/modals/constants.dart';
import 'package:fhir_demo/modals/users.dart';
import 'package:fhir_demo/provider/google_sign_in.dart';
import 'package:fhir_demo/provider/gridviewpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Home> {
  bool isPageloading = false;
  Person? person;
  Users? users;
  int count = 0;
  List<Patient> patients = [];
  List<String> listMbrforapp = [];

  Future<Person>? getPerson() async {
    users = await AuthenticationService().readUsersbasedonEmail();
    var request = FhirRequest.read(
      base: Uri.parse(Constants.fhirapilink),
      type: R4ResourceType.Person,
      id: Id(users!.memberid),
    );
    Constants.users = users;
    QuerySnapshot querySnapshot = await AuthenticationService().readDoc();
    // Constants.doctor =
    //     (querySnapshot.docs[0].data() as Map<String, dynamic>)['names'];

    Constants.hospital =
        (querySnapshot.docs[1].data() as Map<String, dynamic>)['name'];

    Constants.memberid = users!.memberid;
    Resource? response = await request
        .request(headers: {'content-type': 'application/fhir+json'});
    patients = [];
    listMbrforapp = [];

    for (int i = 0; i < users!.grpmbrlist.length; i++) {
      Patient p = await FhirApi.hapiReadPatient(Id(users!.grpmbrlist[i]));
      if (!patients.contains(p)) {
        patients.add(p);
        listMbrforapp.add(p.name![0].given!.first + " (" + p.id!.value! + ")");
      }
    }
    Constants.applist = users!.applist;
    Constants.appointment = [];
    for (int i = 0; i < users!.applist.length; i++) {
      Appointment p = await FhirApi.hapiReadAppointment(Id(users!.applist[i]));
      if (!Constants.appointment.contains(p)) Constants.appointment.add(p);
    }
    for (int i = 0; i < Constants.hospital.length; i++) {
      final result = await FirebaseFirestore.instance
          .collection("bcbsmn")
          .doc("Select_Specialty")
          .collection(Constants.hospital[i]);

      result.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          Constants.specialtyDoc!
              .addAll({Constants.hospital[i]: element.data()["Types"]});
        });
      });
    }
    ;

    return (response as Person);
  }

  @override
  void initState() {
    super.initState();
    getPerson();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Constants.book_app_PaId.dispose();
    // Constants.book_app_name.dispose();
    // Constants.disp.dispose();
    // Constants.email.dispose();
    // Constants.pass1.dispose();
    // Constants.pass2.dispose();
    // Constants.pass2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        body: StreamBuilder<Person>(
          stream: Stream.fromFuture(getPerson()!),
          builder: (cts, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (snap.hasError) {
              return const Center(
                child: Text("Error1"),
              );
            } else if (snap.hasData) {
              isPageloading = true;

              person = snap.data;
              AuthenticationService.readcount();
              return SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 35,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CachedNetworkImage(
                              imageUrl: person!.photo!.url!.value.toString(),
                              imageBuilder: (context, imageProvider) => Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fitHeight),
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                width: 30,
                                height: 30,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            Expanded(
                              child: Text(
                                " Hello " + person!.name![0].given![0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.search,
                              color: Colors.white,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        GridWidget(
                          person: person!,
                          list: const ["My Profile", "My Group"],
                          listImage: const [
                            "images/prof.png",
                            "images/grp.png"
                          ],
                          count: 2,
                          users: users!,
                          patients: patients,
                          appointment: Constants.appointment,
                          listMbrforapp: listMbrforapp,
                        ),
                        Stack(
                          children: [
                            GridWidget(
                              person: person!,
                              list: const ["My Appointments"],
                              listImage: const ["images/app.png"],
                              count: 1,
                              users: users!,
                              patients: patients,
                              appointment: Constants.appointment,
                              listMbrforapp: listMbrforapp,
                            ),
                            if (Constants.countlist.isNotEmpty)
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, right: 12),
                                  child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Text(
                                          Constants.countlist.length.toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      )),
                                ),
                              )
                          ],
                        ),
                        GridWidget(
                          person: person!,
                          list: const ["My Timeline", "My Reports"],
                          listImage: const [
                            "images/time.png",
                            "images/report.png"
                          ],
                          count: 2,
                          users: users!,
                          patients: patients,
                          appointment: Constants.appointment,
                          listMbrforapp: listMbrforapp,
                        ),
                        GridWidget(
                          person: person!,
                          list: const ["My Medications"],
                          listImage: const ["images/medic.png"],
                          count: 1,
                          users: users!,
                          patients: patients,
                          appointment: Constants.appointment,
                          listMbrforapp: listMbrforapp,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Connecting...")
                ],
              ),
            );
          },
        ));
  }
}

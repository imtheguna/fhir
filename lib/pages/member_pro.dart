import 'package:cached_network_image/cached_network_image.dart';
import 'package:fhir/r4.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class memberProfile extends StatefulWidget {
  final Person person;
  const memberProfile({Key? key, required this.person}) : super(key: key);

  @override
  State<memberProfile> createState() => _memberProfileState();
}

class _memberProfileState extends State<memberProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.40,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.40,
                    child: CachedNetworkImage(
                      imageUrl: widget.person.photo!.url!.value.toString(),
                      imageBuilder: (context, imageProvider) => Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.40,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.40,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    color: Colors.red,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2, top: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 35),
                      child: Text(
                        widget.person.name![0].given!.first +
                            " " +
                            widget.person.name![0].family!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(
                        widget.person.telecom![0].value!,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.person_pin_rounded,
                color: Colors.orange,
              ),
              title: const Text(
                "Member Id",
                style: TextStyle(fontSize: 13),
              ),
              subtitle: Text(widget.person.id!.value!),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Divider(
                height: 2,
                color: Colors.black26,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.boy_outlined,
                color: Colors.orange,
              ),
              title: const Text(
                "Gender",
                style: TextStyle(fontSize: 13),
              ),
              subtitle: Text(
                (widget.person.gender != PatientGender.male
                    ? "Male"
                    : "Female"),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Divider(
                height: 2,
                color: Colors.black26,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.phone,
                color: Colors.orange,
              ),
              title: const Text(
                "Phone",
                style: TextStyle(fontSize: 13),
              ),
              subtitle: Text(widget.person.telecom![1].value!),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Divider(
                height: 2,
                color: Colors.black26,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.date_range_sharp,
                color: Colors.orange,
              ),
              title: const Text(
                "birthDate",
                style: TextStyle(fontSize: 13),
              ),
              subtitle: Text(widget.person.birthDate!.value!.year.toString() +
                  "-" +
                  widget.person.birthDate!.value!.month.toString() +
                  "-" +
                  widget.person.birthDate!.value!.day.toString()),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Divider(
                height: 2,
                color: Colors.black26,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.orange,
              ),
              title: const Text(
                "Organization",
                style: TextStyle(fontSize: 13),
              ),
              subtitle: Text(widget.person.managingOrganization!.display!),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Divider(
                height: 2,
                color: Colors.black26,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
              },
              child: const ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Divider(
                height: 2,
                color: Colors.black26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

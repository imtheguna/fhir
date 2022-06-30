import 'package:fhir/r4.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatelessWidget {
  final Patient patient;
  const ProfilePage({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CachedNetworkImage(
                imageUrl: patient.photo![0].url!.value.toString(),
                imageBuilder: (context, imageProvider) => Card(
                  elevation: 2,
                  shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 2),
                      borderRadius: BorderRadius.horizontal()),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.33,
                    height: MediaQuery.of(context).size.height * 0.26,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.fitHeight),
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  width: MediaQuery.of(context).size.width * 0.30,
                  height: MediaQuery.of(context).size.height * 0.26,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8,
                    left: 4,
                    right: 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name : " +
                            patient.name![0].given!.first +
                            " " +
                            patient.name![0].family!,
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Gender : " +
                            (patient.gender == PatientGender.male
                                ? "Male"
                                : "Female"),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Gmail : " + patient.telecom![0].value!,
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Phone : " + patient.telecom![1].value!,
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Address :\n" +
                            patient.address![0].city.toString() +
                            " ," +
                            patient.address![0].country.toString() +
                            " ," +
                            patient.address![0].state.toString() +
                            " ," +
                            patient.address![0].postalCode.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.57,
                height: MediaQuery.of(context).size.height * 0.26,
              )
            ],
          ),
        ],
      ),
    );
  }
}

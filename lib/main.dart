import 'package:fhir/r4.dart';
import 'package:fhir_demo/api/fhirapi.dart';
import 'package:fhir_demo/modals/temp.dart';
import 'package:fhir_demo/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.roboto().fontFamily,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Patient? patient;
  Future<void> getMydetails() async {
    //940

    patient = await FhirApi.hapiReadPatient(Id('914'));
  }

  @override
  void initState() {
    super.initState();
    getMydetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fhir"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () async {
                  //   final List<String> parameters = ['_reference=Patient'];
                  //   final request = FhirRequest.search(
                  //     base: Uri.parse(Constants.fhirapilink),
                  //     type: R4ResourceType.Appointment,
                  //     parameters: parameters,
                  //   );
                  //   var response = await request.request(
                  //       headers: {'content-type': 'application/fhir+json'});
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => TimelinePage(
                  //       bundle: (response as Bundle),
                  //       patient: patient!,
                  //     ),
                  //   ));
                  // },
                },
                child: const Text("Timeline Page")),
            TextButton(
                onPressed: () async {}, child: const Text("Patient Profile")),
            TextButton(
                onPressed: () async {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) =>
                  //         BookAppointment(patient: patient!)));
                },
                child: const Text("Book Appointment")),
            TextButton(onPressed: () async {}, child: const Text("Login")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var personDetails = await FhirApi.hapiPersonCreate(
              personDetails: TempData.personDetails);
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}

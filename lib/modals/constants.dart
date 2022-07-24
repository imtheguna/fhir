import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_demo/modals/users.dart';
import 'package:flutter/material.dart';

class Constants {
  static void showInSnackBar(
      GlobalKey<ScaffoldState> _scaffoldKey, String value, Color? color) {
    _scaffoldKey.currentState!.showSnackBar(
        new SnackBar(content: new Text(value), backgroundColor: color));
  }

  static final memberidtest = TextEditingController();
  static String fhirapilink ='';
      
  static final book_app_name = TextEditingController();
  static final book_app_PaId = TextEditingController();
  static final email = TextEditingController();
  static final disp = TextEditingController();
  static List<dynamic> doctor = [];
  static List<dynamic> hospital = [];
  static String memberid = '';
  // static List<dynamic> specialty = [];
  // static List<dynamic> typeofvisit = [];
  static final pass1 = TextEditingController();
  static final password = TextEditingController();
  static final pass2 = TextEditingController();
  static final TextEditingController doctorTx = TextEditingController();
  static final TextEditingController hospitalTx = TextEditingController();
  static final TextEditingController specialtyTx = TextEditingController();
  static final TextEditingController typeofvisitTx = TextEditingController();
  static final TextEditingController cancel = TextEditingController();
  static late List<dynamic> applist = ["1", "4"];
  static Users? users;
  static List<Appointment> appointment = [];
  static CollectionReference<Map<String, dynamic>>? result;
  static final Map<String, List<dynamic>>? specialtyDoc = {};
  static List<String> specialty = [
    'General Discussion',
    'Paedetrician',
    'Pulmonology',
    'Others'
  ];
  static final List<String> typeofvisit = [
    'New visit',
    'Followup',
    'Review visit'
  ];
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
  static int countAPP = 0;
  static List<String> countlist = [];
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fhir_demo/api/fhirapi.dart';
import 'package:fhir_demo/data/groupdetails.dart';
import 'package:fhir_demo/modals/users.dart';
import 'package:fhir_demo/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:fhir_demo/modals/constants.dart';
import 'package:flutter/material.dart';
// class GoogleSignInProvider extends ChangeNotifier {
//   final googleSignin = GoogleSignIn();
//   GoogleSignInAccount? _user;
//   GoogleSignInAccount get user => _user!;

//   Future googleLogin() async {
//     final googleUser = await googleSignin.signIn();
//     if (googleUser == null) return;
//     _user = googleUser;
//     final googleAuth = await googleUser.authentication;

//     final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

//     await FirebaseAuth.instance.signInWithCredential(credential);

//     notifyListeners();
//   }
// }

class AuthenticationService {
  Future<QuerySnapshot> readDoc() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("bcbsmn").get();
    //print(querySnapshot.docs[2].get("Care & Cure Hospital"));
    return querySnapshot;
  }

  static getcount() async {
    QuerySnapshot querySnapshot1 =
        await FirebaseFirestore.instance.collection("appview").get();

    for (int i = 0; i < querySnapshot1.docs.length; i++) {
      var p = querySnapshot1.docs[i].data() as Map<String, dynamic>;
      Constants.countAPP = p["views"].length;
    }
  }

  static updatecount(String id) async {
    QuerySnapshot querySnapshot1 =
        await FirebaseFirestore.instance.collection("appview").get();
    List<String> l = [];
    for (int i = 0; i < querySnapshot1.docs.length; i++) {
      var p = querySnapshot1.docs[i].data() as Map<String, dynamic>;
      for (int j = 0; j < p["views"].length; j++) {
        l.add(p["views"][j]);
      }
    }

    await FirebaseFirestore.instance
        .collection('appview')
        .doc(Constants.memberid)
        .update({
      "views": l + [id]
    });
    Constants.countlist = l;
  }

  static readcount() async {
    QuerySnapshot querySnapshot1 =
        await FirebaseFirestore.instance.collection("appview").get();
    List<String> l = [];
    for (int i = 0; i < querySnapshot1.docs.length; i++) {
      var p = querySnapshot1.docs[i].data() as Map<String, dynamic>;
      for (int j = 0; j < p["views"].length; j++) {
        l.add(p["views"][j]);
      }
    }

    Constants.countlist = l;
  }

  static deletecount(String id) async {
    QuerySnapshot querySnapshot1 =
        await FirebaseFirestore.instance.collection("appview").get();
    List<String> l = [];
    for (int i = 0; i < querySnapshot1.docs.length; i++) {
      var p = querySnapshot1.docs[i].data() as Map<String, dynamic>;
      for (int j = 0; j < p["views"].length; j++) {
        l.add(p["views"][j]);
      }
    }

    l.remove(id);

    await FirebaseFirestore.instance
        .collection('appview')
        .doc(Constants.memberid)
        .update({"views": l});
    Constants.countlist = l;
  }

  Future<Users?> readUsersbasedonEmail() async {
    await Future.delayed(Duration(seconds: 5));
    List<Users> list = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();
    print(querySnapshot.docs.length);
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      Users u = Users.fromJson(a.data() as Map<String, dynamic>);

      if (u.email == FirebaseAuth.instance.currentUser!.email) {
        return u;
      }
    }
  }

  Future<Users?> readUsers(String id) async {
    try {
      final data =
          await FirebaseFirestore.instance.collection("users").doc(id).get();

      return Users.fromJson(data.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  Future<bool> createuserdetails(Users users) async {
    try {
      final doc =
          FirebaseFirestore.instance.collection('users').doc(users.memberid);
      await doc.set(users.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  Future signin(String email, String passowd, BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(), password: passowd.trim());
  }

  Future signup(String id, String name, BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey) async {
    try {
      // var recRes = await FhirApi.hapiDeleteRes(R4ResourceType.Group, '945');
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: Constants.email.text.trim(),
          password: Constants.pass1.text.trim());
      print("Acc Crd");
      Constants.showInSnackBar(scaffoldKey, "Account Created! ", Colors.green);
      GroupDetails grp = GroupDetails(
        actual: Boolean(true),
        name: name + " Group ($id)",
        active: Boolean(true),
        id: Id('1000'),
        type: GroupType.animal,
        characteristic: [
          GroupCharacteristic(
            exclude: Boolean(false),
            code: CodeableConcept(text: 'Gender'),
            valueCodeableConcept: CodeableConcept(text: 'mixed'),
          ),
        ],
        quantity: UnsignedInt(
          6,
        ),
      );
      var group = await FhirApi.hapiGroupCreate(grp);
      print(group.id);
      bool isdone = await createuserdetails(Users(
          applist: ["1238"],
          email: Constants.email.text.trim(),
          grpId: group.id!.value!,
          grpmbrlist: ['957', '959', '960'],
          memberid: id));
      print("Use Crd");
      if (isdone) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print(e);
      Constants.showInSnackBar(scaffoldKey, e.message!, Colors.red);
    }
  }
}

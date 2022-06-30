import 'dart:io';

import 'package:fhir_demo/modals/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/material.dart';

class DownloadAPI {
  static downloadReport(GlobalKey<ScaffoldState> _scaffoldKey, String orinalUrl,
      String path, String filename) async {
    try {
      var status = await Permission.storage.request();
      if (status.isDenied) {
        Constants.showInSnackBar(_scaffoldKey, "Permission Denied", Colors.red);
        return;
      }
      Directory(path).createSync(recursive: true);

      if (status.isGranted) {
        final taskId = await FlutterDownloader.enqueue(
          url: orinalUrl,
          savedDir: path,
          showNotification: true,
          fileName: filename + ".pdf",
          openFileFromNotification: true,
        );
        Constants.showInSnackBar(
            _scaffoldKey, "Download Started", Colors.green);
      }
    } catch (e) {
      print(e);
      Constants.showInSnackBar(
          _scaffoldKey, "Something went wrong! Please try again", Colors.red);
    }
  }
}

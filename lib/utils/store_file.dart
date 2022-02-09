import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:android_intent/android_intent.dart';

class StoreFile {
  String filename = '';
  Future<Directory> _getDownloadDirectory() async {
    Directory externalStorageDirectory;
    if (Platform.isAndroid) {
      externalStorageDirectory = await DownloadsPathProvider.downloadsDirectory;
    } else

      // in this example we are using only Android and iOS so I can assume
      // that you are not trying it for other platforms and the if statement
      // for iOS is unnecessary

      // iOS directory visible to user
      externalStorageDirectory = await getApplicationDocumentsDirectory();
    var path = externalStorageDirectory.path;
    // }
    Directory _appDocDirFolder = Directory('${path}/CountSystem/');
    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      filename = "${await _appDocDirFolder.list().length + 1}";
    } else {
      //if folder not exists create folder and then return its path
      _appDocDirFolder = await _appDocDirFolder.create(recursive: true);
      filename = "${await _appDocDirFolder.list().length + 1}";
    }
    return _appDocDirFolder;
  }

  Future<PermissionStatus> checkPermission() async {
    var statuses = await Permission.storage.request();
    return statuses;
  }

  Future<bool> _requestPermissions() async {
    var permission = await checkPermission();

    if (permission != PermissionStatus.granted) {
      await Permission.storage.request();
      permission = await checkPermission();
    }

    return permission == PermissionStatus.granted;
  }

  Future<String> inti(Excel file) async {
    return await _download(file);
  }

  Future<String> _download(Excel file) async {
    final isPermissionStatusGranted = await _requestPermissions();

    if (isPermissionStatusGranted) {
      final dir = await _getDownloadDirectory();
      filename = 'Reports ' + DateFormat('yyyy-MM-dd').format(DateTime.now());
      final savePath = path.join(dir.path, filename + '.xlsx');
      print(dir);
      print(savePath);
      // File createFile = File(savePath);
      // createFile = file as File;
      file.encode().then((onValue) {
        File(savePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(onValue);
      });
      // await _startDownload(savePath, url);
      return savePath;
    } else {
      // handle the scenario when user declines the permissions
    }
    return null;
  }
}

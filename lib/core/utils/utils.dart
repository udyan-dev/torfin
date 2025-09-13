import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../src/data/engine/engine.dart';
import '../../src/data/engine/session.dart';
import 'string_constants.dart';

Future<int> getAndroidSdkVersion() async {
  if (!Platform.isAndroid) return 0;

  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  return androidInfo.version.sdkInt;
}

List<bool> convertBitfieldToBoolList(Uint8List bitfield, int pieceCount) {
  final List<bool> piecesAsBool = [];
  int pieceIndex = 0;

  for (int byte in bitfield) {
    for (int bitIndex = 7; bitIndex >= 0; bitIndex--) {
      if (pieceIndex >= pieceCount) {
        return piecesAsBool;
      }

      final int bit = (byte >> bitIndex) & 1;
      piecesAsBool.add(bit == 1);
      pieceIndex++;
    }

    if (pieceIndex >= pieceCount) {
      return piecesAsBool;
    }
  }

  return piecesAsBool;
}

Future<void> initDefaultDownloadDir(Engine engine) async {
  final session = await engine.fetchSession();
  final downloadDir = await ExternalPath.getExternalStoragePublicDirectory(
    ExternalPath.DIRECTORY_DOWNLOAD,
  );

  // Default download directory set by transmission is not correct.
  // See tr_getDefaultDownloadDir() in platform.cc
  if (session.downloadDir != downloadDir) {
    final sessionUpdate = SessionBase(downloadDir: downloadDir);
    await session.update(sessionUpdate);
  }
}

Future<String?> getDownloadDirectory() async {
  final androidSdkVersion = await getAndroidSdkVersion();
  if (androidSdkVersion <= 29) {
    final isGranted = await Permission.storage.isGranted;
    if (!isGranted) {
      final status = await Permission.storage.request();
      if (status != PermissionStatus.granted) {
        throw Exception(storagePermissionNotGranted);
      }
    }
  }
  return await ExternalPath.getExternalStoragePublicDirectory(
    ExternalPath.DIRECTORY_DOWNLOAD,
  );
}

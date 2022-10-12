import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:mobile_number/mobile_number.dart';

class DeviceInfo {
  static final _deviceInfoPlugin = DeviceInfoPlugin();

  static Future<String> getBrandDevice() async {
    // manufacturer
    if (Platform.isAndroid) {
      final info = await _deviceInfoPlugin.androidInfo;
      return "${info.manufacturer}";
    } else {
      throw UnimplementedError();
    }
  }

  // sim
  static Future<bool> getSimInfo() async {
    var _simCard = await MobileNumber.getSimCards!;
    if (_simCard.isNotEmpty) {
      return Future<bool>.value(true);
    }
    return Future<bool>.value(false);
  }

  // emulator or not
  static Future<bool> getEmulatorInfo() async {
    final info = await _deviceInfoPlugin.androidInfo;
    if (info.isPhysicalDevice!) {
      return Future<bool>.value(true);
    }
    return Future<bool>.value(false);
  }
}

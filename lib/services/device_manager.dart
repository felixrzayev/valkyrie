import 'package:flutter/material.dart';
import 'package:valkyrie/services/device_info.dart';

class DeviceInfoNotifier with ChangeNotifier {
  String _brandDevice = "";
  bool? _simDevice;
  bool? _physicalPhone;

  String get brandDevice => _brandDevice;
  bool? get simDevice => _simDevice;
  bool? get physicalPhone => _physicalPhone;

  DeviceInfoNotifier() {
    DeviceInfo.getBrandDevice().then((value) {
      _brandDevice = value;
      debugPrint("DEVICE INFO: What is the brand of the phone? $value");
    });

    DeviceInfo.getSimInfo().then((value) {
      _simDevice = value;
      debugPrint("DEVICE INFO: Does phone have sim card ? $value");
    });

    DeviceInfo.getEmulatorInfo().then((value) {
      _physicalPhone = value;
      debugPrint("DEVICE INFO: Is it real physical device ? $value");
    });

    notifyListeners();
  }
}

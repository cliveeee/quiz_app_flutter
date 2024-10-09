import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/components/widgets/alert_dialog.dart';
// import 'package:flutter_tutorials/common/ui/widgets/app_alert_dialog.dart';
import 'package:quiz_app_flutter/services/permission/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerService implements PermissionService {
  @override
  Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }

  @override
  Future<PermissionStatus> requestPhotosPermission() async {
    return await Permission.photos.request();
  }

  @override
  Future<bool> handleCameraPermission(BuildContext context) async {
    PermissionStatus cameraPermissionStatus = await requestCameraPermission();

    if (cameraPermissionStatus != PermissionStatus.granted) {
      print('Permission to camera was not granted!');
      await showDialog(
        context: context,
        builder: (_context) => AppAlertDialog(
          onConfirm: () => openAppSettings(),
          title: 'Camera Permission',
          subtitle:
              'You need to enable camera permissions to use this feature. Would you like to go to app settings to give camera permission?',
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Future<bool> handlePhotosPermission(BuildContext context) async {
    PermissionStatus photosPermissionStatus = await requestPhotosPermission();

    if (photosPermissionStatus != PermissionStatus.granted) {
      print('Permission to photos not granted!');
      await showDialog(
        context: context,
        builder: (_context) => AppAlertDialog(
          onConfirm: () => openAppSettings(),
          title: 'Photos Permission',
          subtitle:
              'You need to enable photos permissions to use this feature. Would you like to go to app settings to give photos permission?',
        ),
      );
      return false;
    }
    return true;
  }
}

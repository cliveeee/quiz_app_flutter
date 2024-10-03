import 'package:get_it/get_it.dart';
import 'package:quiz_app_flutter/services/media/media_service.dart';
import 'package:quiz_app_flutter/services/media/media_service_interface.dart';
import 'package:quiz_app_flutter/services/permission/PermissionHandlerService.dart';
import 'package:quiz_app_flutter/services/permission/permission_service.dart';

final getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerSingleton<PermissionService>(PermissionHandlerService());
  getIt.registerSingleton<MediaServiceInterface>(MediaService());
}

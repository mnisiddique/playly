import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:playly/core/service/platform/android_api_level_service.dart';
import 'package:playly/core/service/platform/platform_identifier.dart';
import 'package:playly/core/service/platform/supported_api_level/supported_api_level.dart';
import 'package:playly/core/service/platform/supported_platform/supported_platform.dart';
import 'package:playly/res/index.dart';

enum AppPermissionStatus { denied, granted, permanentlyDenied }

extension AppPermissionStatusExt on PermissionStatus {
  AppPermissionStatus toAppPermissionStatus() {
    final flags = [isDenied, isGranted, isPermanentlyDenied];
    int trueIndex = flags.indexWhere((flag) => flag == true);
    return trueIndex < 0
        ? AppPermissionStatus.denied
        : AppPermissionStatus.values[trueIndex];
  }
}

abstract class RequestPermission {
  Future<AppPermissionStatus> call();

  Future<AppPermissionStatus> request(Permission permission) async {
    PermissionStatus status = await permission.status;
    if (!status.isGranted) {
      status = await permission.request();
      return status.toAppPermissionStatus();
    }
    return AppPermissionStatus.granted;
  }
}

@named
@Injectable(as: RequestPermission)
class RequestAudioPermission extends RequestPermission {
  final Permission _audioPermission;
  final Permission _storagePermission;
  final Permission _iosMediaLibraryPermission;
  final PlatformIdentifierService _platformIdentifierService;
  final AndroidApiLevelService _androidApiLevelService;

  RequestAudioPermission({
    @Named(skAudioPermission) required Permission audioPermission,
    @Named(skStoragePermission) required Permission storagePermission,
    @Named(skIosMediaLibraryPermission) required Permission mediaLibraryPermission,
    required PlatformIdentifierService platformIdentifierService,
    required AndroidApiLevelService androidApiLevelService,
  }) : _audioPermission = audioPermission,
       _storagePermission = storagePermission,
       _androidApiLevelService = androidApiLevelService,
       _iosMediaLibraryPermission = mediaLibraryPermission,
       _platformIdentifierService = platformIdentifierService;

  @override
  Future<AppPermissionStatus> call() {
    final platform = _platformIdentifierService.identifyCurrentPlatform();
    return platform.when(
      ios: () async {
        final status = await _iosMediaLibraryPermission.status;
        return status.toAppPermissionStatus();
      },
      android: () async {
        final apiLevel = await _androidApiLevelService.getApiLevel();
        return apiLevel.when(
          android13Plus: () => request(_audioPermission),
          android12OrBelow: () => request(_storagePermission),
        );
      },
    );
  }
}

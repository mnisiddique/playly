import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:playly/core/service/platform/platform_identifier.dart';
import 'package:playly/core/service/platform/supported_api_level/supported_api_level.dart';
import 'package:playly/core/service/platform/supported_platform/supported_platform.dart';

abstract class AndroidApiLevelService {
  Future<SupportedApiLevel> getApiLevel();
}

@Injectable(as: AndroidApiLevelService)
class AndroidApiLevelServiceImpl implements AndroidApiLevelService {
  final DeviceInfoPlugin _deviceInfo;
  final PlatformIdentifierService _platformIdentifierService;

  AndroidApiLevelServiceImpl({
    required DeviceInfoPlugin deviceInfo,
    required PlatformIdentifierService platformIdentifierService,
  }) : _platformIdentifierService = platformIdentifierService,
       _deviceInfo = deviceInfo;
  @override
  Future<SupportedApiLevel> getApiLevel() async {
    final platform = _platformIdentifierService.identifyCurrentPlatform();
    return platform.when(
      ios: () => throw PlatformException(
        code: "-007",
        message: "Current Platform(iOS) Is Not Supported",
      ),
      android: () async {
        final androidInfo = await _deviceInfo.androidInfo;
        final sdkInt = androidInfo.version.sdkInt;
        return sdkInt >= 33
            ? SupportedApiLevel.android13Plus()
            : SupportedApiLevel.android12OrBelow();
      },
    );
  }
}

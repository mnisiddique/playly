import 'dart:io';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:playly/core/service/platform/supported_platform/supported_platform.dart';

abstract class PlatformIdentifierService {
  SupportedPlatform identifyCurrentPlatform();
}

@Injectable(as: PlatformIdentifierService)
class PlatformIdentifierServiceImpl implements PlatformIdentifierService {
  @override
  SupportedPlatform identifyCurrentPlatform() {
    if (Platform.isAndroid) {
      return SupportedPlatform.android();
    } else if (Platform.isIOS) {
      return SupportedPlatform.ios();
    }
    throw PlatformException(
        code: "-007", message: "Current Platform Is Not Supported");
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';
part 'supported_platform.freezed.dart';

@freezed
class SupportedPlatform with _$SupportedPlatform{
  const factory  SupportedPlatform.ios() = _Ios;
  const factory  SupportedPlatform.android() = _Android;
}
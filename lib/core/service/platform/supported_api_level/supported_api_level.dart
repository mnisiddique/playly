import 'package:freezed_annotation/freezed_annotation.dart';
part 'supported_api_level.freezed.dart';

@freezed
class SupportedApiLevel with _$SupportedApiLevel{
  const factory  SupportedApiLevel.android13Plus() = _Android13Plus;
  const factory  SupportedApiLevel.android12OrBelow() = _Android12OrBelow;
}
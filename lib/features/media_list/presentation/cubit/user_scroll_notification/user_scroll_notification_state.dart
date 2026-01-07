part of 'user_scroll_notification_cubit.dart';

@freezed
abstract class UserScrollNotificationState with _$UserScrollNotificationState {
  const factory UserScrollNotificationState.initial() = _Initial;
  const factory UserScrollNotificationState.scrolling() = _Scrolling;
}

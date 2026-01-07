import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'user_scroll_notification_state.dart';
part 'user_scroll_notification_cubit.freezed.dart';

@Injectable()
class UserScrollNotificationCubit extends Cubit<UserScrollNotificationState> {
  UserScrollNotificationCubit() : super(UserScrollNotificationState.initial());

  void onScrollNotification(UserScrollNotification notification) {
    if (notification.direction == ScrollDirection.idle) {
      emit(UserScrollNotificationState.initial());
    } else if (notification.direction == ScrollDirection.forward ||
        notification.direction == ScrollDirection.reverse) {
      emit(UserScrollNotificationState.scrolling());
    }
  }
}

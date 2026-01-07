import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'audio_search_state.dart';
part 'audio_search_cubit.freezed.dart';

@Injectable()
class AudioSearchCubit extends Cubit<AudioSearchState> {
  AudioSearchCubit() : super(AudioSearchState.closed());

  void openSearch() {
    emit(AudioSearchState.opened());
  }

  void closeSearch() {
    emit(AudioSearchState.closed());
  }

  void searching(String query) {
    emit(AudioSearchState.searching(query));
  }
}

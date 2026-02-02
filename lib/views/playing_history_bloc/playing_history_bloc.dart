import 'package:flutter_bloc/flutter_bloc.dart';
import 'playing_history_event.dart';
import 'playing_history_state.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';

class PlayingHistoryBloc
    extends Bloc<PlayingHistoryEvent, PlayingHistoryState> {
  PlayingHistoryBloc() : super(PlayingHistoryInitial()) {
    on<FetchPlayingHistory>(_onFetchPlayingHistory);
  }

  Future<void> _onFetchPlayingHistory(
      FetchPlayingHistory event, Emitter<PlayingHistoryState> emit) async {
    emit(PlayingHistoryLoading());

    try {
      final client = ApiClient(AppRepository.dio);
      final request = GeneralRequest(user_id: event.userId);
      final dataResponse = await client.playingHistoryResponse(request);

      if (dataResponse['status'] == 1) {
        final result = dataResponse['result'];
        emit(PlayingHistoryLoaded(
          contest: result['contest'].toString(),
          matches: result['Matches'].toString(),
          win: result['win'].toString(),
          totalWinning: result['total_winning'].toString(),
          leagueClose: result['league_close'].toString(),
          series: result['series'].toString(),
        ));
      } else {
        emit(PlayingHistoryError('Failed to fetch playing history.'));
      }
    } catch (e) {
      emit(PlayingHistoryError(e.toString()));
    }
  }
}

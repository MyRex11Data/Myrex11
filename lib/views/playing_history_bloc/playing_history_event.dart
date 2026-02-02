import 'package:equatable/equatable.dart';

abstract class PlayingHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPlayingHistory extends PlayingHistoryEvent {
  final String userId;
  FetchPlayingHistory(this.userId);

  @override
  List<Object?> get props => [userId];
}

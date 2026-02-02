import 'package:equatable/equatable.dart';

class PlayingHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlayingHistoryInitial extends PlayingHistoryState {}

class PlayingHistoryLoading extends PlayingHistoryState {}

class PlayingHistoryLoaded extends PlayingHistoryState {
  final String contest;
  final String matches;
  final String win;
  final String totalWinning;
  final String leagueClose;
  final String series;

  PlayingHistoryLoaded({
    required this.contest,
    required this.matches,
    required this.win,
    required this.totalWinning,
    required this.leagueClose,
    required this.series,
  });

  @override
  List<Object?> get props =>
      [contest, matches, win, totalWinning, leagueClose, series];
}

class PlayingHistoryError extends PlayingHistoryState {
  final String message;
  PlayingHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

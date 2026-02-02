part of 'affiliate_matches_bloc.dart';

class AffiliateMatchesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchAffileateMatches extends AffiliateMatchesEvent {
  final String userId;
  final String startDate;
  final String endDate;

  FetchAffileateMatches({
    required this.userId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [];
}

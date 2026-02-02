part of 'affiliate_matches_bloc.dart';

abstract class AffiliateMatchesState extends Equatable {
  const AffiliateMatchesState();

  @override
  List<Object?> get props => [];
}

class AffiliateMatchesInitial extends AffiliateMatchesState {}

class AffiliateMatchesLoading extends AffiliateMatchesState {}

class AffiliateMatchesLoaded extends AffiliateMatchesState {
  final List<dynamic> matchList;

  const AffiliateMatchesLoaded(this.matchList);

  @override
  List<Object?> get props => [matchList];
}

class AffiliateMatchesError extends AffiliateMatchesState {
  final String message;

  const AffiliateMatchesError(this.message);

  @override
  List<Object?> get props => [message];
}

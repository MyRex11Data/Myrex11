import 'package:bloc/bloc.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:equatable/equatable.dart';
part 'affiliate_matches_event.dart';
part 'affiliate_matches_state.dart';

class AffiliateMatchesBloc
    extends Bloc<AffiliateMatchesEvent, AffiliateMatchesState> {
  AffiliateMatchesBloc() : super(AffiliateMatchesInitial()) {
    on<FetchAffileateMatches>(_onFetchAffiliateMatches);
  }

  Future<void> _onFetchAffiliateMatches(
    FetchAffileateMatches event,
    Emitter<AffiliateMatchesState> emit,
  ) async {
    emit(AffiliateMatchesLoading());

    try {
      final request = GeneralRequest(
        user_id: event.userId,
        start_date: event.startDate,
        end_date: event.endDate,
        page: '0',
      );

      final client = ApiClient(AppRepository.dio);
      final matchListResponse = await client.getAffiliateMatchData(request);

      if (matchListResponse.status == 1) {
        emit(AffiliateMatchesLoaded(matchListResponse.result ?? []));
      } else {
        emit(const AffiliateMatchesError('Failed to load data'));
      }
    } catch (e) {
      emit(AffiliateMatchesError(e.toString()));
    }
  }
}

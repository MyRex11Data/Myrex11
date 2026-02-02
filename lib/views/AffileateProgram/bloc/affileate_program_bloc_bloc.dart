import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:myrex11/repository/app_repository.dart';
import 'package:myrex11/repository/model/base_request.dart';
import 'package:myrex11/repository/model/promoter_total_response.dart';
import 'package:myrex11/repository/retrofit/api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'affileate_program_bloc_event.dart';
part 'affileate_program_bloc_state.dart';

class AffileateProgramBlocBloc
    extends Bloc<AffileateProgramBlocEvent, AffileateProgramBlocState> {
  AffileateProgramBlocBloc() : super(AffileateProgramBlocInitial()) {
    on<FetchAffileateProgramDetails>(_onFetchAffiliateMatches);
  }

  FutureOr<void> _onFetchAffiliateMatches(FetchAffileateProgramDetails event,
      Emitter<AffileateProgramBlocState> emit) async {
    // Emit loading state
    emit(AffileateProgramBlocLoading());

    try {
      // Prepare request data
      final loginRequest = {
        'user_id': event.userId,
        'start_date': event.startDate,
        'end_date': event.endDate
      };

      // Call API
      final client = ApiClient(AppRepository.dio);
      final response = await client.getAffiliationTotal(loginRequest);

      // Handle response
      if (response.status == 1 && response.result != null) {
        emit(AffileateProgramBlocLoaded(response.result!));
      } else {
        emit(AffileateProgramBlocError("No data available"));
      }
    } catch (e) {
      emit(AffileateProgramBlocError(e.toString()));
    }
  }
}

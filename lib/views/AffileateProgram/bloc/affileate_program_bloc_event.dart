part of 'affileate_program_bloc_bloc.dart';

class AffileateProgramBlocEvent extends Equatable {
  const AffileateProgramBlocEvent();

  @override
  List<Object> get props => [];
}

class FetchAffileateProgramDetails extends AffileateProgramBlocEvent {
  final String userId;
  final String startDate;
  final String endDate;
  final BuildContext context;

  FetchAffileateProgramDetails({
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.context,
  });
  @override
  List<Object> get props => [
        userId,
        startDate,
        endDate,
        context,
      ];
}

part of 'affileate_program_bloc_bloc.dart';

class AffileateProgramBlocState extends Equatable {
  const AffileateProgramBlocState();

  @override
  List<Object> get props => [];
}

class AffileateProgramBlocInitial extends AffileateProgramBlocState {}

class AffileateProgramBlocLoading extends AffileateProgramBlocState {}

class AffileateProgramBlocLoaded extends AffileateProgramBlocState {
  final PromoterTotalResult result;

  AffileateProgramBlocLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class AffileateProgramBlocError extends AffileateProgramBlocState {
  final String message;

  AffileateProgramBlocError(this.message);

  @override
  List<Object> get props => [message];
}

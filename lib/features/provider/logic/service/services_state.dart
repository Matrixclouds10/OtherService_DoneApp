part of 'services_cubit.dart';

class ServicesState extends Equatable {
  final BaseState state;
  final BaseState updateState;
  final List<ServiceModel> services;
  final List<ServiceModel> myServices;
  final ErrorModel? error;
  const ServicesState({
    this.state = BaseState.initial,
    this.services = const [],
    this.myServices = const [],
    this.error,
    this.updateState = BaseState.initial,
  });

  ServicesState copyWith({
    BaseState? state,
    List<ServiceModel>? myServices,
    List<ServiceModel>? services,
    ErrorModel? error,
    BaseState? updateState,
  }) {
    return ServicesState(
      state: state ?? this.state,
      services: services ?? this.services,
      myServices: myServices ?? this.myServices,
      error: error ?? this.error,
      updateState: updateState ?? this.updateState,
    );
  }

  @override
  List<Object?> get props => [state, services, myServices, error, updateState];
}

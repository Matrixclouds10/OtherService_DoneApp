part of 'services_cubit.dart';

class ServicesProviderState extends Equatable {
  final BaseState state;
  final BaseState updateState;
  final List<ServiceModel> services;
  final List<ServiceModel> myServices;
  final ErrorModel? error;
  const ServicesProviderState({
    this.state = BaseState.initial,
    this.services = const [],
    this.myServices = const [],
    this.error,
    this.updateState = BaseState.initial,
  });

  ServicesProviderState copyWith({
    BaseState? state,
    List<ServiceModel>? myServices,
    List<ServiceModel>? services,
    ErrorModel? error,
    BaseState? updateState,
  }) {
    return ServicesProviderState(
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

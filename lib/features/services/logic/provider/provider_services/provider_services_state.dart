part of 'provider_services_cubit.dart';

class ProviderServicesState extends Equatable {
  final BaseState state;
  final List<ServiceModel> data;
  final ErrorModel? error;
  const ProviderServicesState({
    this.state = BaseState.initial,
    this.data = const [],
    this.error,
  });

  ProviderServicesState copyWith({
    BaseState? state,
    List<ServiceModel>? data,
    ErrorModel? error,
  }) {
    return ProviderServicesState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error];
}

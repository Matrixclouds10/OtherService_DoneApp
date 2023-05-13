part of 'providers_cubit.dart';

class ProvidersState extends Equatable {
  final BaseState state;
  final BaseState searchState;
  final List<ProvidersModel> providers;
  final List<ProvidersModel> mostRequestedProviders;
  final List<ProvidersModel> searchProviders;
  final ErrorModel? error;
  const ProvidersState({
    this.searchState = BaseState.initial,
    this.state = BaseState.initial,
    this.providers = const [],
    this.mostRequestedProviders = const [],
    this.searchProviders = const [],
    this.error,
  });

  ProvidersState copyWith({
    BaseState? state,
    BaseState? searchState,
    List<ProvidersModel>? providers,
    List<ProvidersModel>? mostRequestedProviders,
    List<ProvidersModel>? searchProviders,
    ErrorModel? error,
  }) {
    return ProvidersState(
      state: state ?? this.state,
      searchState: searchState ?? this.searchState,
      mostRequestedProviders: mostRequestedProviders ?? this.mostRequestedProviders,
      searchProviders: searchProviders ?? this.searchProviders,
      providers: providers ?? this.providers,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, searchState, providers, error, searchProviders, mostRequestedProviders];
}

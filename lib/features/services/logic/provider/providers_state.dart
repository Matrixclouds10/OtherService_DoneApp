part of 'providers_cubit.dart';

class ProvidersState extends Equatable {
  final BaseState state;
  final BaseState searchState;
  final List<ProvidersModel> providers;
  final List<ProvidersModel> searchProviders;
  final ErrorModel? error;
  const ProvidersState({
    this.searchState = BaseState.initial,
    this.state = BaseState.initial,
    this.providers = const [],
    this.searchProviders = const [],
    this.error,
  });

  ProvidersState copyWith({
    BaseState? state,
    BaseState? searchState,
    List<ProvidersModel>? providers,
    List<ProvidersModel>? searchProviders,
    ErrorModel? error,
  }) {
    return ProvidersState(
      state: state ?? this.state,
      searchState: searchState ?? this.searchState,
      searchProviders: searchProviders ?? this.searchProviders,
      providers: providers ?? this.providers,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state,searchState, providers, error, searchProviders];
}

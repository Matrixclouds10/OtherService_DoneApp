part of 'services_cubit.dart';

class ServicesState extends Equatable {
  final BaseState state;
  final BaseState updateState;
  final BaseState loadMoreState;
  final List<ServiceModel> services;
  final List<ServiceModel> homeServices;
  final int currentPage;
  final int totalPages;
  final ErrorModel? error;
  const ServicesState({
    this.state = BaseState.initial,
    this.loadMoreState = BaseState.initial,
    this.services = const [],
    this.homeServices = const [],
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.updateState = BaseState.initial,
  });

  ServicesState copyWith({
    BaseState? state,
    BaseState? loadMoreState,
    List<ServiceModel>? services,
    List<ServiceModel>? homeServices,
    ErrorModel? error,
    int? currentPage,
    int? totalPages,
    BaseState? updateState,
  }) {
    return ServicesState(
      loadMoreState: loadMoreState ?? this.loadMoreState,
      state: state ?? this.state,
      services: services ?? this.services,
      homeServices: homeServices ?? this.homeServices,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      updateState: updateState ?? this.updateState,
    );
  }

  @override
  List<Object?> get props =>
      [state, services, error, updateState, currentPage, homeServices];
}

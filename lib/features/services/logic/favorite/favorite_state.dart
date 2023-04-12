part of 'favorite_cubit.dart';

class FavoriteState extends Equatable {
  final BaseState state;
  final BaseState addState;
  final List<ProvidersModel> data;
  final ErrorModel? error;
  const FavoriteState({
    this.state = BaseState.initial,
    this.addState = BaseState.initial,
    this.data = const [],
    this.error,
  });

  FavoriteState copyWith({
    BaseState? state,
    BaseState? addState,
    List<ProvidersModel>? data,
    ErrorModel? error,
  }) {
    return FavoriteState(
      addState: addState ?? this.addState,
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data,addState, error];
}

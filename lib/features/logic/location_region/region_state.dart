part of 'region_cubit.dart';

class RegionState extends Equatable {
  final BaseState state;
  final List<RegionModel> data;
  final ErrorModel? error;
  const RegionState({
    this.state = BaseState.initial,
    this.data = const [],
    this.error,
  });

  RegionState copyWith({
    BaseState? state,
    List<RegionModel>? data,
    ErrorModel? error,
  }) {
    return RegionState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error];
}

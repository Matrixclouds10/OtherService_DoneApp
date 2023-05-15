part of 'banner_cubit.dart';

class BannerState extends Equatable {
  final BaseState state;
  final List<BannerModel> data;
  final ErrorModel? error;
  const BannerState({
    this.state = BaseState.initial,
    this.data = const [],
    this.error,
  });

  BannerState copyWith({
    BaseState? state,
    List<BannerModel>? data,
    ErrorModel? error,
  }) {
    return BannerState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error];
}

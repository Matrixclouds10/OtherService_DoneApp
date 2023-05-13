part of 'subscription_cubit.dart';

class SubscriptionState extends Equatable {
  final BaseState state;
  final List<SubscriptionModel> data;
  final ErrorModel? error;
  const SubscriptionState({
    this.state = BaseState.initial,
    this.data = const [],
    this.error,
  });

  SubscriptionState copyWith({
    BaseState? state,
    List<SubscriptionModel>? data,
    ErrorModel? error,
  }) {
    return SubscriptionState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error];
}

part of 'subscription_cubit.dart';

class SubscribtionState extends Equatable {
  final BaseState state;
  final BaseState subscribeState;
  final List<SubscriptionModel> data;
  final ErrorModel? error;
  const SubscribtionState({
    this.state = BaseState.initial,
    this.subscribeState = BaseState.initial,
    this.data = const [],
    this.error,
  });

  SubscribtionState copyWith({
    BaseState? state,
    BaseState? subscribeState,
    List<SubscriptionModel>? data,
    ErrorModel? error,
  }) {
    return SubscribtionState(
      state: state ?? this.state,
      subscribeState: subscribeState ?? this.subscribeState,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error ,subscribeState];
}

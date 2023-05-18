part of 'subscription_cubit.dart';

class SubscribtionState extends Equatable {
  final BaseState state;
  final BaseState subscribeState;
  final BaseState subscribtionHistoryState;

  final List<SubscriptionModel> data;
  final List<SubscriptionHistoryModel> subscribtionHistoryData;
  final ErrorModel? error;
  const SubscribtionState({
    this.state = BaseState.initial,
    this.subscribeState = BaseState.initial,
    this.subscribtionHistoryState = BaseState.initial,
    this.subscribtionHistoryData = const [],
    this.data = const [],
    this.error,
  });

  SubscribtionState copyWith({
    BaseState? state,
    BaseState? subscribeState,
    BaseState? subscribtionHistoryState,
    List<SubscriptionHistoryModel>? subscribtionHistoryData,
    List<SubscriptionModel>? data,
    ErrorModel? error,
  }) {
    return SubscribtionState(
      state: state ?? this.state,
      subscribeState: subscribeState ?? this.subscribeState,
      subscribtionHistoryState: subscribtionHistoryState ?? this.subscribtionHistoryState,
       subscribtionHistoryData: subscribtionHistoryData ?? this.subscribtionHistoryData,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error ,subscribeState , subscribtionHistoryState , subscribtionHistoryData];
}

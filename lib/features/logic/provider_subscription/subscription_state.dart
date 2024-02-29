part of 'subscription_cubit.dart';

class SubscriptionState extends Equatable {
  final BaseState state;
  final BaseState subscribeState;
  final BaseState subscribtionHistoryState;
  final BaseState rePaySubscribeState;

  final List<SubscriptionModel> data;
  final List<SubscriptionHistoryModel> subscribtionHistoryData;
  final List<SubscriptionHistoryModel> reSubscribtionHistoryData;
  final ErrorModel? error;
  const SubscriptionState({
    this.state = BaseState.initial,
    this.subscribeState = BaseState.initial,
    this.subscribtionHistoryState = BaseState.initial,
    this.rePaySubscribeState = BaseState.initial,
    this.subscribtionHistoryData = const [],
    this.reSubscribtionHistoryData = const [],
    this.data = const [],
    this.error,
  });

  SubscriptionState copyWith({
    BaseState? state,
    BaseState? subscribeState,
    BaseState? subscribtionHistoryState,
    BaseState? rePaySubscribeState,
    List<SubscriptionHistoryModel>? subscribtionHistoryData,
    List<SubscriptionHistoryModel>? reSubscribtionHistoryData,
    List<SubscriptionModel>? data,
    ErrorModel? error,
  }) {
    return SubscriptionState(
      state: state ?? this.state,
      subscribeState: subscribeState ?? this.subscribeState,
      subscribtionHistoryState: subscribtionHistoryState ?? this.subscribtionHistoryState,
      rePaySubscribeState: rePaySubscribeState ?? this.rePaySubscribeState,
       subscribtionHistoryData: subscribtionHistoryData ?? this.subscribtionHistoryData,
       reSubscribtionHistoryData: reSubscribtionHistoryData ?? this.reSubscribtionHistoryData,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error ,rePaySubscribeState ,subscribeState , subscribtionHistoryState , subscribtionHistoryData, reSubscribtionHistoryData];
}

part of 'chat_cubit.dart';

class ChatState extends Equatable {
  final BaseState state;
  final List<ChatModel> data;
  final ErrorModel? error;
  const ChatState({
    this.state = BaseState.initial,
    this.data = const [],
    this.error,
  });

  ChatState copyWith({
    BaseState? state,
    List<ChatModel>? data,
    ErrorModel? error,
  }) {
    return ChatState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error];
}

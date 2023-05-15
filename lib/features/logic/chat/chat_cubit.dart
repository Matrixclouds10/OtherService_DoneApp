import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/domain/usecase/chat_messages/chat_messages_usecase.dart';
import 'package:weltweit/features/domain/usecase/chat_send_message/chat_send_message_usecase.dart';
import 'package:weltweit/features/data/models/chat/chat_model.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatMessagesUseCase chatUseCase;
  final ChatSendMessageUseCase chatSendMessageUseCase;
  ChatCubit(
    this.chatUseCase,
    this.chatSendMessageUseCase,
  ) : super(const ChatState());

  Future<void> getChat(int orderId, {bool loading = true}) async {
    initStates();
    if (loading) emit(state.copyWith(state: BaseState.loading));
    final result = await chatUseCase(ChatMessagesParams(id: orderId));
    if (loading) {
      result.fold(
        (error) => emit(state.copyWith(state: BaseState.error, error: error)),
        (data) {
          emit(state.copyWith(state: BaseState.loaded, data: data));
        },
      );
    }
    if (!loading) {
      result.fold(
        (error) => null,
        (data) {
          emit(state.copyWith(data: data));
        },
      );
    }
  }

  Future<bool> sendMessage(int id, String text) async {
    final result = await chatSendMessageUseCase(ChatSendMessageParams(id: id, message: text));

    return result.fold(
      (error) {
        throw error.errorMessage ?? LocaleKeys.somethingWentWrong.tr();
      },
      (data) {
        return true;
      },
    );
  }

  Future<bool> sendImage(int id, String path) async {
    final result = await chatSendMessageUseCase(ChatSendMessageParams(id: id, message: '', image: path));

    return result.fold(
      (error) {
        throw error.errorMessage ?? LocaleKeys.somethingWentWrong.tr();
      },
      (data) {
        return true;
      },
    );
  }

  void initStates() {
    emit(state.copyWith(
      state: BaseState.initial,
      data: [],
      error: null,
    ));
  }

  Future<bool> sendLocation(int id, double latitude, double longitude) async {
    final result = await chatSendMessageUseCase(ChatSendMessageParams(id: id, message: 'location', lat: latitude.toString(), lng: longitude.toString()));
    return result.fold(
      (error) {
        throw error.errorMessage ?? LocaleKeys.somethingWentWrong.tr();
      },
      (data) {
        return true;
      },
    );
  }
}

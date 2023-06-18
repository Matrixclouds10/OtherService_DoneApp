import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/data/models/notification/notification_model.dart';
import 'package:weltweit/features/domain/usecase/provider/notification/notifications_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider/notification/provider_notifications_usecase.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsUseCase notificationsUseCase;
  final ProviderNotificationsUseCase providerNotificationsUseCase;
  NotificationsCubit(
    this.notificationsUseCase,
    this.providerNotificationsUseCase,
  ) : super(const NotificationsState());

  Future<void> getNotifications() async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await notificationsUseCase(0);

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        logger.i('notifications: total pages: ${data.meta?.pagination.totalPages}');
        emit(state.copyWith(
          state: BaseState.loaded,
          notifications: data.data,
          totalPages: data.meta?.pagination.totalPages,
        ));
      },
    );
  }

  Future<void> getProviderNotifications() async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await providerNotificationsUseCase(0);

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        logger.i('notifications: total pages: ${data.meta?.pagination.totalPages}');
        emit(state.copyWith(
          state: BaseState.loaded,
          notifications: data.data,
          totalPages: data.meta?.pagination.totalPages,
        ));
      },
    );
  }

  Future<void> getMoreProviderNotifications() async {
    if (state.loadMoreState == BaseState.loading) return;
    if (state.currentPage >= state.totalPages) return;
    int page = state.currentPage + 1;
    state.copyWith(currentPage: page);
    emit(state.copyWith(loadMoreState: BaseState.loading));
    final result = await providerNotificationsUseCase(page);
    List<NotificationModel> notifications = [];
    notifications.addAll(state.notifications);
    result.fold(
      (error) {},
      (data) {
        notifications.addAll(data.data ?? []);
        emit(state.copyWith(
          loadMoreState: BaseState.loaded,
          notifications: notifications,
          currentPage: page,
          totalPages: data.meta?.pagination.totalPages ?? 0,
        ));
      },
    );
  }

  Future<void> getMoreNotifications() async {
    if (state.loadMoreState == BaseState.loading) return;
    if (state.currentPage >= state.totalPages) return;
    int page = state.currentPage + 1;
    state.copyWith(currentPage: page);
    emit(state.copyWith(loadMoreState: BaseState.loading));
    final result = await notificationsUseCase(page);
    List<NotificationModel> notifications = [];
    notifications.addAll(state.notifications);
    result.fold(
      (error) {},
      (data) {
        notifications.addAll(data.data ?? []);
        emit(state.copyWith(
          loadMoreState: BaseState.loaded,
          notifications: notifications,
          currentPage: page,
          totalPages: data.meta?.pagination.totalPages ?? 0,
        ));
      },
    );
  }

  void initStates() {
    emit(state.copyWith(
      updateState: BaseState.initial,
      error: null,
    ));
  }
}

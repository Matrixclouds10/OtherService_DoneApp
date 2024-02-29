part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  final BaseState state;
  final BaseState updateState;
  final BaseState loadMoreState;
  final List<NotificationModel> notifications;
  final int currentPage;
  final int totalPages;
  final ErrorModel? error;
  const NotificationsState({
    this.state = BaseState.initial,
    this.loadMoreState = BaseState.initial,
    this.notifications = const [],
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.updateState = BaseState.initial,
  });

  NotificationsState copyWith({
    BaseState? state,
    BaseState? loadMoreState,
    List<NotificationModel>? notifications,
    List<NotificationModel>? homeNotifications,
    ErrorModel? error,
    int? currentPage,
    int? totalPages,
    BaseState? updateState,
  }) {
    return NotificationsState(
      loadMoreState: loadMoreState ?? this.loadMoreState,
      state: state ?? this.state,
      notifications: notifications ?? this.notifications,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      updateState: updateState ?? this.updateState,
    );
  }

  @override
  List<Object?> get props =>
      [state, notifications, error, updateState, currentPage];
}

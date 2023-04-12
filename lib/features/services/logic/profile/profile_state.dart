part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final BaseState state;
  final BaseState updateState;
  final BaseState updatePasswordState;
  final UserModel? data;
  final ErrorModel? error;
  const ProfileState({
    this.state = BaseState.initial,
    this.data,
    this.error,
    this.updateState = BaseState.initial,
    this.updatePasswordState = BaseState.initial,
  });

  ProfileState copyWith({
    BaseState? state,
    BaseState? updateState,
    BaseState? updatePasswordState,
    UserModel? data,
    ErrorModel? error,
  }) {
    return ProfileState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      updateState: updateState ?? this.updateState,
      updatePasswordState: updatePasswordState ?? this.updatePasswordState,
    );
  }

  @override
  List<Object?> get props =>
      [state, data, error, updateState, updatePasswordState];
}

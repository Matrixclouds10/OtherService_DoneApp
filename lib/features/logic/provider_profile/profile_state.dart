part of 'profile_cubit.dart';

class ProfileProviderState extends Equatable {
  final BaseState state;
  final BaseState availabilityState;
  final BaseState updateState;
  final BaseState updatePasswordState;
  final UserModel? data;
  final ErrorModel? error;
  const ProfileProviderState({
    this.state = BaseState.initial,
    this.data,
    this.error,
    this.updateState = BaseState.initial,
    this.availabilityState = BaseState.initial,
    this.updatePasswordState = BaseState.initial,
  });

  ProfileProviderState copyWith({
    BaseState? state,
    BaseState? availabilityState,
    BaseState? updateState,
    BaseState? updatePasswordState,
    UserModel? data,
    ErrorModel? error,
  }) {
    return ProfileProviderState(
      availabilityState: availabilityState ?? this.availabilityState,
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      updateState: updateState ?? this.updateState,
      updatePasswordState: updatePasswordState ?? this.updatePasswordState,
    );
  }

  @override
  List<Object?> get props =>
      [state, data, error, updateState, availabilityState, updatePasswordState];
}

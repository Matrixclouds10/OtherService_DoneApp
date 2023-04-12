import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/services/domain/usecase/auth/update_fcm_token_usecase.dart';
import 'package:weltweit/features/services/core/base/base_states.dart';
import 'package:weltweit/features/services/core/base/base_usecase.dart';
import 'package:weltweit/features/services/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/services/domain/usecase/profile/change_password_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/profile/delete_profile_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/profile/profile_read_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/profile/update_profile_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileUseCase profileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final DeleteProfileUseCase deleteProfileUseCase;
  final UpdateFCMTokenUseCase updateFCMTokenUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  ProfileCubit(
    this.profileUseCase,
    this.updateProfileUseCase,
    this.deleteProfileUseCase,
    this.updateFCMTokenUseCase,
    this.changePasswordUseCase,
  ) : super(const ProfileState());
  Future<void> getProfile() async {
    resetState();
    emit(state.copyWith(state: BaseState.loading));
    final result = await profileUseCase.call(NoParameters());
    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) => emit(state.copyWith(state: BaseState.loaded, data: data)),
    );
  }

  Future<void> updateProfile(UpdateProfileParams params) async {
    resetState();
    if (state.updateState == BaseState.loading) return;
    emit(state.copyWith(updateState: BaseState.loading));
    final result = await updateProfileUseCase(params);
    result.fold(
      (error) =>
          emit(state.copyWith(updateState: BaseState.error, error: error)),
      (data) => emit(state.copyWith(updateState: BaseState.loaded, data: data)),
    );
  }

  void deleteProfile(int deleteId) async {
    resetState();
    if (state.updateState == BaseState.loading) return;
    if (state.data?.id == null) return;
    emit(state.copyWith(updateState: BaseState.loading));
    final result = await deleteProfileUseCase(state.data!.id!);
    result.fold(
      (error) =>
          emit(state.copyWith(updateState: BaseState.error, error: error)),
      (data) => emit(state.copyWith(updateState: BaseState.loaded)),
    );
  }

  void updateFcm(String token) async {
    await updateFCMTokenUseCase(fcmToken: token);
  }

  updatePassword(ChangePasswordParams updateProfileParams) async {
    resetState();
    if (state.updatePasswordState == BaseState.loading) return;
    if (state.data?.id == null) return;
    emit(state.copyWith(updatePasswordState: BaseState.loading));
    final result = await changePasswordUseCase(updateProfileParams);
    print('-----> $result');
    result.fold(
      (error) => emit(
          state.copyWith(updatePasswordState: BaseState.error, error: error)),
      (data) => emit(
          state.copyWith(updatePasswordState: BaseState.loaded, error: null)),
    );
  }

  void resetState() {
    emit(state.copyWith(
      updateState: BaseState.initial,
      updatePasswordState: BaseState.initial,
      error: null,
    ));
  }

  void deleteAccount() {}
}

// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:weltweit/core/utils/permission_heloper.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/provider/domain/usecase/profile/change_password_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/profile/delete_profile_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/profile/profile_read_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/profile/update_profile_availablity_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/profile/update_profile_location_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/profile/update_profile_usecase.dart';
import 'package:weltweit/features/provider/domain/usecase/profile/update_fcm_usecase.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

import '../../domain/logger.dart';

part 'profile_state.dart';

class ProfileProviderCubit extends Cubit<ProfileProviderState> {
  final ProfileProviderUseCase profileUseCase;
  final UpdateProfileAvailabilityProviderUseCase updateProfileAvailabilityUseCase;
  final UpdateProfileProviderUseCase updateProfileUseCase;
  final DeleteProfileProviderUseCase deleteProfileUseCase;
  final UpdateFcmProviderUseCase updateFCMTokenUseCase;
  final ChangePasswordProviderUseCase changePasswordUseCase;
  final UpdateProfileLocationProviderUseCase updateProfileLocationUseCase;
  ProfileProviderCubit(
    this.profileUseCase,
    this.updateProfileUseCase,
    this.deleteProfileUseCase,
    this.updateProfileAvailabilityUseCase,
    this.updateFCMTokenUseCase,
    this.changePasswordUseCase,
    this.updateProfileLocationUseCase,
  ) : super(const ProfileProviderState());
  Future<void> getProfile() async {
    emit(state.copyWith(state: BaseState.loading));
    final result = await profileUseCase.call(NoParameters());
    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) => emit(state.copyWith(state: BaseState.loaded, data: data)),
    );
  }

  void updateAvailability() async {
    if (state.availabilityState == BaseState.loading) return;
    emit(state.copyWith(availabilityState: BaseState.loading));
    final result = await updateProfileAvailabilityUseCase(NoParameters());
    result.fold(
      (error) => emit(state.copyWith(availabilityState: BaseState.error, error: error)),
      (data) => emit(state.copyWith(availabilityState: BaseState.loaded, data: data)),
    );
  }

  Future<void> updateProfile(UpdateProfileParams params) async {
    if (state.updateState == BaseState.loading) return;
    emit(state.copyWith(updateState: BaseState.loading));
    final result = await updateProfileUseCase(params);
    result.fold(
      (error) => emit(state.copyWith(updateState: BaseState.error, error: error)),
      (data) => emit(state.copyWith(updateState: BaseState.loaded, data: data)),
    );
  }

  void deleteProfile(int deleteId) async {
    if (state.updateState == BaseState.loading) return;
    if (state.data?.id == null) return;
    emit(state.copyWith(updateState: BaseState.loading));
    final result = await deleteProfileUseCase(state.data!.id!);
    result.fold(
      (error) => emit(state.copyWith(updateState: BaseState.error, error: error)),
      (data) => emit(state.copyWith(updateState: BaseState.loaded)),
    );
  }

  void updateFcm(String token) async {
    await updateFCMTokenUseCase(token);
  }

  updatePassword(ChangePasswordParams updateProfileParams) async {
    resetState();
    if (state.updatePasswordState == BaseState.loading) return;
    if (state.data?.id == null) return;
    emit(state.copyWith(updatePasswordState: BaseState.loading));
    final result = await changePasswordUseCase(updateProfileParams);
    result.fold(
      (error) => emit(state.copyWith(updatePasswordState: BaseState.error, error: error)),
      (data) => emit(state.copyWith(updatePasswordState: BaseState.loaded, error: null)),
    );
  }

  void resetState() {
    emit(state.copyWith(
      updateState: BaseState.initial,
      availabilityState: BaseState.initial,
      error: null,
    ));
  }

  void updateLocation(BuildContext context) async {
    bool permissionStatus = await PermissionHelper.checkLocationPermissionStatus();
    if (!permissionStatus) {
      bool dialogStatus = await AppDialogs().question(context, message: LocaleKeys.allowLocationStatusToBeShownForNearbyUsers.tr());
      if (dialogStatus) {
        bool? permissionStatus = await PermissionHelper.requestLocation();
        if (permissionStatus == null || !permissionStatus) return;
      }
    }
    try {
      Location location = Location();
      LocationData locationData = await location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        updateProfileLocationUseCase(UpdateProfileLocationParams(lat: locationData.latitude.toString(), lng: locationData.longitude.toString()));
      }
    } catch (e) {
      log('Location Error', e.toString());
    }
  }

  void deleteAccount() {}
}
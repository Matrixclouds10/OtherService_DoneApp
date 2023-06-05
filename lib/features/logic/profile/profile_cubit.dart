import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/core/utils/echo.dart';
import 'package:weltweit/core/utils/permission_heloper.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/domain/usecase/auth/update_fcm_token_usecase.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/domain/usecase/profile/change_password_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/delete_profile_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/profile_read_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/update_profile_location_usecase%20copy.dart';
import 'package:weltweit/features/domain/usecase/profile/update_profile_usecase.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

import '../../../core/utils/logger.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileUseCase profileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final DeleteProfileUseCase deleteProfileUseCase;
  final UpdateFCMTokenUseCase updateFCMTokenUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final UpdateProfileLocationUseCase updateProfileLocationUseCase;

  ProfileCubit(
    this.profileUseCase,
    this.updateProfileUseCase,
    this.deleteProfileUseCase,
    this.updateFCMTokenUseCase,
    this.changePasswordUseCase,
    this.updateProfileLocationUseCase,
  ) : super(const ProfileState());
  Future<UserModel> getProfile({bool returnSaved = false}) async {
    if (returnSaved) {
      if (state.data != null) return state.data!;
    }
    resetState();
    emit(state.copyWith(state: BaseState.loading));
    final result = await profileUseCase.call(NoParameters());
    return result.fold(
      (error) {
        emit(state.copyWith(state: BaseState.error, error: error));
        return Future.error(error);
      },
      (data) {
        emit(state.copyWith(state: BaseState.loaded, data: data));
            kEcho("countryId ${data.countryModel?.id}");
            AppPrefs prefs = getIt();
           if (data.countryModel?.id != null) prefs.save(PrefKeys.countryId, data.countryModel?.id);
        return data;
      },
    );
  }

  Future<void> updateProfile(UpdateProfileParams params) async {
    resetState();
    if (state.updateState == BaseState.loading) return;
    emit(state.copyWith(updateState: BaseState.loading));
    final result = await updateProfileUseCase(params);
    result.fold(
      (error) => emit(state.copyWith(updateState: BaseState.error, error: error)),
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
      (error) => emit(state.copyWith(updateState: BaseState.error, error: error)),
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
      (error) => emit(state.copyWith(updatePasswordState: BaseState.error, error: error)),
      (data) => emit(state.copyWith(updatePasswordState: BaseState.loaded, error: null)),
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
}

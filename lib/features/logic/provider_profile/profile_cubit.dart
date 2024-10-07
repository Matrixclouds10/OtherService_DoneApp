// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/core/utils/echo.dart';
import 'package:weltweit/core/utils/globals.dart';
import 'package:weltweit/core/utils/permission_heloper.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/auth/user_model.dart';
import 'package:weltweit/features/domain/usecase/provider_profile/change_password_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_profile/delete_profile_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_profile/profile_read_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_profile/update_fcm_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_profile/update_profile_availablity_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_profile/update_profile_location_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_profile/update_profile_usecase.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

import '../../data/models/chat/chat_user.dart';
import '../chat/chat_cubit.dart';

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
  Future<UserModel> getProfile() async {
    emit(state.copyWith(state: BaseState.loading, updateState: BaseState.initial, updatePasswordState: BaseState.initial));
    final result = await profileUseCase.call(NoParameters());
    return result.fold(
      (error) {
        emit(state.copyWith(state: BaseState.error, error: error));
        GlobalParams globalParams = getIt();
        globalParams = globalParams.copyWith(user: state.data);
        throw error;
      },
      (data) {
        ChatCubit cubit =ChatCubit.get();
        ChatUser user=ChatUser(
            image: data.image??'',
            about: '',
            name: data.name??'',
            createdAt: '',
            isOnline: true,
            id: data.id.toString()??'0',
            lastActive: '',
            phone: data.mobileNumber??'',
            pushToken: '');
        cubit.getSelfInfo(user);
        print('data.currentSubscription.status ${data.currentSubscription?.status}');
        userModel = data;
        emit(state.copyWith(state: BaseState.loaded, data: data));
        AppPrefs prefs = getIt();
        if (data.countryModel?.id != null) prefs.save(PrefKeys.countryId, data.countryModel?.id);
        GlobalParams globalParams = getIt();
        globalParams = globalParams.copyWith(user: state.data);
        return data;
      },
    );
  }
  UserModel? userModel;
  Future<UserModel> getProfileNoState() async {
    final result = await profileUseCase.call(NoParameters());
    return result.fold((error) => throw error, (data) {
      userModel = data;
      print('sadsadsad ${data.toMap()}');return data;
    });
  }

  void updateAvailability() async {
    if (state.availabilityState == BaseState.loading) return;
    emit(state.copyWith(availabilityState: BaseState.loading));
    final result = await updateProfileAvailabilityUseCase(NoParameters());
    result.fold(
      (error) => emit(state.copyWith(availabilityState: BaseState.error, error: error)),
      (data) {
        userModel = data;
        emit(state.copyWith(availabilityState: BaseState.loaded, data: data));
      },
    );
  }

  Future<void> updateProfile(UpdateProfileParams params) async {
    if (state.updateState == BaseState.loading) return;
    emit(state.copyWith(updateState: BaseState.loading));
    final result = await updateProfileUseCase(params);
    // result.fold(
    //   (error) => emit(state.copyWith(updateState: BaseState.error, error: error)),
    //   (data) => emit(state.copyWith(updateState: BaseState.loaded, data: data)),
    //
    // );

    return result.fold(
      (error) => emit(state.copyWith(updateState: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(updateState: BaseState.loaded, data: data));
        AppPrefs prefs = getIt();
        if (data.countryModel?.id != null) prefs.save(PrefKeys.countryId, data.countryModel?.id);
        GlobalParams globalParams = getIt();
        globalParams = globalParams.copyWith(user: state.data);
      },
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
    print('Checking permission...');
    bool permissionStatus =
    await PermissionHelper.checkLocationPermissionStatus();
    print('Permission Status: $permissionStatus');

    if (!permissionStatus) {
      // Show dialog to ask the user if they want to enable location permissions
      bool dialogStatus = await AppDialogs().question(
        context,
        message: LocaleKeys.allowLocationStatusToBeShownForNearbyUsers.tr(),
      );

      if (dialogStatus) {
        // If user agrees, request location permission
        bool? permissionGranted = await PermissionHelper.requestLocation();

        // If permission is denied or null, return and stop further execution
        if (permissionGranted == null || !permissionGranted) {
          print('Permission denied or null');
          return;
        }
      } else {
        // User declined to enable permission
        print('User declined permission request');
        return;
      }
    }
    // Fetch user's current location

    // print(
    //     'Location updated: (${locationData.latitude}, ${locationData.longitude})');
    try {
      Location location = Location();

      // Check if location services are enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          print('Location services disabled');
          return; // Stop if user denies enabling location services
        }
      }
      print('LocationDataLocationData');

      // Get the location data (latitude and longitude)
      Position position = await Geolocator.getCurrentPosition();

      // Update profile with the location data
      await updateProfileLocationUseCase(UpdateProfileLocationParams(
        lat: position.latitude.toString(),
        lng: position.longitude.toString(),
      ));
    } catch (e) {
      // Handle any errors that occur while getting location
      print('Error fetching location: $e');
    }
  }
  void deleteAccount() {}
}

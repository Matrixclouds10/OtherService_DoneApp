import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  getCurrentLocationAddress() async {
    print('getCurrentLocationAddress');
    if (state.currentLocationAddress.isNotEmpty) return state.currentLocationAddress;
    LocationPermission checkPermission = await Geolocator.checkPermission();
    if (checkPermission == LocationPermission.whileInUse || checkPermission == LocationPermission.always) {
    print('getCurrentLocationAddress permission granted');
      Position position = await Geolocator.getCurrentPosition();
    print('getCurrentLocationAddress position ${position.latitude} ${position.longitude}');
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print('getCurrentLocationAddress placemarks ${placemarks.length}');

      Placemark place = placemarks[0];
      List<String> address = [];
      if (place.country != null) address.add(place.country!);
      if (place.administrativeArea != null) address.add(place.administrativeArea!);
      if (place.subAdministrativeArea != null) address.add(place.subAdministrativeArea!);

      emit(state.copyWith(currentLocationAddress: address.join(', ')));
    } else {
    print('getCurrentLocationAddress permission not granted');
      LocationPermission locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.whileInUse || locationPermission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        Placemark place = placemarks[0];
        List<String> address = [];
        if (place.country != null) address.add(place.country!);
        if (place.administrativeArea != null) address.add(place.administrativeArea!);
        if (place.subAdministrativeArea != null) address.add(place.subAdministrativeArea!);

        emit(state.copyWith(currentLocationAddress: address.join(', ')));
      }
    }
  }
}

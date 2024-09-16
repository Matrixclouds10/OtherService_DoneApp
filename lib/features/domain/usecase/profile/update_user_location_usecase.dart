import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/auth/user_model.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';

class UpdateUserLocationUseCase extends BaseUseCase<bool, LatLng> {
  final AppRepository repository;

  UpdateUserLocationUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, bool>> call( LatLng latLng) async {
    return await repository.updateUserLocation(latLng);
  }

  @override
  Future<Either<ErrorModel, bool>> callTest( parameters) {
    throw UnimplementedError();
  }
}

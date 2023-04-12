import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/services/core/base/base_usecase.dart';
import 'package:weltweit/features/services/data/models/response/provider/providers_model.dart';
import 'package:weltweit/features/services/domain/repository/app_repo.dart';

class ProvidersUseCase extends BaseUseCase<List<ProvidersModel>, ProvidersParams> {
  final AppRepository repository;

  ProvidersUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, List<ProvidersModel>>> call(ProvidersParams parameters) async {
    return await repository.getProviders(params: parameters);
  }

  @override
  Future<Either<ErrorModel, List<ProvidersModel>>> callTest(ProvidersParams parameters) {
    throw UnimplementedError();
  }
}

class ProvidersParams {
  String? name;
  double? lat;
  double? lng;
  int? service_id;

  ProvidersParams({
    this.name,
    this.lat,
    this.lng,
     this.service_id,
  });

  toJson() {
    return {
      'name': name,
      'lat': lat,
      'lng': lng,
      'service_id': service_id,
    };
  }
}

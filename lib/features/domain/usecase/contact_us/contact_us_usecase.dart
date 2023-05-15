import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/domain/repositoy/app_repo.dart';

class ContactUsUseCase extends BaseUseCase<BaseResponse, ContactUsParams> {
  final AppRepository repository;

  ContactUsUseCase(this.repository);

  @override
  Future<Either<ErrorModel, BaseResponse>> call(ContactUsParams parameters) async {
    return await repository.sendContactUs(params: parameters);
  }

  @override
  Future<Either<ErrorModel, BaseResponse>> callTest(ContactUsParams parameters) {
    throw UnimplementedError();
  }
}

class ContactUsParams {
  String name;
  String email;
  String message;
  ContactUsParams({
    required this.name,
    required this.email,
    required this.message,
  });

  toJson() {
    return {
      'name': name,
      'email': email,
      'message': message,
    };
  }
}

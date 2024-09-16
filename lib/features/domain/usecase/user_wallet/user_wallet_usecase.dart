import 'package:dartz/dartz.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/wallet/wallet_model.dart';
import 'package:weltweit/features/domain/repositoy/provider_repo.dart';

import '../../repositoy/app_repo.dart';

class WalletUserUseCase extends BaseUseCase<List<WalletModel>, NoParameters> {
  final AppRepository repository;

  WalletUserUseCase(this.repository);

  @override
  Future<Either<ErrorModel, List<WalletModel>>> call(NoParameters parameters) async {
    return await repository.getWalletUser();
  }

  @override
  Future<Either<ErrorModel, List<WalletModel>>> callTest(NoParameters parameters) {
    throw UnimplementedError();
  }
}


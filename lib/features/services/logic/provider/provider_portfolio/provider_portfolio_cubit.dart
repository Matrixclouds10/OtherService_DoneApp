import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/services/core/base/base_states.dart';
import 'package:weltweit/features/services/data/models/response/portfolio/portfolio_image.dart';
import 'package:weltweit/features/services/domain/usecase/provider/portfolio/portfolio_usecase.dart';

part 'provider_portfolio_state.dart';

class ProviderPortfolioCubit extends Cubit<ProviderPortfolioState> {
  final PortfolioUseCase useCase;
  ProviderPortfolioCubit(
    this.useCase,
  ) : super(const ProviderPortfolioState());

  Future<void> getProviderPortfolio(int id) async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await useCase(id);

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(state: BaseState.loaded,  data : data));
      },
    );
  }

  void initStates() {
    emit(state.copyWith(
      state: BaseState.initial,
      error: null,
    ));
  }
}
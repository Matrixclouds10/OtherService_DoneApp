import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/portfolio/portfolio_image.dart';
import 'package:weltweit/features/domain/usecase/provider_portfolio/portfolio_add_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_portfolio/portfolio_delete_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_portfolio/portfolio_update_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_portfolio/portfolios_usecase.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

part 'portfolio_state.dart';

class PortfoliosCubit extends Cubit<PortfoliosState> {
  PortfoliosUseCase portfoliosUseCase;
  PortfolioAddUseCase portfolioAddUseCase;
  PortfolioUpdateUseCase portfolioUpdateUseCase;
  PortfolioDeleteUseCase portfolioDeleteUseCase;

  PortfoliosCubit(
    this.portfoliosUseCase,
    this.portfolioAddUseCase,
    this.portfolioUpdateUseCase,
    this.portfolioDeleteUseCase,
  ) : super(const PortfoliosState());

  Future<void> getPortfolios() async {
    logger.d('getPortfolios');
    emit(state.copyWith(state: BaseState.loading));
    final result = await portfoliosUseCase(NoParameters());
    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) => emit(state.copyWith(state: BaseState.loaded, data: data)),
    );
  }

  Future<void> addPortfolio(File image) async {
    emit(state.copyWith(addState: BaseState.loading));
    final result = await portfolioAddUseCase(image);
    result.fold(
      (error) => emit(state.copyWith(addState: BaseState.error, error: error)),
      (data) async {
        emit(state.copyWith(addState: BaseState.initial));
        await getPortfolios();
        // final result2 = await portfoliosUseCase(NoParameters());
        // result2.fold(
        //   (error) => emit(state.copyWith(state: BaseState.error, error: error)),
        //   (data) => emit(state.copyWith(state: BaseState.loaded, data: data)),
        // );
      },
    );
  }

  Future<void> updatePortfolio(PortfolioParams data) async {
    List<PortfolioModel> list = List.of(state.data!);
    int index = list.indexWhere((element) => element.id == data.id);
    list[index].isUploading = true;

    emit(state.copyWith(data: list));
    final result = await portfolioUpdateUseCase(data);
    result.fold(
      (error) => emit(state.copyWith(message: error.toString())),
      (data) async {
        emit(state.copyWith(message: LocaleKeys.portfolioUpdated.tr()));
        //TODO handle it properly
        await getPortfolios();
        // list[index].isUploading = false;
      },
    );
  }

  void delete(PortfolioModel portfolio) async {
    List<PortfolioModel> list = List.of(state.data!);
    //update item from list
    list[list.indexOf(portfolio)].isDeleting = true;
    emit(state.copyWith(data: list));
    final result = await portfolioDeleteUseCase(portfolio.id!);
    logger.d(result);
    result.fold(
      (error) => emit(state.copyWith(message: error.toString())),
      (data) async{
        List<PortfolioModel> list = List.of(state.data!);
        list.removeWhere((element) => element.id == portfolio.id);
        emit(state.copyWith(message: LocaleKeys.portfolioDeleted.tr(),data: list));
      },
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/data/models/banner/banner_model.dart';
import 'package:weltweit/features/domain/usecase/banner/banner_usecase.dart';

part 'banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  final BannerUseCase bannerUseCase;
  BannerCubit(
    this.bannerUseCase,
  ) : super(const BannerState());

  Future<void> getBanner() async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await bannerUseCase(BannerParams());

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(state: BaseState.loaded, data: data));
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

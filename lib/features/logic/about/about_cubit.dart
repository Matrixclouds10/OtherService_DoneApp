import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/domain/usecase/about/about_usecase.dart';

part 'about_state.dart';

class AboutCubit extends Cubit<AboutState> {
  final AboutUseCase aboutUseCase;
  AboutCubit(
    this.aboutUseCase,
  ) : super(const AboutState());

  Future<void> getAbout(NoParameters params) async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await aboutUseCase(params);

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(state: BaseState.loaded,  data : ''));
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

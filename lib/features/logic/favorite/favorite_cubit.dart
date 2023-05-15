import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/provider/providers_model.dart';
import 'package:weltweit/features/domain/usecase/favorite/add_favorite/add_favorite_usecase.dart';
import 'package:weltweit/features/domain/usecase/favorite/favorite_usecase.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteUseCase allfavoriteUseCase;
  final AddFavoriteUseCase addFavoriteUseCase;
  FavoriteCubit(
    this.allfavoriteUseCase,
    this.addFavoriteUseCase,
  ) : super(const FavoriteState());

  Future<void> getFavorite() async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await allfavoriteUseCase(NoParameters());

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(state: BaseState.loaded, data: data));
      },
    );
  }

  Future<void> addFavorite(int id) async {
    initStates();
    emit(state.copyWith(addState: BaseState.loading));
    final result = await addFavoriteUseCase(id);

    result.fold(
      (error) => emit(state.copyWith(addState: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(addState: BaseState.loaded));
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

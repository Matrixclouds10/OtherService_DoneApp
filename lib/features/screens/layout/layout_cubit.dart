import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/features/logic/favorite/favorite_cubit.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(const LayoutInitial(currentIndex: 0));

  void setCurrentIndex({required BuildContext context, required int i}) {
    if (i == 1) BlocProvider.of<FavoriteCubit>(context).getFavorite();
    emit(LayoutInitial(currentIndex: i));
  }
}

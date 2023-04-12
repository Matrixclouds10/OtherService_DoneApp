import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(const LayoutInitial(currentIndex: 0));

  void setCurrentIndex(int i) {
    emit(LayoutInitial(currentIndex: i));
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'layout_state.dart';

class LayoutProviderCubit extends Cubit<LayoutProviderState> {
  LayoutProviderCubit() : super(LayoutInitial(currentIndex: 0));

  void setCurrentIndex(int i) {
    emit(LayoutInitial(currentIndex: i));
  }
}

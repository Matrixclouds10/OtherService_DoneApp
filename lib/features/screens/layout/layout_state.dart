part of 'layout_cubit.dart';

abstract class LayoutState extends Equatable {
  const LayoutState();

  @override
  List<Object> get props => [];
}

class LayoutInitial extends LayoutState {
  final int currentIndex;
  const LayoutInitial({required this.currentIndex});

  @override
  List<Object> get props => [currentIndex];

  int get getCurrentIndex => 0;
}

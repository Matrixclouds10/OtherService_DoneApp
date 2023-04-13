part of 'layout_cubit.dart';

abstract class LayoutProviderState extends Equatable {
  const LayoutProviderState();

  @override
  List<Object> get props => [];
}

class LayoutInitial extends LayoutProviderState {
  final int currentIndex;
  LayoutInitial({required this.currentIndex});

  @override
  List<Object> get props => [currentIndex];

  int get getCurrentIndex => 0;
}

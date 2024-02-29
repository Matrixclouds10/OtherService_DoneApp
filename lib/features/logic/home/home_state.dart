part of 'home_cubit.dart';

class HomeState extends Equatable {
  final String currentLocationAddress;

  const HomeState({
    this.currentLocationAddress = '',
  });

  HomeState copyWith({
    String? currentLocationAddress,
  }) {
    return HomeState(
      currentLocationAddress: currentLocationAddress ?? this.currentLocationAddress,
    );
  }

  @override
  List<Object?> get props => [currentLocationAddress];
}

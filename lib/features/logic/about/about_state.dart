part of 'about_cubit.dart';

class AboutState extends Equatable {
  final BaseState state;
  final String data;
  final ErrorModel? error;
  const AboutState({
    this.state = BaseState.initial,
    this.data = '',
    this.error,
  });

  AboutState copyWith({
    BaseState? state,
    String? data,
    ErrorModel? error,
  }) {
    return AboutState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error];
}

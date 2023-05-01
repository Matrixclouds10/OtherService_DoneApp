part of 'contact_us_cubit.dart';

class ContactUsState extends Equatable {
  final BaseState state;
  final String data;
  final ErrorModel? error;
  const ContactUsState({
    this.state = BaseState.initial,
    this.data = '',
    this.error,
  });

  ContactUsState copyWith({
    BaseState? state,
    String? data,
    ErrorModel? error,
  }) {
    return ContactUsState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error];
}

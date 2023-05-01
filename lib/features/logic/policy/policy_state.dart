part of 'policy_cubit.dart';

class PolicyState extends Equatable {
  final BaseState state;
  final String data;
  final ErrorModel? error;
  const PolicyState({
    this.state = BaseState.initial,
    this.data = '',
    this.error,
  });

  PolicyState copyWith({
    BaseState? state,
    String? data,
    ErrorModel? error,
  }) {
    return PolicyState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [state, data, error];
}

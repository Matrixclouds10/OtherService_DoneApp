import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/domain/usecase/policy/policy_usecase.dart';

part 'policy_state.dart';

class PolicyCubit extends Cubit<PolicyState> {
  final PolicyUseCase policyUseCase;
  PolicyCubit(
    this.policyUseCase,
  ) : super(const PolicyState());

  Future<void> getPolicy(NoParameters params) async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await policyUseCase(params);

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(state: BaseState.loaded,  data : ''));
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

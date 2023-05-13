import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/domain/usecase/contact_us/contact_us_usecase.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  final ContactUsUseCase contactUsUseCase;
  ContactUsCubit(
    this.contactUsUseCase,
  ) : super(const ContactUsState());

  void initStates() {
    emit(state.copyWith(
      state: BaseState.initial,
      error: null,
    ));
  }

  Future<void> call(ContactUsParams parameters) async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await contactUsUseCase(parameters);
    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(state: BaseState.loaded, data: data.message??''));
      },
    );
  }

}

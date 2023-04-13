import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/data/injection.dart';
import 'package:weltweit/features/services/data/model/response/address/address_item_model.dart';
import 'package:weltweit/features/services/domain/usecase/address/address_read_usecase.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(const AddressStateInitial());

  Future<void> getAddresses() async {
    emit(const AddressStateLoading());
    AddressReadUsecase addressReadUsecase = getIt();
    Either<ErrorModel, List<AddressItemModel>> result =
        await addressReadUsecase(AddressReadParams());
    result.fold((l) {
      emit(AddressStateError(l));
    }, (r) {
      emit(AddressStateSuccess(r));
    });
  }
}

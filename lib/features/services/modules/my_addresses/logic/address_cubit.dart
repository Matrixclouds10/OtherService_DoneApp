import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/services/data/model/response/address/address_item_model.dart';
import 'package:weltweit/features/services/domain/usecase/address/address_create_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/address/address_delete_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/address/address_read_usecase.dart';
import 'package:weltweit/features/services/domain/usecase/address/address_update_usecase%20copy.dart';
import 'package:weltweit/features/services/domain/usecase/address/address_update_usecase.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressCreateUsecase addressCreateUsecase;
  final AddressReadUsecase addressReadUsecase;
  final AddressUpdateUsecase addressUpdateUsecase;
  final AddressDeleteUsecase addressDeleteUsecase;
  final AddressSetAsDefaultUsecase addressSetAsDefaultUsecase;

  AddressCubit(
    this.addressCreateUsecase,
    this.addressReadUsecase,
    this.addressUpdateUsecase,
    this.addressDeleteUsecase,
    this.addressSetAsDefaultUsecase,
  ) : super(AddressState());

  Future<void> getAddresses() async {
    emit(AddressState(baseState: BaseState.loading));
    Either<ErrorModel, List<AddressItemModel>> result = await addressReadUsecase(AddressReadParams());
    result.fold(
      (l) => emit(AddressState(errorModel: l, baseState: BaseState.error)),
      (r) => emit(AddressState(addresses: r, baseState: BaseState.loaded)),
    );
  }

  Future<void> createAddress(AddressCreateParams params) async {
    emit(state.copyWith(createState: BaseState.loading));
    Either<ErrorModel, BaseResponse> result = await addressCreateUsecase(params);
    result.fold(
      (l) => emit(state.copyWith(errorModel: l, createState: BaseState.error)),
      (r) => emit(state.copyWith(createState: BaseState.loaded)),
    );
  }

  Future<void> updateAddress(AddressUpdateParams params) async {
    emit(state.copyWith(updateState: BaseState.loading));
    Either<ErrorModel, BaseResponse> result = await addressUpdateUsecase(params);
    result.fold(
      (l) => emit(state.copyWith(errorModel: l, updateState: BaseState.error)),
      (r) => emit(state.copyWith(updateState: BaseState.loaded)),
    );
  }

  Future<void> deleteAddress(AddressDeleteParams params) async {
    emit(state.copyWith(deleteState: BaseState.loading));
    Either<ErrorModel, BaseResponse> result = await addressDeleteUsecase(params);
    result.fold(
      (l) => emit(state.copyWith(errorModel: l, deleteState: BaseState.error)),
      (r) => emit(state.copyWith(deleteState: BaseState.loaded)),
    );
  }

  Future<void> setAsDefault(int id) async {
    emit(state.copyWith(baseState: BaseState.loading));

    Either<ErrorModel, BaseResponse> result = await addressSetAsDefaultUsecase(id);
    emit(state.copyWith(baseState: BaseState.loaded));
  }
}

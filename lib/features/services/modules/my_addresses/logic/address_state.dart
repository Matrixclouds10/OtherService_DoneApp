part of 'address_cubit.dart';

class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressStateInitial extends AddressState {
  const AddressStateInitial();
}

class AddressStateLoading extends AddressState {
  const AddressStateLoading();
}

class AddressStateError extends AddressState {
  final ErrorModel errorModel;
  const AddressStateError(this.errorModel);
}

class AddressStateSuccess extends AddressState {
  final List<AddressItemModel> addresses;
  const AddressStateSuccess(this.addresses);
}

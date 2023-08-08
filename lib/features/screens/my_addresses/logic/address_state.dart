part of 'address_cubit.dart';

class AddressState extends Equatable {
  final ErrorModel? errorModel;
  final BaseState baseState;
  final BaseState createState;
  final BaseState updateState;
  final BaseState deleteState;
  final List<AddressItemModel> addresses;

  const AddressState({
    this.errorModel,
    this.createState = BaseState.initial,
    this.updateState = BaseState.initial,
    this.deleteState = BaseState.initial,
    this.baseState = BaseState.initial,
    this.addresses = const [],
  });

  @override
  List<Object?> get props => [errorModel, baseState, addresses, createState];

  copyWith({
    ErrorModel? errorModel,
    BaseState? baseState,
    List<AddressItemModel>? addresses,
    BaseState? createState,
    BaseState? updateState,
    BaseState? deleteState,
  }) {
    return AddressState(
      errorModel: errorModel ?? this.errorModel,
      baseState: baseState ?? this.baseState,
      addresses: addresses ?? this.addresses,
      createState: createState ?? this.createState,
      updateState: updateState ?? this.updateState,
      deleteState: deleteState ?? this.deleteState,
    );
  }
}

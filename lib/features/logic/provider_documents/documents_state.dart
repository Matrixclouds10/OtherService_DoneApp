part of 'documents_cubit.dart';

class DocumentsState extends Equatable {
  final BaseState state;
  final List<Document>? data;
  final ErrorModel? error;
  final BaseState addState;
  final BaseState updateState;

  const DocumentsState({
    this.state = BaseState.initial,
    this.data,
    this.error,
    this.addState = BaseState.initial,
    this.updateState = BaseState.initial,
  });

  DocumentsState copyWith({
    BaseState? state,
    List<Document>? data,
    ErrorModel? error,
    BaseState? addState,
    BaseState? updateState,
  }) {
    return DocumentsState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      addState: addState ?? this.addState,
      updateState: updateState ?? this.updateState,
    );
  }

  @override
  List<Object?> get props => [state, data, error, addState];
}

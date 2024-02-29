part of 'documents_cubit.dart';

class DocumentsState extends Equatable {
  final BaseState state;
  final List<Document>? data;
  final ErrorModel? error;
  final BaseState addState;
  final BaseState updateState;
  final BaseState getHitingDocsState;
  final List<HiringDocumentModel> hiringDocuments;

  const DocumentsState({
    this.state = BaseState.initial,
    this.data,
    this.hiringDocuments = const [],
    this.error,
    this.addState = BaseState.initial,
    this.updateState = BaseState.initial,
    this.getHitingDocsState = BaseState.initial,
  });

  DocumentsState copyWith({
    BaseState? state,
    List<Document>? data,
    List<HiringDocumentModel>? hiringDocuments,
    ErrorModel? error,
    BaseState? addState,
    BaseState? getHitingDocsState,
    BaseState? updateState,
  }) {
    return DocumentsState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      addState: addState ?? this.addState,
      getHitingDocsState: getHitingDocsState ?? this.getHitingDocsState,
      updateState: updateState ?? this.updateState,
      hiringDocuments: hiringDocuments ?? this.hiringDocuments,
    );
  }

  @override
  List<Object?> get props => [state, data, error, addState,getHitingDocsState,hiringDocuments];
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/documents/document.dart';
import 'package:weltweit/features/data/models/documents/hiring_document_model.dart';
import 'package:weltweit/features/domain/usecase/provider_document/document_add_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_document/document_delete_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_document/document_update_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_document/documents_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_document/hiring_documents_usecase.dart';

part 'documents_state.dart';

class DocumentsCubit extends Cubit<DocumentsState> {
  DocumentsCubit() : super(const DocumentsState());

  Future<void> getDocuments({bool loading = true}) async {
    DocumentsUseCase documentsUseCase = getIt();
    if (loading) emit(state.copyWith(state: BaseState.loading));
    final result = await documentsUseCase(NoParameters());
    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        //sort by date
        data.sort((a, b) => b.type!.compareTo(a.type!));
        emit(state.copyWith(state: BaseState.loaded, data: data));
      },
    );
  }

  Future<void> addDocument(DocumentParams data) async {
    DocumentAddUseCase addUseCase = getIt();
    emit(state.copyWith(addState: BaseState.loading));
    final result = await addUseCase(data);
    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) => emit(state.copyWith(state: BaseState.initial, addState: BaseState.loaded)),
    );
  }

  Future<void> updateDocument(DocumentParams data) async {
    DocumentUpdateUseCase updateUseCase = getIt();
    emit(state.copyWith(updateState: BaseState.loading));
    final result = await updateUseCase.call(data);
    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) => emit(state.copyWith(state: BaseState.loaded)),
    );
  }
  
  Future<void> getHiringDocuments() async{
    HiringDocumentsUseCase hiringDocumentsUseCase = getIt();
    emit(state.copyWith(getHitingDocsState: BaseState.loading));
    final result = await hiringDocumentsUseCase(NoParameters());
    result.fold(
      (error) => emit(state.copyWith(getHitingDocsState: BaseState.error, error: error)),
      (data) => emit(state.copyWith(getHitingDocsState: BaseState.loaded, hiringDocuments: data)),
    );

  }

  void delete(Document document) async {
    List<Document> list = List.of(state.data!);
    //update item from list
    list[list.indexOf(document)] = document.copyWith(deleting: true);
    emit(state.copyWith(data: list));
    DocumentDeleteUseCase documentDeleteUseCase = getIt();
    final result = await documentDeleteUseCase.call(document.id!);

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        List<Document> list = List.of(state.data!);
        list.removeWhere((element) => element.id == document.id);
        emit(state.copyWith(data: list));
      },
    );
  }
}

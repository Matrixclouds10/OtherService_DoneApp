import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/data/models/services/service.dart';
import 'package:weltweit/features/domain/usecase/services/all_services_usecase.dart';
import 'package:weltweit/features/domain/usecase/services/update_services_usecase.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  // final MyServicesUseCase myServicesUseCase;
  final AllServicesUseCase allServicesUseCase;
  final UpdateServicesUseCase updateServicesUseCase;
  ServicesCubit(
    // this.myServicesUseCase,
    this.allServicesUseCase,
    this.updateServicesUseCase,
  ) : super(const ServicesState());

  Future<void> getAllServices() async {
    if (state.services.isNotEmpty) return;
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await allServicesUseCase(1);

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        logger.i('services: total pages: ${data.totalPages}');
        emit(state.copyWith(
          state: BaseState.loaded,
          services: data.service,
          totalPages: data.totalPages,
        ));
      },
    );
  }

  Future<void> getHomeServices() async {
    // if (state.homeServices.isNotEmpty) return;
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await allServicesUseCase(1);

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) => emit(state.copyWith(state: BaseState.loaded, homeServices: data.service)),
    );
  }

  Future<void> getMoreServices() async {
    logger.i('getMoreServices ${state.currentPage}} ${state.totalPages} ${state.loadMoreState}');
    if (state.loadMoreState == BaseState.loading) return;
    if (state.currentPage >= state.totalPages) return;
    int page = state.currentPage + 1;
    state.copyWith(currentPage: page);
    emit(state.copyWith(loadMoreState: BaseState.loading));
    final result = await allServicesUseCase(page);
    List<ServiceModel> services = [];
    services.addAll(state.services);
    result.fold(
      (error) {},
      (data) {
        services.addAll(data.service ?? []);
        logger.i('services: getMoreServices length: ${services.length}');
        logger.i('services: getMoreServices totalPages: ${state.totalPages}');
        emit(state.copyWith(
          loadMoreState: BaseState.loaded,
          services: services,
          currentPage: page,
          totalPages: data.totalPages,
        ));
      },
    );
  }

  Future<void> getSavedServices({required int page}) async {
    initStates();
    if (state.services.isNotEmpty) return;
    emit(state.copyWith(state: BaseState.loading));
    final result = await allServicesUseCase(page);
    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) => emit(state.copyWith(state: BaseState.loaded, services: data.service)),
    );
  }

  // Future<void> getMyServices() async {
  //   initStates();
  //   emit(state.copyWith(state: BaseState.loading));
  //   final result = await myServicesUseCase(NoParameters());
  //   result.fold(
  //     (error) => emit(state.copyWith(state: BaseState.error, error: error)),
  //     (data) => emit(state.copyWith(state: BaseState.loaded, services: data)),
  //   );
  // }

  Future<void> updateServices(List<ServiceModel> services) async {
    emit(state.copyWith(updateState: BaseState.loading));
    final result = await updateServicesUseCase(UpdateServicesParams(services: services));
    result.fold(
      (error) => emit(state.copyWith(updateState: BaseState.error, error: error)),
      (data) => emit(state.copyWith(updateState: BaseState.loaded, services: data)),
    );
  }

  void initStates() {
    emit(state.copyWith(
      updateState: BaseState.initial,
      error: null,
    ));
  }

  void updateSelectedServices(ServiceModel service, bool? val) {
    List<ServiceModel> services = List.of(state.services);
    final index = services.indexWhere((element) => element.id == service.id);
    services[index] = service.copyWith(myService: val);

    logger.i('updateSelectedServices: ${services.where((element) => element.myService == true).toList().length})');

    emit(state.copyWith(services: services));
  }
}

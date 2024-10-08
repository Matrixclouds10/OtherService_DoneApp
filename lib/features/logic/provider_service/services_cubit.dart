import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/data/models/services/service.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/domain/usecase/provider_services/all_services_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_services/update_services_usecase.dart';

part 'services_state.dart';

class ServicesProviderCubit extends Cubit<ServicesProviderState> {
  // final MyServicesUseCase myServicesUseCase;
  final AllServicesUseCase allServicesUseCase;
  final UpdateServicesUseCase updateServicesUseCase;
  ServicesProviderCubit(
    // this.myServicesUseCase,
    this.allServicesUseCase,
    this.updateServicesUseCase,
  ) : super(const ServicesProviderState());


  Future<void> getAllServices() async {
    initStates();
    emit(state.copyWith(state: BaseState.loading,));
    final result = await allServicesUseCase(NoParameters());

    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error,  error: error)),
      (data) {
        emit(state.copyWith(
          state: BaseState.loaded,
          services: data,
          myServices: data.where((element) => element.myService == true).toList(),
        ));
      }
    );
  }

  Future<void> getSavedServices() async {
    initStates();
    if (state.services.isNotEmpty) return;
    emit(state.copyWith(state: BaseState.loading));
    final result = await allServicesUseCase(NoParameters());
    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) => emit(
        state.copyWith(
          state: BaseState.loaded,
          services: data,
          myServices: data.where((element) => element.myService == true).toList(),
        ),
      ),
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
    emit(state.copyWith(updateState: BaseState.loading ,state: BaseState.loading));
    final result = await updateServicesUseCase(UpdateServicesParams(services: services));
    result.fold(
      (error) => emit(state.copyWith(updateState: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(
          updateState: BaseState.loaded,
          services: data,
          myServices: data.where((element) => element.myService == true).toList(),
        ));
        getAllServices();

      },
    );
  }

  void initStates() {
    emit(state.copyWith(updateState: BaseState.initial));
  }
  ServiceModel? selectedService;
  void updateSelectedServices(ServiceModel service, bool? val) {
    List<ServiceModel>? services = List.of(state.services);

    services = services.map((e) => e.copyWith(myService: false)).toList().cast<ServiceModel>();

    final index = services.indexWhere((element) => element.id == service.id);
    if (index != -1) {
      services[index] = service.copyWith(myService: val);
    }
    logger.i('updateSelectedServices: ${services.where((element) => element.myService == true).first.id}');
    selectedService=services.where((element) => element.myService == true).first;
    emit(state.copyWith(services: services));
  }
}

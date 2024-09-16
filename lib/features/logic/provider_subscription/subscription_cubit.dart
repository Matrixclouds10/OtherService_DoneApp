import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/base/base_usecase.dart';
import 'package:weltweit/features/data/models/subscription/subscription_history_model.dart';
import 'package:weltweit/features/data/models/subscription/subscription_model.dart';
import 'package:weltweit/features/data/models/subscription/update_subscribtion_response.dart';
import 'package:weltweit/features/domain/usecase/provider_subscription/repay_subscribe_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_subscription/subscribe_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_subscription/subscribtions_history_usecase.dart';
import 'package:weltweit/features/domain/usecase/provider_subscription/subscribtions_usecase.dart';
import 'package:weltweit/features/logic/provider_profile/profile_cubit.dart';
import 'package:weltweit/features/screens/provider_subscribe/subscribe_page.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';

import '../../../core/routing/navigation_services.dart';
import '../../../core/utils/alerts.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscribtionUseCase subscribtionUseCase;
  final SubscribeUseCase subscribeUseCase;
  final SubscribtionHistoryUseCase subscribtionHistoryUseCase;
  final RePaySubscribeUseCase rePaySubscribeUseCase;

  SubscriptionCubit(
    this.subscribtionUseCase,
    this.subscribeUseCase,
    this.subscribtionHistoryUseCase,
    this.rePaySubscribeUseCase,
  ) : super(const SubscriptionState());

  Future<void> getSubscriptions() async {
    initStates();
    emit(state.copyWith(state: BaseState.loading));
    final result = await subscribtionUseCase(NoParameters());
    print('subscription data $result');
    result.fold(
      (error) => emit(state.copyWith(state: BaseState.error, error: error)),
      (data) {
        emit(state.copyWith(state: BaseState.loaded, data: data));
      },
    );
  }

  Future<void> getSubscribtionsHistory() async {
    initStates();
    emit(state.copyWith(subscribtionHistoryState: BaseState.loading));
    final result = await subscribtionHistoryUseCase(NoParameters());

    result.fold(
      (error) => emit(state.copyWith(subscribtionHistoryState: BaseState.error)),
      (data) {
        emit(state.copyWith(subscribtionHistoryState: BaseState.loaded, subscribtionHistoryData: data));
      },
    );
  }

  Future<UpdateSubscribtionResponse> subscribe({int? id, String? method, required BuildContext context}) async {
    initStates();
    emit(state.copyWith(subscribeState: BaseState.loading));
    final result = await subscribeUseCase(SubscribeParams(id: id, paymentMethod: method));
    return result.fold(
      (error) {
        Alerts.showSnackBar(error.errorMessage.toString());
        return Future.error(error.errorMessage.toString());
      },
      (data) {
        Alerts.showSnackBar(data.status.toString(), alertsType: AlertsType.success);
        context.read<ProfileProviderCubit>().getProfile();

        Navigator.pop(NavigationService.navigationKey.currentContext!);
        emit(state.copyWith(subscribeState: BaseState.loaded));
        return data;
      },
    );
  }

  Future<UpdateSubscribtionResponse?> reSubscribe(int id, String method) async {
    initStates();
    emit(state.copyWith(rePaySubscribeState: BaseState.loading));
    final result = await rePaySubscribeUseCase
      (RePaySubscribeParams(id: id, paymentMethod: method));

    return result.fold(
      (error) {
        emit(state.copyWith(rePaySubscribeState: BaseState.error));
        return Future.error(error);
      },
      (data) {
        emit(state.copyWith(rePaySubscribeState: BaseState.loaded));
        return data;
      },
    );
  }

  void initStates() {
    emit(state.copyWith(
      state: BaseState.initial,
      rePaySubscribeState: BaseState.initial,
      subscribtionHistoryState: BaseState.initial,
      subscribeState: BaseState.initial,
      error: null,
    ));
  }

  Future<String> actionShowSubscriptionMethods({
    required BuildContext context,
    required SubscriptionModel subscriptionModel,
    // required String url,
  }) async {
    ProfileProviderCubit profileProviderCubit = context.read<ProfileProviderCubit>();

    String selectedCreditMethodToReturn = await AppDialogs().showCreditMethodsDialog(
      context,
      // url: url,
      currency: getCountryCurrency(context),
      period: '${subscriptionModel.period}',
      price: '${subscriptionModel.price}',
      profileWallet: '${profileProviderCubit.state.data?.wallet ?? 0}',
    );
    return selectedCreditMethodToReturn;
  }
}

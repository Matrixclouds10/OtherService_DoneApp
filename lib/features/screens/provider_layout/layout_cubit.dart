import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weltweit/features/data/models/auth/user_model.dart';

import '../../../core/routing/navigation_services.dart';
import '../../logic/provider_profile/profile_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'layout_state.dart';


class LayoutProviderCubit extends Cubit<LayoutProviderState> with WidgetsBindingObserver {
  LayoutProviderCubit() : super(LayoutInitial(currentIndex: 0)) {
    // WidgetsBiبيternetConnection();
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  // Method to monitor internet connection
  // مراقبة حالة الاتصال بالإنترنت
  void monitorInternetConnection() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        print('No internet connection');
        handleConnectionLost();
      } else {
        handleConnectionRestored();
      }
    });
  }
  // الأكشن اللي هيتعمل لما الإنترنت يفصل
  void performActionOnInternetDisconnect() {
    // هنا يمكنك تنفيذ الأكشن المطلوب
    updateUserOffline();  // مثلا: تحديث حالة المستخدم إلى "أوفلاين"
    // أو أي أكشن آخر
    print('Internet is disconnected! Action performed.');
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('didChangeAppLifecycleState $state');
    if (state == AppLifecycleState.detached ) {
      print('App is being killed or paused');
      updateUserOffline();
    } else if (state == AppLifecycleState.resumed) {
      print('App resumed');
      updateUserOnline();
    }
  }


  // الأكشن عند فقد الاتصال
  void handleConnectionLost() {
    print('Connection lost, switching to offline mode.');
    FirebaseFirestore.instance.disableNetwork();
    // يمكنك تنفيذ إجراءات أخرى مثل إظهار رسالة للمستخدم
  }

  // الأكشن عند استعادة الاتصال
  void handleConnectionRestored() {
    print('Connection restored, re-enabling network.');
    FirebaseFirestore.instance.enableNetwork();
    // يمكنك تنفيذ إجراءات أخرى مثل تحديث البيانات من Firestore
  }
  void setCurrentIndex(int i) {
    emit(LayoutInitial(currentIndex: i));
  }

  void updateUserOnline() async {
    final UserModel? userModel = NavigationService.navigationKey.currentContext!.read<ProfileProviderCubit>().userModel;
    if (userModel == null) {
      NavigationService.navigationKey.currentContext!.read<ProfileProviderCubit>().getProfile().then((value) async {
        await fireStore.collection('availability').doc(value.id.toString()).get().then((user) async {
          if (user.exists) {
            updateActiveStatus(true, value);
          } else {
            await fireStore.collection('availability').doc(value.id.toString()).set({
              'isOnline': true,
              'profileId': value.id.toString(),
            });
          }
        });
      });
    } else {
      await fireStore.collection('availability').doc(userModel.id.toString()).get().then((user) async {
        if (user.exists) {
          updateActiveStatus(true, userModel);
        } else {
          await fireStore.collection('availability').doc(userModel.id.toString()).set({
            'isOnline': true,
            'profileId': userModel.id.toString(),
          });
        }
      });
    }
  }

  void updateUserOffline() async {
    final UserModel? userModel = NavigationService.navigationKey.currentContext!.read<ProfileProviderCubit>().userModel;
    if (userModel == null) {
      NavigationService.navigationKey.currentContext!.read<ProfileProviderCubit>().getProfile().then((value) async {
        updateActiveStatus(false, value);
      });
    } else {
      updateActiveStatus(false, userModel);
    }
  }

  Future<void> updateActiveStatus(bool isOnline, UserModel userModel) async {
    fireStore.collection('availability').doc(userModel.id?.toString() ?? '0').update({
      'isOnline': isOnline,
      'profileId': userModel.id?.toString() ?? '0',
    });
  }

  FirebaseFirestore fireStore = FirebaseFirestore.instance;
}

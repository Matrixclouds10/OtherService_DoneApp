import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/core/utils/echo.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/core/routing/routes_provider.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/data/models/auth/user_model.dart';
import 'package:weltweit/features/data/models/location/country_model.dart';
import 'package:weltweit/features/domain/request_body/check_otp_body.dart';
import 'package:weltweit/features/domain/usecase/auth/sign_in_usecase.dart';
import 'package:weltweit/features/widgets/app_back_button.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/presentation/component/inputs/phone_country/custom_text_filed_phone_country.dart';
import 'package:weltweit/presentation/component/text/click_text.dart';

import 'login_cubit.dart';

class LoginScreen extends StatefulWidget {
  final bool typeIsProvider;
  const LoginScreen({required this.typeIsProvider, Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late LoginCubit _viewModel;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  CountryModel? _selectedCountry;
  bool typeIsProvider = true;
  late TabController _tabController;
  bool showForIos = false;
  @override
  void initState() {
    AppPrefs prefs = getIt();
    showForIos = prefs.get(PrefKeys.iosStatus, defaultValue: true);
    if (!Platform.isIOS) showForIos = true;

    _tabController = TabController(length: 2, vsync: this, initialIndex: showForIos ? 0 : 1);
    _tabController.addListener(() {
      typeIsProvider = _tabController.index == 0;
      logger.d('typeIsProvider $typeIsProvider');
    });
    typeIsProvider = !showForIos ? false : true;
    if (kDebugMode) {
      _phoneController.text = '1010101040';
      _passwordController.text = '123456';
    }
    super.initState();
    _viewModel = BlocProvider.of<LoginCubit>(context, listen: false);
  }

  void _onSubmit(context) async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        String phone = _phoneController.text;
        String password = _passwordController.text;

        LoginParams loginBody = LoginParams(
          phone: phone,
          password: password,
          countryModel: _selectedCountry,
        );
        if (_selectedCountry == null) {
          AppSnackbar.show(
            context: context,
            title: LocaleKeys.notification,
            message: LocaleKeys.selectCountry.tr(),
            type: SnackbarType.error,
          );
          return;
        }
        var response = await BlocProvider.of<LoginCubit>(context, listen: false).login(loginBody, typeIsProvider);

        if (response.isSuccess) {
          UserModel userEntity = response.data;
          String token = userEntity.token ?? '';
          int id = userEntity.id ?? 0;
          kEcho("countryId ${userEntity.countryModel?.id}");
          int countryId = userEntity.countryId ?? userEntity.countryModel?.id ?? 0;
          if (token.isNotEmpty) {
            AppPrefs prefs = getIt();
            prefs.save(PrefKeys.token, token);
            prefs.save(PrefKeys.id, id);
            if (countryId != 0) prefs.save(PrefKeys.countryId, countryId);
            prefs.save(PrefKeys.isTypeProvider, typeIsProvider);

            if (typeIsProvider) {
              Navigator.pushNamedAndRemoveUntil(context, RoutesProvider.providerLayoutScreen, (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(context, RoutesServices.servicesLayoutScreen, (route) => false);
            }
          } else {
            NavigationService.push(RoutesServices.servicesOtpScreen, arguments: {
              'email': _phoneController.text,
              'phone':_phoneController.text,
              'code': _viewModel.params.countryModel?.code ?? '20',
              'checkOTPType': CheckOTPType.register,
              'typeIsProvider': typeIsProvider,
            });
          }
        } else {
          String message = response.error?.errorMessage ?? response.message ?? '';
          AppSnackbar.show(
            context: context,
            title: LocaleKeys.notification,
            message: message,
            type: SnackbarType.error,
          );
          if (message.contains('active') || message.contains('activate') || message.contains('verify') || message.contains('تفعيل')) {
            AppDialogs().forgetPassword(
              title: LocaleKeys.notification.tr(),
              context: context,
              message: message,
              typeIsProvider: typeIsProvider,
            );
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginlState state = context.watch<LoginCubit>().state;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(kScreenPaddingNormal.r),
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.imagesAuthBk),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListAnimator(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        SizedBox(height: 18),
                        CustomImage(imageUrl: Assets.imagesLogo, width: 200),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(kFormRadius.r),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 8),
                              Text(
                                LocaleKeys.loginMessage.tr(),
                                style: const TextStyle().titleStyle(fontSize: 18).boldStyle().customColor(primaryColor),
                                textAlign: TextAlign.center,
                              ),

                              //Tabs
                              if (showForIos)
                                TabBar(
                                  controller: _tabController,
                                  tabs: [
                                    Tab(child: CustomText(LocaleKeys.provider.tr())),
                                    Tab(child: CustomText(LocaleKeys.user.tr())),
                                  ],
                                ),

                              VerticalSpace(kScreenPaddingLarge.h),
                              _buildForm(),
                              VerticalSpace(kScreenPaddingNormal.h),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: kFormPaddingAllSmall),
                                  child: GestureDetector(
                                    onTap: () {
                                      AppDialogs().forgetPassword(
                                        title: LocaleKeys.forgetPassword.tr(),
                                        context: context,
                                        message: LocaleKeys.enterRegisteredEmailAddress.tr(),
                                        typeIsProvider: typeIsProvider,
                                      );
                                    },
                                    child: CustomText(tr(LocaleKeys.forgetPassword)).footer().start(),
                                  ),
                                ),
                              ),
                              VerticalSpace(kScreenPaddingNormal.h),
                              CustomButton(
                                loading: (state is LoginViewLoading),
                                title: tr(LocaleKeys.login),
                                onTap: () => _onSubmit(context),
                                color: Colors.black,
                              ),
                              VerticalSpace(kScreenPaddingNormal.h),
                              Center(
                                child: TextClickWidget(
                                  text: tr(LocaleKeys.questionCreateAccount),
                                  subText: tr(LocaleKeys.signUp),
                                  textColor: Colors.grey,
                                  onTap: () => NavigationService.push(RoutesServices.servicesUserTypeScreen),
                                ),
                              ),
                              VerticalSpace(kScreenPaddingNormal.h),
                            ],
                          ),
                        ),
                        VerticalSpace(kScreenPaddingNormal.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: AppBackButton(),
            ),
          ],
        ),
      ),
    );
  }

  _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextFieldPhoneCountry(
              controller: _phoneController,
              selectedCountry: _selectedCountry,
              onCountryChanged: (value) {
                _selectedCountry = value;
                setState(() {});
              },
            ),
            const VerticalSpace(kScreenPaddingNormal),
            CustomTextFieldPassword(hint: tr(LocaleKeys.password), controller: _passwordController),
          ],
        ));
  }
}

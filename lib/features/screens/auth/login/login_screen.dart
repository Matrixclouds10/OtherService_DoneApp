import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/data/injection.dart';
import 'package:weltweit/features/core/routing/routes_provider.dart';
import 'package:weltweit/features/data/models/base/response_model.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/core/routing/routes.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/services/domain/request_body/check_otp_body.dart';
import 'package:weltweit/features/services/domain/request_body/login_body.dart';
import 'package:weltweit/features/widgets/app_back_button.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';
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
  bool typeIsProvider = false;
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      typeIsProvider = _tabController.index == 0;
      logger.d('typeIsProvider $typeIsProvider');
    });
    if (kDebugMode) {
      _phoneController.text = '1006896871';
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
        var response = await BlocProvider.of<LoginCubit>(context, listen: false).login(
          phone,
          password,
          typeIsProvider,
        );

        if (response.isSuccess) {
          UserModel userEntity = response.data;
          String token = userEntity.token ?? '';
          if (token.isNotEmpty) {
            AppPrefs prefs = getIt();
            prefs.save(PrefKeys.token, token);
            prefs.save(PrefKeys.isTypeProvider, typeIsProvider);
          }
          if (typeIsProvider) {
            Navigator.pushNamedAndRemoveUntil(context, RoutesProvider.providerLayoutScreen, (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, RoutesServices.servicesLayoutScreen, (route) => false);
          }
        } else if (response.error?.code == 301) {
          NavigationService.push(RoutesServices.servicesOtpScreen, arguments: {
            'phone': _phoneController.text,
            'code': _viewModel.body.code,
            'checkOTPType': CheckOTPType.register,
            'typeIsProvider': typeIsProvider,
          });
        } else {
          if (response is ResponseModel) {
            String message = response.error?.errorMessage ?? response.message ?? '';
            AppSnackbar.show(
              context: context,
              title: LocaleKeys.notification,
              message: message,
              type: SnackbarType.error,
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
    LoginBody body = context.watch<LoginCubit>().body;

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
                                "مرحبا بك \n سجل دخولك للإستمرار",
                                style: const TextStyle().titleStyle(fontSize: 18).boldStyle().customColor(primaryColor),
                                textAlign: TextAlign.center,
                              ),
                              //Tabs
                              TabBar(
                                controller: _tabController,
                                
                                tabs: const [
                                  Tab(child: CustomText("مزود خدمة")),
                                  Tab(child: CustomText("مستخدم")),
                                ],
                              ),

                              VerticalSpace(kScreenPaddingLarge.h),
                              _buildForm(body),
                              VerticalSpace(kScreenPaddingNormal.h),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: kFormPaddingAllSmall),
                                  child: GestureDetector(
                                    onTap: () {},
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

  _buildForm(LoginBody body) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextFieldPhoneCode(
              label: tr(LocaleKeys.yourPhoneNumber),
              controller: _phoneController,
              onCountryChanged: _viewModel.onCountryCode,
              disableLengthCheck: true,
              textInputAction: TextInputAction.next,
              countries: const ["SA"],
            ),
            const VerticalSpace(kScreenPaddingNormal),
            CustomTextFieldPassword(hint: tr(LocaleKeys.password), controller: _passwordController),
          ],
        ));
  }
}

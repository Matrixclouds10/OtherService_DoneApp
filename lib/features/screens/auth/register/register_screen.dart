import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/core/utils/echo.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/core/routing/routes_provider.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/data/models/response/country/country_model.dart';
import 'package:weltweit/features/domain/request_body/check_otp_body.dart';
import 'package:weltweit/features/domain/request_body/register_body.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/presentation/component/inputs/phone_country/custom_text_filed_phone_country.dart';

import 'register_cubit.dart';

class RegisterScreen extends StatefulWidget {
  final bool typeIsProvider;
  const RegisterScreen({required this.typeIsProvider, Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  CountryModel? selectedCountry;
  bool joinAsIndividual = true;
  bool isConfirmTerms = true;
  File? image;

  final _formKey = GlobalKey<FormState>();

  void _onSubmit(context) async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        String name = _nameController.text;
        String phone = _phoneController.text;
        String email = _emailController.text;
        String password = _passwordController.text;
        String confirmPassword = _confirmPasswordController.text;

        if (!isConfirmTerms) {
          AppSnackbar.show(
            context: context,
            title: LocaleKeys.notification.tr(),
            message: LocaleKeys.mustAcceptTerms.tr(),
          );
          return;
        }
        if (selectedCountry == null) {
          AppSnackbar.show(
            context: context,
            title: LocaleKeys.notification.tr(),
            message: LocaleKeys.mustSelectCountry.tr(),
          );
          return;
        }
        RegisterBody registerBody = RegisterBody(
          confirmPassword: confirmPassword,
          email: email,
          image: image,
          name: name,
          password: password,
          mobile: phone,
          country: selectedCountry!,
          isConfirmTerms: isConfirmTerms,
          typeIsProvider: widget.typeIsProvider,
          isIndividual: joinAsIndividual,
        );

        var response = await BlocProvider.of<RegisterCubit>(context, listen: false).register(registerBody);
        if (response.error == null) {
          UserModel userEntity = UserModel.fromJson(response.data);
          String token = userEntity.token ?? '';
          int id = userEntity.id ?? 0;
          kEcho("countryId ${userEntity.countryModel?.id}");
          int countryId = userEntity.countryId ?? userEntity.countryModel?.id ?? 0;
          if (token.isNotEmpty) {
            kEcho("Navigate token.isNotEmpty");
            AppPrefs prefs = getIt();
            prefs.save(PrefKeys.token, token);
            if (countryId != 0) prefs.save(PrefKeys.countryId, countryId);
            prefs.save(PrefKeys.id, id);
            prefs.save(PrefKeys.isTypeProvider, widget.typeIsProvider);
            if (widget.typeIsProvider) {
              Navigator.pushNamedAndRemoveUntil(context, RoutesProvider.providerLayoutScreen, (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(context, RoutesServices.servicesLayoutScreen, (route) => false);
            }
          } else {
            kEcho("Navigate RoutesServices.servicesOtpScreen");
            NavigationService.push(RoutesServices.servicesOtpScreen, arguments: {
              'email': _emailController.text,
              'code': selectedCountry?.code ?? '20',
              'checkOTPType': CheckOTPType.register,
              'typeIsProvider': widget.typeIsProvider,
            });
          }
        } else {
          kEcho(":error: ${response.error}");
          AppSnackbar.show(
            context: context,
            title: LocaleKeys.notification.tr(),
            message: response.message ?? LocaleKeys.somethingWentWrong.tr(),
          );
        }
      }
    }
  }

  @override
  void initState() {
    if (kDebugMode) {
      _nameController.text = 'Mr.Test';
      _emailController.text = 'test@test.com';
      _phoneController.text = '1010101010';
      _passwordController.text = '123456';
      _confirmPasswordController.text = '123456';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RegisterState state = context.watch<RegisterCubit>().state;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.imagesBk2),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: tr(LocaleKeys.register),
          color: Colors.transparent,
          titleColor: primaryColor,
          isCenterTitle: true,
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListAnimator(
                    children: [
                      Center(
                        child: CustomPersonImage(
                          size: 110.r,
                          imageUrl: image?.path,
                          canEdit: true,
                          onAttachImage: (File file) {
                            log('pickImage', 'return ${file.path}');
                            image = file;
                            setState(() {});
                          },
                        ),
                      ),
                      // if (widget.typeIsProvider) ...[
                      //   CustomText(LocaleKeys.joinAs.tr(), align: TextAlign.start, pv: 0),
                      //Row for two radio buttons
                      // Row(
                      //   children: [
                      //     //Radio button for user
                      //     Flexible(
                      //       flex: 1,
                      //       child: RadioListTile(
                      //         value: joinAsIndividual,
                      //         dense: true,
                      //         contentPadding: EdgeInsets.zero,
                      //         visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      //         title: CustomText(LocaleKeys.indvidual.tr(), align: TextAlign.start),
                      //         groupValue: true,
                      //         onChanged: (value) {
                      //           joinAsIndividual = true;
                      //           setState(() {});
                      //         },
                      //       ),
                      //     ),
                      //     Flexible(
                      //       flex: 1,
                      //       child: RadioListTile(
                      //         value: joinAsIndividual,
                      //         dense: true,
                      //         contentPadding: EdgeInsets.zero,
                      //         visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      //         title: CustomText(LocaleKeys.company.tr(), align: TextAlign.start),
                      //         groupValue: false,
                      //         onChanged: (value) {
                      //           joinAsIndividual = false;
                      //           setState(() {});
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // ],
                      _buildForm(),
                      CheckboxListTile(
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0.r),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0.r),
                        ),
                        side: MaterialStateBorderSide.resolveWith(
                          (states) => BorderSide(width: 1.w, color: Colors.black12),
                        ),
                        value: isConfirmTerms,
                        title: CustomText(tr(LocaleKeys.registerPrivacyMassage)).footer().start(),
                        onChanged: (value) {
                          isConfirmTerms = !isConfirmTerms;
                          setState(() {});
                        },
                      ),
                      VerticalSpace(kScreenPaddingNormal.h),
                      CustomButton(
                        onTap: () => _onSubmit(context),
                        isRounded: true,
                        loading: (state is RegisterLoading),
                        color: Colors.black,
                        title: tr(LocaleKeys.register),
                      ),
                      VerticalSpace(kScreenPaddingNormal.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextFieldNormal(
              controller: _nameController,
              hint: tr(LocaleKeys.name),
              textInputAction: TextInputAction.next,
              autofocus: false,
            ),
            const VerticalSpace(kScreenPaddingNormal),
            CustomTextFieldPhoneCountry(
              controller: _phoneController,
              selectedCountry: selectedCountry,
              onCountryChanged: (value) {
                selectedCountry = value;
              },
            ),
            const VerticalSpace(kScreenPaddingNormal),
            CustomTextFieldEmail(label: tr(LocaleKeys.email), controller: _emailController, textInputAction: TextInputAction.next),
            const VerticalSpace(kScreenPaddingNormal),
            CustomTextFieldPassword(label: tr(LocaleKeys.password), controller: _passwordController, textInputAction: TextInputAction.next),
            const VerticalSpace(kScreenPaddingNormal),
            CustomTextFieldPassword(
              label: tr(LocaleKeys.confirmPassword),
              controller: _confirmPasswordController,
              textInputAction: TextInputAction.done,
              validateFunc: (pass) {
                if (pass != _passwordController.text) {
                  return tr(LocaleKeys.passwordNotSame);
                }
              },
            ),
            SizedBox(height: 8)
          ],
        ));
  }
}

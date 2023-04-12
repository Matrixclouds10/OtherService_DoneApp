import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/domain/logger.dart';
import 'package:weltweit/domain/request_body/check_otp_body.dart';
import 'package:weltweit/domain/request_body/register_body.dart';
import 'package:weltweit/features/services/core/routing/routes.dart';
import 'package:weltweit/features/services/core/widgets/custom_text.dart';
import 'package:weltweit/features/services/widgets/app_snackbar.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/presentation/component/inputs/phone_country/countries.dart';

import 'register_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isConfirmTerms = true;
  File? image;
  Country? country;

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
        if (country == null) {
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
          country: country!,
          isConfirmTerms: isConfirmTerms,
        );

        var response = await BlocProvider.of<RegisterCubit>(context, listen: false).register(registerBody);
        if (response.isSuccess) {
          NavigationService.push(RoutesServices.servicesOtpScreen, arguments: {
            'phone': _phoneController.text,
            'code': country?.code,
            'checkOTPType': CheckOTPType.register,
          });
        } else {
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
                          size: 90.r,
                          imageUrl: image?.path,
                          canEdit: true,
                          onAttachImage: (File file) {
                            log('pickImage', 'return ${file.path}');
                            image = file;
                            setState(() {});
                          },
                        ),
                      ),
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
            CustomTextFieldPhoneCode(
              label: tr(LocaleKeys.yourPhoneNumber),
              controller: _phoneController,
              textInputAction: TextInputAction.next,
              onCountryChanged: (countryVal) {
                country = countryVal;
              },
              disableLengthCheck: true,
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
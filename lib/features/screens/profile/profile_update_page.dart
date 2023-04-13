import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/logic/profile/profile_cubit.dart';
import 'package:weltweit/features/data/models/response/auth/user_model.dart';
import 'package:weltweit/features/domain/usecase/profile/change_password_usecase.dart';
import 'package:weltweit/features/domain/usecase/profile/update_profile_usecase.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/presentation/component/inputs/phone_country/countries.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  File? image;
  String? nerworkImage;
  Country? country = Country(
  name: "Saudi Arabia",
  flag: "🇸🇦",
  code: "SA",
  dialCode: "966",
  minLength: 9,
  maxLength: 9,
);
  bool isMale = true;

  final _formKey = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();

  void _onSubmit(context) async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        String name = _nameController.text;
        String phone = _phoneController.text;
        String email = _emailController.text;

        if (country == null) {
          AppSnackbar.show(
            context: context,
            title: LocaleKeys.notification.tr(),
            message: LocaleKeys.mustSelectCountry.tr(),
          );
          return;
        }
        UpdateProfileParams updateProfileParams = UpdateProfileParams(
          name: name,
          mobileNumber: phone,
          email: email,
          image: image,
          countryCode: country?.dialCode,
          countryIso: country?.name,
          genderIsMale: isMale,
        );
        await BlocProvider.of<ProfileCubit>(context, listen: false).updateProfile(updateProfileParams);
      }
    }
  }

  void _onSubmitPassword(context) async {
    if (_formKeyPassword.currentState != null) {
      if (_formKeyPassword.currentState!.validate()) {
        _formKeyPassword.currentState!.save();

        String password = _passwordController.text;
        String confirmPassword = _confirmPasswordController.text;

        if (password.length < 6) {
          AppSnackbar.show(
            context: context,
            title: LocaleKeys.notification.tr(),
            message: LocaleKeys.passwordMustBeAtLeast.tr(),
          );
          return;
        }
        if (password != confirmPassword) {
          AppSnackbar.show(
            context: context,
            title: LocaleKeys.notification.tr(),
            message: LocaleKeys.passwordNotMatch.tr(),
          );
          return;
        }
        ChangePasswordParams updateProfileParams = ChangePasswordParams(
          newPassword: password,
        );
        await BlocProvider.of<ProfileCubit>(context, listen: false).updatePassword(updateProfileParams);
      }
    }
  }

  @override
  void initState() {
    BlocProvider.of<ProfileCubit>(context, listen: false).getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocaleKeys.updateProfile.tr(), color: Colors.white),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            print('------> state: $state');
            if (state.updateState == BaseState.loaded) {
              AppSnackbar.show(
                context: context,
                title: LocaleKeys.notification.tr(),
                type: SnackbarType.success,
                message: LocaleKeys.updateProfileSuccess.tr(),
              );
            } else if (state.updatePasswordState == BaseState.loaded) {
              AppSnackbar.show(
                context: context,
                type: SnackbarType.success,
                title: LocaleKeys.notification.tr(),
                message: LocaleKeys.updatePasswordSuccess.tr(),
              );
            } else if (state.updateState == BaseState.error) {
              AppSnackbar.show(
                context: context,
                type: SnackbarType.error,
                title: LocaleKeys.notification.tr(),
                message: state.error?.errorMessage ?? LocaleKeys.somethingWentWrong.tr(),
              );
            } else if (state.updatePasswordState == BaseState.error) {
              AppSnackbar.show(
                context: context,
                type: SnackbarType.error,
                title: LocaleKeys.notification.tr(),
                message: state.error?.errorMessage ?? LocaleKeys.somethingWentWrong.tr(),
              );
            }
          },
          builder: (context, state) {
            switch (state.state) {
              case BaseState.loading:
                return const Center(child: CircularProgressIndicator());
              case BaseState.loaded:
                _nameController.text = state.data?.name ?? "";
                _emailController.text = state.data?.email ?? "";
                _phoneController.text = state.data?.mobileNumber ?? "";
                nerworkImage = state.data?.image;
                if (countries.where((element) => element.dialCode == state.data?.countryCode).isNotEmpty) {
                  country = countries.where((element) => element.dialCode == state.data?.countryCode).first;
                } else {
                  country = countries.firstWhere((element) => element.name == "Saudi Arabia");
                }

                return _buildBody(context, state.data);
              case BaseState.error:
                return ErrorLayout(errorModel: state.error);
              default:
                return ErrorLayout(errorModel: state.error);
            }
          },
        ),
      ),
    );
  }

  _buildBody(BuildContext context, UserModel? user) {
    if (user == null) return Container();
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildForm(),
          SizedBox(height: 8),
          BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (previous, current) => previous.updateState != current.updateState,
            builder: (context, state) {
              return CustomButton(
                onTap: () => _onSubmit(context),
                isRounded: true,
                loading: (state.updateState == BaseState.loading),
                color: Colors.black,
                title: LocaleKeys.update.tr(),
              );
            },
          ),
          SizedBox(height: 30),
          CustomText(LocaleKeys.changePassword.tr()),
          SizedBox(height: 8),
          _buildPasswordForm(),
          SizedBox(height: 8),
          BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (previous, current) => previous.updatePasswordState != current.updatePasswordState,
            builder: (context, state) {
              return CustomButton(
                onTap: () => _onSubmitPassword(context),
                isRounded: true,
                loading: (state.updatePasswordState == BaseState.loading),
                color: Colors.black,
                title: LocaleKeys.update.tr(),
              );
            },
          ),
          SizedBox(height: 30),
          TextButton(
              onPressed: () async {
                bool? status = await AppDialogs().showDeleteAccountDialog(context);
                if (status != null && status) {
                  if (context.mounted) context.read<ProfileCubit>().deleteAccount();
                }
              },
              child: CustomText(LocaleKeys.deleteAccount.tr(), color: Colors.red).footer()),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Center(
              child: CustomPersonImage(
                size: 76.r,
                imageUrl: image?.path ?? nerworkImage,
                canEdit: true,
                onAttachImage: (File file) {
                  image = file;
                  setState(() {});
                },
              ),
            ),
            const VerticalSpace(kScreenPaddingNormal),
            CustomTextFieldNormal(
              controller: _nameController,
              hint: LocaleKeys.name.tr(),
              textInputAction: TextInputAction.next,
              autofocus: false,
              label: LocaleKeys.name.tr(),
            ),
            const VerticalSpace(kScreenPaddingNormal),
            CustomTextFieldPhoneCode(
              label: tr(LocaleKeys.yourPhoneNumber),
              controller: _phoneController,
              defaultValue: _phoneController.text,
              textInputAction: TextInputAction.next,
              disableLengthCheck: true,
              countries: const ["SA"],
              initialCountryCode: country?.dialCode,
              onCountryChanged: (value) {
                country = value;
              },
            ),
            const VerticalSpace(kScreenPaddingNormal),
            CustomTextFieldEmail(label: tr(LocaleKeys.email), controller: _emailController, textInputAction: TextInputAction.next),
            const VerticalSpace(kScreenPaddingNormal),
            Row(
              children: [
                ...[true, false].map(
                  (e) {
                    return Expanded(
                      child: RadioListTile(
                        value: e,
                        dense: true,
                        groupValue: isMale,
                        onChanged: (value) {
                          logger.d(value);
                          isMale = e;
                          setState(() {});
                        },
                        title: CustomText(e ? tr(LocaleKeys.male) : tr(LocaleKeys.female)),
                      ),
                    );
                  },
                ).toList(),
              ],
            ),
            SizedBox(height: 8)
          ],
        ));
  }

  _buildPasswordForm() {
    return Form(
        key: _formKeyPassword,
        child: Column(
          children: [
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

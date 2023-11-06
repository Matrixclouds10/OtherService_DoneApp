import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/domain/usecase/contact_us/contact_us_usecase.dart';
import 'package:weltweit/features/logic/contact_us/contact_us_cubit.dart';
import 'package:weltweit/features/screens/about/contact_actions.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: servicesTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText(LocaleKeys.contactUs.tr()).header(),
        isCenterTitle: true,
      ),
      body: BlocListener<ContactUsCubit, ContactUsState>(
        listener: (context, state) {
          if (state.state == BaseState.error) return AppSnackbar.show(context: context, message: state.error?.errorMessage ?? '');
          if (state.state == BaseState.loaded) {
            _nameController.clear();
            _emailController.clear();
            _messageController.clear();
            return AppSnackbar.show(context: context, message: state.data);
          }
        },
        child: SingleChildScrollView(
          child: ListAnimator(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              //Log
              SizedBox(height: 12),
              Image.asset(
                Assets.imagesLogo,
                width: double.infinity,
                height: 90,
              ),
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    CustomTextFieldNormal(hint: LocaleKeys.name.tr(), controller: _nameController),
                    const SizedBox(height: 12),
                    CustomTextFieldEmail(hint: LocaleKeys.email.tr(), controller: _emailController),
                    const SizedBox(height: 12),
                    CustomTextFieldArea(hint: LocaleKeys.message.tr(), controller: _messageController),
                    const SizedBox(height: 12),
                    BlocBuilder<ContactUsCubit, ContactUsState>(
                      builder: (context, state) {
                        return CustomButton(
                          onTap: () async {
                            if (state.state == BaseState.loading) return;
                            if (_nameController.text.isEmpty) return AppSnackbar.show(context: context, message: LocaleKeys.msgNameRequired.tr());
                            if (_emailController.text.isEmpty) return AppSnackbar.show(context: context, message: LocaleKeys.msgEmailRequired.tr());
                            if (_messageController.text.isEmpty) {
                              return AppSnackbar.show(
                                  context: context,
                                  message: LocaleKeys.msgMessageRequired.tr());
                            }
                            AppPrefs prefs = getIt<AppPrefs>();
                            bool isProvider = prefs.get(PrefKeys.isTypeProvider,
                                defaultValue: false);
                            ContactUsParams params = ContactUsParams(
                              name: _nameController.text,
                              email: _emailController.text,
                              message: _messageController.text,
                              type: isProvider ? 'provider' : 'client',
                            );
                            bool status =
                                await context.read<ContactUsCubit>()(params);
                            if (status && mounted) {
                              Navigator.pop(context);
                            }
                          },
                          loading: state.state == BaseState.loading,
                          title: LocaleKeys.send.tr(),
                          color: servicesTheme.primaryColorLight,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                  
                    ContactAction(showDivider: true),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

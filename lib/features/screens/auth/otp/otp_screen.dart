import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/core/routing/routes_provider.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/domain/request_body/check_otp_body.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/presentation/component/text/click_text.dart';

import 'otp_cubit.dart';

class OTPScreen extends StatefulWidget {
  final String _phone;
  final String _code;
  final CheckOTPType _checkOTPType;
  final bool _typeIsProvider;
  @override
  _OTPScreenState createState() => _OTPScreenState();

  const OTPScreen({
    super.key,
    required bool typeIsProvider,
    required String code,
    required String phone,
    required CheckOTPType checkOTPType,
  })  : _phone = phone,
        _code = code,
        _checkOTPType = checkOTPType,
        _typeIsProvider = typeIsProvider;
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _codeController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  void _onResendCode() async {
    await BlocProvider.of<OtpCubit>(context, listen: false).reSendCode(phone: widget._phone);
  }

  void _onSubmit(context) async {
    String otp = _codeController.text;
    if (otp.length == 4) {
      var response = await BlocProvider.of<OtpCubit>(context, listen: false).otpCode(
        phone: widget._phone,
        otp: otp,
        code: widget._code,
        type: widget._checkOTPType,
        typeIsProvider: widget._typeIsProvider,
      );

      if (response.isSuccess) {
        if (widget._checkOTPType == CheckOTPType.register && !widget._typeIsProvider) {
          Navigator.pushNamedAndRemoveUntil(context, RoutesServices.servicesLayoutScreen, (route) => false);
        }else if (widget._checkOTPType == CheckOTPType.register && widget._typeIsProvider) {
          Navigator.pushNamedAndRemoveUntil(context, RoutesProvider.providerLayoutScreen, (route) => false);
        } else {
          // NavigationService.push(Routes.resetPasswordScreen, arguments: {'phone': widget._phone});
        }
      } else {
        _codeController.clear();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = context.watch<OtpCubit>().isLoading;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.imagesBk2),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(title: el.tr(LocaleKeys.phoneVerification)),
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * .99,
              child: ListAnimator(
                children: [
                  VerticalSpace(50.h),

                  Center(
                    child: Text(
                      el.tr(LocaleKeys.otpVerification),
                      textAlign: TextAlign.center,
                      style: const TextStyle().titleStyle().boldStyle(),
                    ),
                  ),
                  VerticalSpace(kScreenPaddingNormal.h),
                  Center(
                    child: Text(
                      '${el.tr(LocaleKeys.anAuthenticationCodeHasBeenSentTo)}\n (${widget._code}) ${widget._phone}',
                      textAlign: TextAlign.center,
                      style: const TextStyle().descriptionStyle(fontSize: 14),
                    ),
                  ),
                  // const ConfirmCodeForm(),
                  VerticalSpace(kScreenPaddingNormal.h),

                  _buildForm(),
                  _buildResendCode(),
                  VerticalSpace(kScreenPaddingNormal.h),

                  Center(child: CustomButton(loading: isLoading, title: el.tr(LocaleKeys.verifyNow), onTap: () => _onSubmit(context))),
                  VerticalSpace(kScreenPaddingNormal.h),
                ],
              ),
            )),
      ),
    );
  }

  _buildResendCode() {
    bool isLoading = context.watch<OtpCubit>().isResendLoading;
    bool isTimerDone = context.watch<OtpCubit>().isTimerDone;

    return Column(
      children: [
        isLoading
            ? const CustomLoadingSpinner()
            : TextClickWidget(
                text: el.tr(LocaleKeys.iDidNotReceiveCode),
                subText: el.tr(LocaleKeys.resendCode),
                onTap: () => _onResendCode(),
              ),
        VerticalSpace(kScreenPaddingNormal.h),
        if (!isTimerDone && !isLoading)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TimerCountdown(
                format: CountDownTimerFormat.minutesSeconds,
                enableDescriptions: false,
                endTime: DateTime.now().add(const Duration(minutes: 1)),
                spacerWidth: 1.0,
                timeTextStyle: const TextStyle(),
                onEnd: () => BlocProvider.of<OtpCubit>(context, listen: false).onTimerEnd(),
              ),
              Text(
                ' ${el.tr(LocaleKeys.secLeft)}',
                style: const TextStyle(),
              )
            ],
          ),
      ],
    );
  }

  _buildForm() {
    return Center(
      child: PinCodeTextField(
        appContext: context,
        length: 4,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        obscureText: false,
        showCursor: false,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          inactiveColor: Colors.transparent,
          disabledColor: Theme.of(context).cardColor,
          activeColor: Colors.transparent,
          selectedColor: Colors.transparent,
          errorBorderColor: Theme.of(context).colorScheme.error,
          inactiveFillColor: Colors.grey[50],
          selectedFillColor: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(kFormRadius),
          fieldHeight: 48.r,
          fieldWidth: 48.r,
          activeFillColor: Theme.of(context).cardColor,
        ),
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        textStyle: const TextStyle().titleStyle(fontSize: 24),
        enableActiveFill: true,
        boxShadows: const [BoxShadow(color: grayScaleLiteColor, spreadRadius: 1, blurRadius: 5)],
        controller: _codeController,
        beforeTextPaste: (text) {
          return true;
        },
        onChanged: (String value) {},
      ),
    );
  }
}

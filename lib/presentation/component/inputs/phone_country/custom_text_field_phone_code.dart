import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/features/data/models/location/country_model.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

import '../base_form.dart';
import 'country_picker_dialog.dart';
import 'phone_number_model.dart';

class CustomTextFieldPhoneCode extends StatefulWidget {
  final String? suffixText;
  final String? hint;
  final String? label;

  final bool noBorder;
  final bool isRequired;
  final bool enable;

  final int? lines;
  final int? maxLength;

  final double? fontSize;
  final double? radius;
  final double? contentPaddingH;

  final Widget? icon;
  final Widget? suffixData;

  final IconData? iconData;
  final IconData? suffixIconData;

  final Color? background;

  final ValueChanged<String>? onChange;
  final Function? validateFunc;
  final Function? onSubmit;

  final bool obscureText;

  final TextAlign textAlign;

  final VoidCallback? onTap;

  final bool readOnly;
  final FormFieldSetter<PhoneNumber>? onSaved;

  final ValueChanged<PhoneNumber>? onChanged;

  final ValueChanged<CountryModel>? onCountryChanged;

  final FutureOr<String?> Function(PhoneNumber?)? validator;

  final TextInputType keyboardType;

  final TextEditingController? controller;

  final void Function(String)? onSubmitted;

  final bool enabled;

  final Brightness? keyboardAppearance;

  final String? initialValue;

  final CountryModel? initialCountry;

  final List<CountryModel> countries;

  final bool disableLengthCheck;

  final bool showDropdownIcon;

  final BoxDecoration dropdownDecoration;

  final TextStyle? dropdownTextStyle;

  final List<TextInputFormatter>? formatter;

  final String searchText;

  final IconPosition dropdownIconPosition;

  final Icon dropdownIcon;

  final bool autofocus;

  final bool showCountryFlag;

  final EdgeInsetsGeometry flagsButtonPadding;

  final TextInputAction? textInputAction;

  final PickerDialogStyle? pickerDialogStyle;

  final EdgeInsets flagsButtonMargin;

  const CustomTextFieldPhoneCode({
    Key? key,
    this.suffixText,
    this.hint,
    this.label,
    this.readOnly = false,
    this.noBorder = false,
    this.isRequired = true,
    this.autofocus = false,
    this.enable = true,
    this.lines,
    this.maxLength,
    this.fontSize,
    this.radius,
    this.contentPaddingH,
    this.formatter,
    this.icon,
    this.suffixData,
    this.iconData,
    this.suffixIconData,
    this.background,
    this.onTap,
    this.searchText = '',
    this.onChange,
    this.validateFunc,
    this.onSubmit,
    this.controller,
    this.textInputAction,
    this.initialCountry,
    this.obscureText = false,
    this.textAlign = TextAlign.left,
    this.initialValue,
    this.keyboardType = TextInputType.phone,
    this.dropdownTextStyle,
    this.onSubmitted,
    this.validator,
    this.onChanged,
    required this.countries,
    this.onCountryChanged,
    this.onSaved,
    this.showDropdownIcon = true,
    this.dropdownDecoration = const BoxDecoration(),
    this.enabled = true,
    this.keyboardAppearance,
    this.dropdownIconPosition = IconPosition.leading,
    this.dropdownIcon = const Icon(Icons.arrow_drop_down),
    this.showCountryFlag = true,
    this.disableLengthCheck = false,
    this.flagsButtonPadding = EdgeInsets.zero,
    this.pickerDialogStyle,
    this.flagsButtonMargin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  _CustomTextFieldPhoneCodeState createState() => _CustomTextFieldPhoneCodeState();
}

class _CustomTextFieldPhoneCodeState extends State<CustomTextFieldPhoneCode> {
  CountryModel? _selectedCountry;

  String? validatorMessage;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry;
  }

  Future<void> _changeCountry() async {
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => StatefulBuilder(
        builder: (ctx, setState) => CountryPickerDialog(
          style: widget.pickerDialogStyle,
          filteredCountries: widget.countries,
          searchText: widget.searchText,
          countryList: widget.countries,
          selectedCountry: _selectedCountry,
          onCountryChanged: (CountryModel country) {
            _selectedCountry = country;
            widget.onCountryChanged?.call(country);
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      background: widget.background,
      prefixIcon: widget.iconData ?? Icons.phone_android_sharp,
      hint: widget.hint,
      onTap: widget.onTap,
      autoValidate: false,
      enable: widget.enable,
      noBorder: widget.noBorder,
      isRequired: widget.isRequired,
      contentPaddingH: widget.contentPaddingH,
      lines: widget.lines,
      fontSize: widget.fontSize,
      radius: widget.radius,
      suffixIconData: widget.suffixIconData,
      suffixText: widget.suffixText,
      controller: widget.controller,
      suffixData: widget.suffixData,
      onSubmit: widget.onSubmit,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      icon: widget.icon,
      textInputAction: widget.textInputAction,
      prefixWidget: _buildFlagsButton(),
      defaultValue: widget.controller?.text,
      obscureText: widget.obscureText,
      textAlign: widget.textAlign,
      onSaved: (value) {},
      onChange: widget.onChange,
      validateFunc: (value) {},
      type: widget.keyboardType,
      formatter: widget.formatter ?? [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Container _buildFlagsButton() {
    String selectCountryHint = LocaleKeys.selectCountry.tr();
    if (kDebugMode) selectCountryHint = '$selectCountryHint (${widget.countries.length})';
    return Container(
      margin: widget.flagsButtonMargin,
      child: DecoratedBox(
        decoration: widget.dropdownDecoration,
        child: InkWell(
          borderRadius: widget.dropdownDecoration.borderRadius as BorderRadius?,
          onTap: widget.enabled ? _changeCountry : null,
          child: Padding(
            padding: widget.flagsButtonPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (widget.enabled && widget.showDropdownIcon && widget.dropdownIconPosition == IconPosition.leading) ...[
                  widget.dropdownIcon,
                  const SizedBox(width: 4),
                ],
                FittedBox(
                  child: Container(
                    decoration: BoxDecoration().chip().radius(radius: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      _selectedCountry?.title == null ? selectCountryHint : '${_selectedCountry?.title}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    _selectedCountry?.code == null ? " " : '+${_selectedCountry!.code}',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                if (widget.enabled && widget.showDropdownIcon && widget.dropdownIconPosition == IconPosition.trailing) ...[
                  const SizedBox(width: 4),
                  widget.dropdownIcon,
                ],
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum IconPosition {
  leading,
  trailing,
}

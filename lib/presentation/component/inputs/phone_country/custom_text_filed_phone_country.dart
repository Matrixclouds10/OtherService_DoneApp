import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/features/data/models/location/country_model.dart';
import 'package:weltweit/features/logic/location_country/country_cubit.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

class CustomTextFieldPhoneCountry extends StatefulWidget {
  final TextEditingController controller;
  final Function(CountryModel) onCountryChanged;
  final CountryModel? selectedCountry;

  const CustomTextFieldPhoneCountry({
    Key? key,
    required this.controller,
    required this.selectedCountry,
    required this.onCountryChanged,
  }) : super(key: key);

  @override
  State<CustomTextFieldPhoneCountry> createState() => _CustomTextFieldPhoneCountryState();
}

class _CustomTextFieldPhoneCountryState extends State<CustomTextFieldPhoneCountry> {
  @override
  void initState() {
    super.initState();
    context.read<CountryCubit>().getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryCubit, CountryState>(
      builder: (context, state) {
        return CustomTextFieldPhoneCode(
          label: tr(LocaleKeys.yourPhoneNumber),
          controller: widget.controller,
          enable: state.data.isNotEmpty,
          onCountryChanged: (value) {
            widget.onCountryChanged(value);
            setState(() {});
          },
          disableLengthCheck: true,
          textInputAction: TextInputAction.next,
          countries: state.data,
          initialCountry: widget.selectedCountry,
        );
      },
    );
  }
}

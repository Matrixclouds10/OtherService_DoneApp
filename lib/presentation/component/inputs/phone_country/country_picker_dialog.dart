import 'package:flutter/material.dart';
import 'package:weltweit/core/utils/validators.dart';
import 'package:weltweit/features/data/models/response/country/country_model.dart';

import '../../../../core/resources/resources.dart';

class PickerDialogStyle {
  final Color? backgroundColor;

  final TextStyle? countryCodeStyle;

  final TextStyle? countryNameStyle;

  final Widget? listTileDivider;

  final EdgeInsets? listTilePadding;

  final EdgeInsets? padding;

  final Color? searchFieldCursorColor;

  final InputDecoration? searchFieldInputDecoration;

  final EdgeInsets? searchFieldPadding;

  final double? width;

  PickerDialogStyle({
    this.backgroundColor,
    this.countryCodeStyle,
    this.countryNameStyle,
    this.listTileDivider,
    this.listTilePadding,
    this.padding,
    this.searchFieldCursorColor,
    this.searchFieldInputDecoration,
    this.searchFieldPadding,
    this.width,
  });
}

class CountryPickerDialog extends StatefulWidget {
  final List<CountryModel> countryList;
  final CountryModel? selectedCountry;
  final ValueChanged<CountryModel> onCountryChanged;
  final String searchText;
  final List<CountryModel> filteredCountries;
  final PickerDialogStyle? style;

  const CountryPickerDialog({
    Key? key,
    required this.searchText,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
    required this.filteredCountries,
    this.style,
  }) : super(key: key);

  @override
  _CountryPickerDialogState createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  late List<CountryModel> _filteredCountries;
  CountryModel? _selectedCountry;

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = widget.filteredCountries;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final width = widget.style?.width ?? mediaWidth;
    const defaultHorizontalPadding = 24.0;
    const defaultVerticalPadding = 40.0;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(vertical: defaultVerticalPadding, horizontal: mediaWidth > (width + defaultHorizontalPadding * 2) ? (mediaWidth - width) / 2 : defaultHorizontalPadding),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: widget.style?.backgroundColor ?? Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(
            Radius.circular(kFormPaddingAllLarge),
          ),
        ),
        padding: widget.style?.padding ?? const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Padding(
              padding: widget.style?.searchFieldPadding ?? const EdgeInsets.all(0),
              child: TextField(
                cursorColor: widget.style?.searchFieldCursorColor,
                decoration: widget.style?.searchFieldInputDecoration ??
                    InputDecoration(
                      suffixIcon: const Icon(Icons.search),
                      labelText: widget.searchText,
                    ),
                onChanged: (value) {
                  _filteredCountries = Validators.isNumeric(value)
                      ? widget.countryList.where((country) => country.code!.contains(value)).toList()
                      : widget.countryList.where((country) => country.title!.toLowerCase().contains(value.toLowerCase())).toList();
                  if (mounted) setState(() {});
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredCountries.length,
                itemBuilder: (ctx, index) => Column(
                  children: <Widget>[
                    ListTile(
                      // leading: Image.asset(
                      //   'lib/presentation/component/inputs/phone_country/flags/${_filteredCountries[index].code?.toLowerCase()}.png',
                      //   width: 32,
                      // ),
                      contentPadding: widget.style?.listTilePadding,
                      title: Text(
                        _filteredCountries[index].title ?? '',
                        style: widget.style?.countryNameStyle ?? const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      trailing: _filteredCountries[index].code == null
                          ? null
                          : Text(
                              '+${_filteredCountries[index].code}',
                              style: widget.style?.countryCodeStyle ?? const TextStyle(fontWeight: FontWeight.w700),
                            ),
                      onTap: () {
                        _selectedCountry = _filteredCountries[index];
                        widget.onCountryChanged(_selectedCountry!);
                        Navigator.of(context).pop();
                      },
                    ),
                    widget.style?.listTileDivider ?? const Divider(thickness: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

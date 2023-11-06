import 'package:flutter/material.dart';

import '../../../../core/resources/resources.dart';

class PickerDialogStyle {
  final Color? backgroundColor;
  final Widget? listTileDivider;
  final EdgeInsets? listTilePadding;
  final EdgeInsets? padding;
  final Color? searchFieldCursorColor;
  final InputDecoration? searchFieldInputDecoration;
  final EdgeInsets? searchFieldPadding;
  final double? width;

  PickerDialogStyle({
    this.backgroundColor,
    this.listTileDivider,
    this.listTilePadding,
    this.padding,
    this.searchFieldCursorColor,
    this.searchFieldInputDecoration,
    this.searchFieldPadding,
    this.width,
  });
}

class ItemPickerDialog extends StatefulWidget {
  final List<String> countryList;
  final dynamic selectedItem;
  final ValueChanged<String?> onItemChanged;
  final String searchText;
  final List<String> filteredItems;

  const ItemPickerDialog({
    Key? key,
    required this.searchText,
    required this.countryList,
    required this.onItemChanged,
    required this.selectedItem,
    required this.filteredItems,
  }) : super(key: key);

  @override
  _ItemPickerDialogState createState() => _ItemPickerDialogState();
}

class _ItemPickerDialogState extends State<ItemPickerDialog> {
  late List<String> _filteredItems;
  String? _selectedItem;

  @override
  void initState() {
    _selectedItem = widget.selectedItem;
    _filteredItems = widget.filteredItems;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final width = mediaWidth;
    const defaultHorizontalPadding = 24.0;
    const defaultVerticalPadding = 40.0;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(vertical: defaultVerticalPadding, horizontal: mediaWidth > (width + defaultHorizontalPadding * 2) ? (mediaWidth - width) / 2 : defaultHorizontalPadding),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(
            Radius.circular(kFormPaddingAllLarge),
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0),
              child: TextField(
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  labelText: widget.searchText,
                ),
                onChanged: (value) {
                  _filteredItems = widget.countryList
                      .where(
                        (country) => country.toLowerCase().contains(value.toLowerCase()),
                      )
                      .toList();
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredItems.length,
                itemBuilder: (ctx, index) => Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      title: Text(
                        _filteredItems[index],
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      onTap: () {
                        _selectedItem = _filteredItems[index];
                        widget.onItemChanged(_selectedItem!);
                        Navigator.of(context).pop();
                      },
                    ),
                    const Divider(thickness: 1),
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

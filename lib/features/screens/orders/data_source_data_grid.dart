import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';

import '../../../generated/locale_keys.g.dart';
import '../../data/models/order/invoice.dart';
import '../../data/models/order/order.dart';


class ProductDataSource extends DataGridSource {
  ProductDataSource({required List<InvoiceModel> productData}) {
    _productData = productData
        .map<DataGridRow>((InvoiceModel e) => DataGridRow(cells: <DataGridCell>[
      DataGridCell<String>(columnName: LocaleKeys.serviceName.tr(), value: e.serviceName??''),
      DataGridCell<String>(columnName: LocaleKeys.servicePrice.tr(), value: '${e.price} ${LocaleKeys.rs.tr()}'),

    ]))
        .toList();
  }

  List<DataGridRow> _productData = <DataGridRow>[];

  @override
  List<DataGridRow> get rows => _productData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell e) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white, width: 1), // Line between cells
                right: BorderSide(color: Colors.white, width: 1), // Line between cells
                left: BorderSide(color: Colors.white, width: 1), // Line between cells
              ),
            ),
            child: Text('${e.value}',
                style: TextStyle(
                    fontSize: 13.sp,
                    color: Color(0xff6E6D71),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Tajawal')),
          );
        }).toList());
  }
}


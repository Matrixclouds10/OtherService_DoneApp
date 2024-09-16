import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';

import '../../../core/resources/color.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../presentation/component/custom_app_bar.dart';
import '../../../presentation/component/error_component.dart';
import '../../core/base/base_states.dart';
import '../../core/widgets/custom_text.dart';
import '../../data/models/order/invoice.dart';
import '../../data/models/order/order.dart';
import '../../logic/orders/orders_cubit.dart';
import '../../widgets/empty_widget.dart';
import 'data_source_data_grid.dart';

class InvoiceScreen extends StatefulWidget {
  final OrderModel orderModel;
  const InvoiceScreen({Key? key, required this.orderModel}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().getInvoiceOrders(orderId: widget.orderModel.id??0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
      titleWidget: CustomText(LocaleKeys.bill.tr()).header(),
      isCenterTitle: true,
      isBackButtonExist: true,
    ),
      body:
      BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state.invoiceState == BaseState.loaded) {
            return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text('#${state.invoiceData?.id ?? ''}',
                              style:
                              TextStyle(fontSize: 16.sp, fontWeight: FontWeight
                                  .w500)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Image.asset(
                                        'assets/images/logo.png',
                                        fit: BoxFit.contain,
                                        height: 65,
                                        width: 65,
                                      ),
                                    )
                                ),
                              )),
                        ),
                        SizedBox(height: 21.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(LocaleKeys.by.tr(),
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 14.h, bottom: 8.h),
                                      child: Text(
                                          state.invoiceData?.providerName ?? '',
                                          // '${LocaleKeys.app.tr()} Done',
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff6E6D71))),
                                    ),
                                    Text('',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff6E6D71)),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,

                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(LocaleKeys.to.tr(),
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 14.h, bottom: 8.h),
                                      child: Text(
                                          state.invoiceData?.clientName ?? '',
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff6E6D71))),
                                    ),
                                    Text('',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff6E6D71)),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Column(
                                  children: <Widget>[
                                    Text(LocaleKeys.total.tr(),
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 14.h),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff7A768F),
                                          minimumSize: Size(75.w, 40.h),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero)),
                                      child: Text(
                                        '${state.invoiceData?.total ??
                                            '0.0'} ${LocaleKeys.rs.tr()}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Lateef',
                                          height: 0.8,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 50.h, bottom: 15.h),
                          child: SfDataGrid(
                            verticalScrollPhysics: NeverScrollableScrollPhysics(),
                            horizontalScrollPhysics: BouncingScrollPhysics(),
                            source: ProductDataSource(productData: [
                              state.invoiceData ?? InvoiceModel()
                            ]),
                            shrinkWrapRows: true,
                            columnWidthMode: ColumnWidthMode.fill,
                            rowHeight: 60.h,
                            columns: <GridColumn>[
                              GridColumn(
                                  columnName: LocaleKeys.serviceName.tr(),
                                  label: Container(
                                      color: primaryColor,
                                      alignment: Alignment.center,
                                      child: Text(LocaleKeys.serviceName.tr(),
                                        style: TextStyle(fontFamily: 'Tajawal',
                                            color: Colors.white),))),
                              GridColumn(
                                  columnName: LocaleKeys.servicePrice.tr(),
                                  label: Container(
                                      color: primaryColor,
                                      alignment: Alignment.center,
                                      child: Text(LocaleKeys.servicePrice.tr(),
                                          style: TextStyle(
                                              fontFamily: 'Tajawal',
                                              color: Colors.white)))),

                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                           Expanded(child:    Text(LocaleKeys.totalAfter.tr(), style: TextStyle(
                               fontSize: 12.sp,
                               fontWeight: FontWeight.w400,
                               color: Color(0xff6E6D71)),
                             textAlign: TextAlign.center,),),
                             Expanded(child:  Text('${state.invoiceData?.total ??
                                 '0.0'} ${LocaleKeys.rs.tr()}',
                               style: TextStyle(fontSize: 12.sp,
                                   fontWeight: FontWeight.w400,
                                   color: Color(0xff6E6D71)),
                               textAlign: TextAlign.center,),)
                            ],
                          ),
                        ),
                        SizedBox(height: 35.h,),
                      ],
                    ),
                  )
              );
          }
          else if ((state.invoiceState == BaseState.error)) {
            return ErrorView(
              message: state.error?.errorMessage ?? "حدث خطأ ما",
              onRetry: () {
                context.read<OrdersCubit>().getInvoiceOrders(orderId: widget.orderModel.id??0);
              },
            );

          }
          else{{
            return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ));
          }}

        },
      )

    );
  }
}





import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/services/data/model/response/address/address_item_model.dart';
import 'package:weltweit/features/services/modules/my_addresses/logic/address_cubit.dart';

import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

class MyAddressesPage extends StatelessWidget {
  const MyAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressCubit()..getAddresses(),
      child: Scaffold(
        backgroundColor: servicesTheme.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          color: Colors.white,
          titleWidget: CustomText(LocaleKeys.myAddresses.tr()).header(),
          isCenterTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<AddressCubit, AddressState>(
          builder: (context, state) {
            if (state is AddressStateLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AddressStateError) {
              return ErrorLayout(
                errorModel: state.errorModel,
                onRetry: () {
                  context.read<AddressCubit>().getAddresses();
                },
              );
            }

            if (state is AddressStateSuccess) {
              return ListView.builder(
                itemCount: state.addresses.length,
                itemBuilder: (context, index) {
                  return addressItemWidget(address: state.addresses[index]);
                },
              );
            }

            return Container(
              margin: const EdgeInsets.all(12),
              decoration:
                  const BoxDecoration(color: Colors.white).radius(radius: 12),
              child: SingleChildScrollView(
                child: ListAnimator(
                  children: [
                    const SizedBox(height: 12),
                    for (int i = 0; i < 10; i++)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: const CustomText("الرياض ",
                                                align: TextAlign.start)
                                            .header()),
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color:
                                            servicesTheme.colorScheme.secondary,
                                      ),
                                      onPressed: () {},
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                                const CustomText(
                                    "ميدان سننية، ٨٦ شارع المعتزبالله، ٣٤٣٤٧٧"),
                                //make default address
                                Row(
                                  children: [
                                    Checkbox(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      value: i == 0,
                                      fillColor: MaterialStateProperty.all(
                                          servicesTheme.primaryColor),
                                      onChanged: (value) {},
                                    ),
                                    const CustomText("تعيين كعنوان افتراضي"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Divider(),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget addressItemWidget({required AddressItemModel address}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: CustomText(address.name ?? '', ph: 8).start()),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: servicesTheme.colorScheme.secondary,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: servicesTheme.colorScheme.error,
                ),
                onPressed: () {},
              ),
            ],
          ),
          if (address.address != null && address.address!.length > 1)
            SizedBox(
              width: double.infinity,
              child: CustomText(address.address ?? '', ph: 8).start().footer(),
            ),
          if (address.regionName != null && address.regionName!.length > 1)
            SizedBox(
              width: double.infinity,
              child:
                  CustomText(address.regionName ?? '', ph: 8).start().footer(),
            ),
        ],
      ),
    );
    return ListTile(
      title: CustomText(address.name ?? ''),
      subtitle: CustomText(address.address ?? '').footer(),
    );
  }
}

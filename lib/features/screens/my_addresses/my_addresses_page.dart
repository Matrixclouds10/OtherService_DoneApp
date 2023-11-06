import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/data/models/address/address_item_model.dart';
import 'package:weltweit/features/domain/usecase/address/address_create_usecase.dart';
import 'package:weltweit/features/domain/usecase/address/address_delete_usecase.dart';
import 'package:weltweit/features/domain/usecase/address/address_update_usecase.dart';
import 'package:weltweit/features/screens/my_addresses/logic/address_cubit.dart';
import 'package:weltweit/features/widgets/app_bottomsheet.dart';
import 'package:weltweit/features/widgets/empty_widget.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

class MyAddressesPage extends StatefulWidget {
  const MyAddressesPage({super.key});

  @override
  State<MyAddressesPage> createState() => _MyAddressesPageState();
}

class _MyAddressesPageState extends State<MyAddressesPage> {
  @override
  void initState() {
    super.initState();
    context.read<AddressCubit>().getAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: servicesTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText(LocaleKeys.myAddresses.tr()).header(),
        isCenterTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              TextEditingController nameController = TextEditingController();
              TextEditingController addController = TextEditingController();
              AppBottomSheets().customBottomSheet(
                context: context,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomText(LocaleKeys.addNewAddress.tr()).header(),
                        // const SizedBox(height: 12),
                        // CustomText(LocaleKeys.addNewAddressDescription.tr()),
                        const SizedBox(height: 12),
                        CustomTextFieldNormal(
                          hint: LocaleKeys.name.tr(),
                          controller: nameController,
                        ),
                        const SizedBox(height: 12),
                        CustomTextFieldArea(
                          hint: LocaleKeys.address.tr(),
                          controller: addController,
                        ),
                        const SizedBox(height: 12),
                        BlocBuilder<AddressCubit, AddressState>(
                          builder: (context, state) {
                            return CustomButton(
                              title: LocaleKeys.add.tr(),
                              loading: state.createState == BaseState.loading,
                              onTap: () async {
                                AddressCreateParams params = AddressCreateParams(
                                  name: nameController.text,
                                  address: addController.text,
                                  lat: '0',
                                  lng: '0',
                                );
                                await context.read<AddressCubit>().createAddress(params);
                                if(mounted) {
                                  Navigator.pop(context);
                                }
                                if(mounted) {
                                  context.read<AddressCubit>().getAddresses();
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {
          if (state.baseState == BaseState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.baseState == BaseState.error) {
            return ErrorLayout(
              errorModel: state.errorModel,
              onRetry: () {
                context.read<AddressCubit>().getAddresses();
              },
            );
          }

          if (state.baseState == BaseState.loaded && state.addresses.isEmpty) {
            return EmptyView(
              message: LocaleKeys.noAddresses.tr(),
            );
          }
          if (state.baseState == BaseState.loaded) {
            return ListView.builder(
              itemCount: state.addresses.length,
              itemBuilder: (context, index) {
                return addressItemWidget(address: state.addresses[index]);
              },
            );
          }

          return Container(
            margin: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Colors.white).radius(radius: 12),
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
                                  Expanded(child: const CustomText("الرياض ", align: TextAlign.start).header()),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: servicesTheme.colorScheme.secondary,
                                    ),
                                    onPressed: () {},
                                  ),
                                  const SizedBox(width: 12),
                                ],
                              ),
                              const CustomText("ميدان سننية، ٨٦ شارع المعتزبالله، ٣٤٣٤٧٧"),
                              //make default address
                              Row(
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    value: i == 0,
                                    fillColor: MaterialStateProperty.all(servicesTheme.primaryColor),
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
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(address.name ?? '', ph: 12, pv: 0).start(),
                  if (address.address != null && address.address!.length > 1) CustomText(address.address ?? '', ph: 12, pv: 0).start().footer(),
                  if (address.regionName != null && address.regionName!.length > 1) CustomText(address.regionName ?? '', ph: 8).start().footer(),
                ],
              )),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: servicesTheme.colorScheme.secondary,
                ),
                onPressed: () {
                  TextEditingController nameController = TextEditingController();
                  TextEditingController addController = TextEditingController();
                  nameController.text = address.name ?? '';
                  addController.text = address.address ?? '';

                  AppBottomSheets().customBottomSheet(
                    context: context,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CustomText(LocaleKeys.editAddress.tr()).header(),
                            const SizedBox(height: 12),
                            CustomTextFieldNormal(
                              hint: LocaleKeys.name.tr(),
                              controller: nameController,
                            ),
                            const SizedBox(height: 12),
                            CustomTextFieldArea(
                              hint: LocaleKeys.address.tr(),
                              controller: addController,
                            ),
                            const SizedBox(height: 12),
                            CustomButton(
                              title: LocaleKeys.add.tr(),
                              onTap: () async {
                                AddressUpdateParams params = AddressUpdateParams(
                                  id: address.id!,
                                  name: nameController.text,
                                  address: addController.text,
                                  lat: '0',
                                  lng: '0',
                                );
                                Navigator.pop(context);
                                await context.read<AddressCubit>().updateAddress(params);
                                if (context.mounted) context.read<AddressCubit>().getAddresses();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: servicesTheme.colorScheme.error,
                ),
                onPressed: () async {
                  await context.read<AddressCubit>().deleteAddress(AddressDeleteParams(id: address.id.toString()));
                  if(mounted) {
                    await context.read<AddressCubit>().getAddresses();
                  }
                },
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                value: address.isDefault == 1,
                fillColor: MaterialStateProperty.all(Colors.orange),
                onChanged: (value) async {
                  {
                    if(mounted){
                  await context
                      .read<AddressCubit>()
                      .setAsDefault(address.id!);
                  }
                      if(context.mounted) {
                        await context.read<AddressCubit>().getAddresses();
                      }

                  }
                },
              ),
              CustomText("تعيين كعنوان افتراضي"),
            ],
          ),
        ],
      ),
    );
  }
}

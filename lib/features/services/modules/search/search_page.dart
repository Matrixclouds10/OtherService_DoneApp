import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/services/core/base/base_states.dart';
import 'package:weltweit/features/services/core/routing/routes.dart';
import 'package:weltweit/features/services/core/widgets/custom_text.dart';
import 'package:weltweit/features/services/core/widgets/service_provider_item.dart';
import 'package:weltweit/features/services/domain/usecase/provider/providers_usecase.dart';
import 'package:weltweit/features/services/logic/provider/providers_cubit.dart';
import 'package:weltweit/presentation/component/component.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: servicesTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 12),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    const SizedBox(width: 4),
                    Expanded(
                        child: CustomTextFieldSearch(
                      controller: _searchController,
                      onChange: (value) {},
                      onSubmit: (value) {
                        BlocProvider.of<ProvidersCubit>(context).getProviders(ProvidersParams(name: value));
                      },
                    )),
                    const SizedBox(width: 4),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                          icon: const Icon(Icons.close, color: Colors.black54),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          }),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ProvidersCubit, ProvidersState>(
              builder: (context, state) {
                if (state.searchState == BaseState.loading) {
                  return const Center(child: CustomLoadingSpinner());
                }
                if (state.searchState == BaseState.error) {
                  return Center(
                      child: ErrorLayout(
                    errorModel: state.error,
                  ));
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      ListAnimator(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        children: [
                          for (var i = 0; i < state.providers.length; i++)
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, RoutesServices.servicesProvider, arguments: {
                                  "provider": state.providers[i],
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(color: Colors.white).radius(radius: 12),
                                child: ServiceProviderItemWidget(
                                  providersModel: state.providers[i],
                                  canMakeAppointment: null,
                                  moreInfoButton: true,
                                  showFavoriteButton: false,
                                ),
                              ),
                            ),
                          const SizedBox(height: 30),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget singleCustomListTile({
    required String title,
    required String desc,
    required String date,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.grey, size: 40),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText(title, color: Colors.black, align: TextAlign.start, pv: 0),
                  CustomText(
                    date,
                    color: Colors.grey,
                    align: TextAlign.start,
                    pv: 0,
                    size: 12,
                  ),
                ],
              ),
              CustomText(desc, color: Colors.grey, align: TextAlign.start, pv: 0),
            ],
          )),
          const SizedBox(width: 12),
          Icon(Icons.arrow_forward_ios, color: servicesTheme.primaryColorLight, size: 24),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  getRandomDate() {
    int year = 2023;
    int month = Random().nextInt(12 - 1) + 1;
    int day = Random().nextInt(30 - 1) + 1;
    return "$day/$month/$year";
  }

  getRandomTitle() {
    List<String> titles = [
      "إشعار جديد",
      "عرض جديد",
      "تنبيه جديد",
    ];
    return titles[Random().nextInt(titles.length)];
  }

  getRandomText() {
    List<String> texts = ["هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة", "يوجد عرض جديد للعملاء الجدد", "تنبيه التطبيق يحتاج للتحديث", "تنبيه تم تغيير سعر الخدمة"];
    return texts[Random().nextInt(texts.length)];
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/routing/routes.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/core/widgets/service_provider_item.dart';
import 'package:weltweit/features/services/data/models/response/provider/providers_model.dart';
import 'package:weltweit/features/services/domain/usecase/provider/providers_usecase.dart';
import 'package:weltweit/features/services/logic/provider/providers_cubit.dart';
import 'package:weltweit/generated/assets.dart';
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
          //Seach Bar
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

          //Providers
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
                if (state.providers.isEmpty) {
                  return Center(child: CustomText("ابحث عن مزودي الخدمة", color: Colors.black));
                }
                return Column(
                  children: [
                
                    Expanded(
                      child: ListAnimator(
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
                                margin: EdgeInsets.symmetric(horizontal: 12),
                                child: ServiceProviderItemWidget(
                                  providersModel: state.providers[i],
                                  canMakeAppointment: null,
                                  moreInfoButton: false,
                                  showFavoriteButton: false,
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    // Expanded(
                    //   child: Container(
                    //     margin: EdgeInsets.symmetric(horizontal: 8),
                    //     width: double.infinity,
                    //     child: FutureBuilder<BitmapDescriptor>(
                    //       future: getMarkerAsLocation(),
                    //       builder: (context, snapshot) {
                    //         if (snapshot.hasData) {
                    //           return GoogleMap(
                    //             mapType: MapType.normal,
                    //             initialCameraPosition: CameraPosition(
                    //               target: LatLng(26.8206, 30.8025),
                    //               zoom: 14.0,
                    //             ),
                    //             markers: {
                    //               Marker(
                    //                 onTap: () {
                    //                   showBottomSheet(state.providers.first);
                    //                 },
                    //                 markerId: MarkerId('1_'),
                    //                 position: LatLng(26.8209, 30.8010),
                    //                 icon: snapshot.data!,
                    //               ),
                    //               Marker(
                    //                 onTap: () {
                    //                   showBottomSheet(state.providers.first);
                    //                 },
                    //                 markerId: MarkerId('2_'),
                    //                 position: LatLng(26.8210, 30.8030),
                    //                 icon: snapshot.data!,
                    //               ),
                    //               Marker(
                    //                 onTap: () {
                    //                   showBottomSheet(state.providers.first);
                    //                 },
                    //                 markerId: MarkerId('3_'),
                    //                 position: LatLng(26.825, 30.809),
                    //                 icon: snapshot.data!,
                    //               ),
                    //               Marker(
                    //                 onTap: () {
                    //                   showBottomSheet(state.providers.first);
                    //                 },
                    //                 markerId: MarkerId('4_'),
                    //                 position: LatLng(26.829, 30.809),
                    //                 icon: snapshot.data!,
                    //               ),
                    //             },
                    //             // state.driversLocation
                    //             //     .map((e) => Marker(
                    //             //           markerId: MarkerId('${Random().nextInt(100000)}'),
                    //             //           position: LatLng(e.latitude, e.longitude),
                    //             //           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                    //             //         ))
                    //             //     .toSet(),
                    //           );
                    //         }
                    //         return Center(
                    //           child: CircularProgressIndicator(),
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),
                
                  ],
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

  showBottomSheet(ProvidersModel providersModel) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            child: ServiceProviderItemWidget(
              providersModel: providersModel,
              canMakeAppointment: null,
              moreInfoButton: true,
              showFavoriteButton: false,
            ),
          ),
        ],
      ),
      enableDrag: false,
    );
  }

  Future<BitmapDescriptor> getMarkerAsLocation() async {
    BitmapDescriptor markerImage = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      Assets.imagesAvatar,
    );
    return markerImage;
  }
}

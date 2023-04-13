import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/routing/routes.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/core/widgets/service_item_widget.dart';
import 'package:weltweit/features/services/logic/service/services_cubit.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/custom_loading_spinner.dart';

class HomeServices extends StatelessWidget {
  const HomeServices({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        return Column(
          children: [
            if (state.state == BaseState.loading)
              SizedBox(
                width: 120,
                child: CustomLoadingSpinner(),
              ),
            if (state.state == BaseState.loaded && state.homeServices.isNotEmpty)
              Column(
                children: [
                  Row(
                    children: [
                      CustomText(LocaleKeys.services.tr(), color: Colors.black54).footer(),
                      Spacer(),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RoutesServices.servicesServices);
                          },
                          child: CustomText(LocaleKeys.showAll.tr(), color: Colors.grey).footerExtra()),
                    ],
                  ),
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1,
                    children: [
                      for (var i = 0; i < state.homeServices.length; i++)
                        ServiceItemWidget(
                          serviceModel: state.homeServices[i],
                          width: double.infinity,
                          grid: true,
                        ),
                    ],
                  ),
                ],
              )
          ],
        );
      },
    );
  }
}

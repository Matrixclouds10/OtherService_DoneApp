import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/core/utils/date/date_converter.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_response.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/data/models/subscription/subscription_history_model.dart';
import 'package:weltweit/features/data/models/subscription/subscription_model.dart';
import 'package:weltweit/features/logic/provider_subscription/subscription_cubit.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/features/widgets/empty_widget.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class SubscribtionHistoryPage extends StatefulWidget {
  const SubscribtionHistoryPage({super.key});

  @override
  State<SubscribtionHistoryPage> createState() => _SubscribtionHistoryPageState();
}

class _SubscribtionHistoryPageState extends State<SubscribtionHistoryPage> {
  @override
  void initState() {
    super.initState();
    SubscribtionCubit subscriptionCubit = context.read<SubscribtionCubit>();
    subscriptionCubit.getSubscribtionsHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText(LocaleKeys.subscribtionHistory.tr()).header(),
        isCenterTitle: true,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesBk2),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocBuilder<SubscribtionCubit, SubscribtionState>(
          builder: (context, state) {
            if (state.subscribtionHistoryState == BaseState.loading) return const Center(child: CircularProgressIndicator());
            if (state.subscribtionHistoryState == BaseState.error) {
              return ErrorLayout(
                  errorModel: ErrorModel(errorMessage: LocaleKeys.somethingWentWrong.tr()),
                  onRetry: () {
                    context.read<SubscribtionCubit>().getSubscribtionsHistory();
                  });
            }
            if (state.data.isEmpty) return const EmptyView(message: "No Subscribtions");
            return SingleChildScrollView(
              child: ListAnimator(
                children: [
                  SizedBox(height: 24),
                  ...state.subscribtionHistoryData.map((e) => _buildItem(e)).toList(),
                  SizedBox(height: 64),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _buildItem(SubscriptionHistoryModel e) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(color: Colors.white).radius(radius: 12),
      child: Column(
        children: [
          ListTile(title: Text(e.paymentMethod), leading: Icon(Icons.credit_card_outlined, color: Colors.grey), dense: true, contentPadding: EdgeInsets.zero),
          ListTile(title: Text(e.status), leading: Icon(Icons.check_circle_outline, color: Colors.grey), dense: true, contentPadding: EdgeInsets.zero),
          ListTile(title: Text("${DateConverter.estimatedDate(e.startsAt)}-${DateConverter.estimatedDate(e.endsAt)}"), leading: Icon(Icons.date_range_outlined, color: Colors.grey), dense: true, contentPadding: EdgeInsets.zero),
          Divider(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(e.subscription.name ?? "", color: primaryColor).headerExtra().start(),
                  CustomText("Period:${e.subscription.period}", color: Colors.grey[500]!, pv: 0).footer().start(),
                ],
              ).expanded(),
              CustomText("${e.subscription.price.toString()}\$", color: AppColorLight().kAccentColor).headerExtra(),
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
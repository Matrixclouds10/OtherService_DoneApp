import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/core/resources/color.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/routing/routes.dart';
import 'package:weltweit/core/utils/date/date_converter.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/logic/order/order_cubit.dart';
import 'package:weltweit/features/screens/provider_order_details/video_player.dart';
import 'package:weltweit/features/data/models/order/order.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class OrderDetails extends StatefulWidget {
  final OrderModel orderModel; // "completed" or "accepted" or "cancelled"
  const OrderDetails({required this.orderModel, super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final TextEditingController _amountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    OrderCubit orderCubit = context.read<OrderCubit>();
    orderCubit.getOrder(widget.orderModel.id);
  }

  @override
  Widget build(BuildContext context) {
    //get argument
    return Scaffold(
      appBar: CustomAppBar(
        color: Colors.white,
        titleWidget: CustomText(LocaleKeys.orderDetails.tr()).header(),
        isCenterTitle: true,
        actions: [
          //chat
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 8),
            iconSize: 22,
            constraints: BoxConstraints(),
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            icon: Icon(FontAwesomeIcons.message),
            onPressed: () {
              NavigationService.push(Routes.chatScreen, arguments: {'orderModel': widget.orderModel});
            },
          ),

          //more
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 8),
            iconSize: 22,
            constraints: BoxConstraints(),
            icon: Icon(FontAwesomeIcons.ellipsisVertical),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: AppColorLight().kScaffoldBackgroundColor,
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state.state == BaseState.loading) return const Center(child: CircularProgressIndicator());
          if (state.state == BaseState.error) {
            return ErrorLayout(
                errorModel: state.error,
                onRetry: () {
                  context.read<OrderCubit>().getOrder(widget.orderModel.id);
                });
          }
          if (state.data == null) return const Center(child: Text("No Data"));
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 8),
                // SizedBox(
                //   width: double.infinity,
                //   height: 180,
                //   child: DemoVideoPlayer(),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: ListAnimator(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: [
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.calendar, size: 16),
                          SizedBox(width: 4),
                          Directionality(textDirection: material.TextDirection.ltr, child: CustomText(DateConverter.formatDate(state.data!.date), pv: 0).footer()),
                          Spacer(),
                          if (state.data?.service?.title != null)
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(color: Color(0xff57A4C3), borderRadius: BorderRadius.circular(4)),
                              child: CustomText(state.data!.service!.title!, color: Colors.white, size: 14, ph: 8, pv: 0).footer(),
                            )
                        ],
                      ),
                      if (state.data!.file.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: _orderFiles(state.data!.file),
                        ),
                      if (state.data!.statusCode!.toLowerCase().contains("pending")) pendingView(state.data!),
                      if (state.data!.statusCode!.toLowerCase().contains("provider_cancel")) cacncelledView(state.data!),
                      if (state.data!.statusCode!.toLowerCase().contains("provider_finish")) finishedView(state.data!),
                      if (state.data!.statusCode!.toLowerCase().contains("provider_accept")) inProgressView(state.data!),
                      if (state.data!.statusCode!.toLowerCase().contains("client_done")) finishedView(state.data!),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget textWithDot({
    required String text,
    Color color = Colors.black54,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 5),
          Expanded(child: CustomText(text, color: color, align: TextAlign.start, size: 15)),
        ],
      ),
    );
  }

  pendingView(OrderModel orderModel) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(LocaleKeys.orderStatus.tr(), pv: 0).header(),
                  CustomText(LocaleKeys.waitingForYourResponse.tr(), pv: 0, color: AppColorLight().kAccentColor).footer(),
                ],
              ),
              Spacer(),
              Transform.rotate(angle: 0.4, child: Icon(Icons.timer, size: 32, color: Colors.grey[500])),
            ],
          ),
        ),
        // Row(
        //   children: [
        //     CustomText(
        //       LocaleKeys.totalCost.tr(),
        //       pv: 0,
        //       bold: true,
        //     ).header(),
        //   ],
        // ),
        // CustomTextFieldNumber(hint: LocaleKeys.primaryAmount.tr(), radius: 0),
        // Row(
        //   children: const [
        //     Spacer(),
        //     CustomText("إضافة مبلغ إضافي", pv: 0),
        //     SizedBox(width: 12),
        //     Icon(Icons.add, size: 30, color: primaryColor),
        //   ],
        // ),
        SizedBox(height: 12),
        Row(
          children: [
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: () async {
                actionCancelOrder(context, id: orderModel.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: CustomText(LocaleKeys.cancelOrder.tr(), color: Colors.white).headerExtra(),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                actionAcceptOrder(context, id: orderModel.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: CustomText(LocaleKeys.acceptOrder.tr(), color: Colors.white).headerExtra(),
            ),
            SizedBox(width: 16),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }

  cacncelledView(OrderModel orderModel) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(LocaleKeys.orderStatus.tr(), pv: 0).header(),
                  CustomText(LocaleKeys.canceled.tr(), pv: 0, color: Colors.red).footer(),
                ],
              ),
              Spacer(),
              Icon(Icons.close, size: 32, color: Colors.red[500]),
            ],
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  inProgressView(OrderModel orderModel) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(LocaleKeys.orderStatus.tr(), pv: 0).header(),
                  CustomText(LocaleKeys.inProgress.tr(), pv: 0, color: AppColorLight().kAccentColor).footer(),
                ],
              ),
              Spacer(),
              Transform.rotate(angle: 0.4, child: Icon(Icons.timer, size: 32, color: Colors.grey[500])),
            ],
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            CustomText(
              LocaleKeys.totalCost.tr(),
              pv: 0,
              bold: true,
            ).header(),
          ],
        ),
        CustomTextFieldNumber(
          hint: LocaleKeys.primaryAmount.tr(),
          radius: 0,
          controller: _amountController,
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 16),
            // ElevatedButton(
            //   onPressed: () async {
            //     actionCancelOrder(context, id: orderModel.id);
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.red,
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   ),
            //   child: CustomText(LocaleKeys.cancelOrder.tr(), color: Colors.white).headerExtra(),
            // ),
            // Spacer(),
            BlocBuilder<OrderCubit, OrderState>(
              builder: (context, state) {
                if (state.finishState == BaseState.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  onPressed: () async {
                    if (_amountController.text.isEmpty) {
                      AppSnackbar.show(context: context, message: LocaleKeys.enterAmount.tr());
                      return;
                    }
                    actionFinishOrder(context, id: orderModel.id, amount: _amountController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: CustomText(LocaleKeys.finishOrder.tr(), color: Colors.white).headerExtra(),
                );
              },
            ),
            SizedBox(width: 16),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }

  finishedView(OrderModel orderModel) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(LocaleKeys.orderStatus.tr(), pv: 0).header(),
                  CustomText(LocaleKeys.finished.tr(), pv: 0, color: Colors.green).footer(),
                ],
              ),
              Spacer(),
              Icon(Icons.check, size: 32, color: Colors.green[500]),
            ],
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  void actionCancelOrder(BuildContext context, {required int id}) async {
    String cancelReason = "";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: CustomText(LocaleKeys.cancelOrder.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFieldArea(
                onChange: (value) => cancelReason = value,
                hint: LocaleKeys.cancelReason.tr(),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton(
                      onPressed: () async {
                        if (cancelReason.isEmpty) {
                          AppSnackbar.show(context: context, message: LocaleKeys.reasonRequired.tr());
                          return;
                        }
                        if (context.mounted) {
                          bool result = await context.read<OrderCubit>().cancelOrder(id: id, reason: cancelReason);
                          if (result) {
                            if (context.mounted) Navigator.pop(context);
                            if (context.mounted) Navigator.pop(context);
                            if (context.mounted) AppSnackbar.show(context: context, message: LocaleKeys.successfullyCanceledOrder.tr());
                          }
                        }
                      },
                      child: CustomText(LocaleKeys.cancelOrder.tr(), color: Colors.red).headerExtra()),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: CustomText(LocaleKeys.cancel.tr(), color: Colors.black).headerExtra()),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void actionAcceptOrder(BuildContext context, {required int id}) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: CustomText(LocaleKeys.acceptOrder.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton(
                      onPressed: () async {
                        if (context.mounted) {
                          bool result = await context.read<OrderCubit>().acceptOrder(id: id);
                          if (result) {
                            if (context.mounted) Navigator.pop(context);
                            if (context.mounted) Navigator.pop(context);
                            if (context.mounted) AppSnackbar.show(context: context, message: LocaleKeys.successfullyAcceptOrder.tr());
                          }
                        }
                      },
                      child: CustomText(LocaleKeys.acceptOrder.tr(), color: Colors.green).headerExtra()),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: CustomText(LocaleKeys.cancel.tr(), color: Colors.black).headerExtra()),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void actionFinishOrder(BuildContext context, {required int id, required String amount}) async {
    bool result = await context.read<OrderCubit>().finishOrder(id: id, price: amount);
    if (result) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) AppSnackbar.show(context: context, message: LocaleKeys.successfullyFinishOrder.tr());
    }
  }

  _orderFiles(List<String> file) {
    List<String> images = [];
    List<String> videos = [];
    List<String> other = [];
    for (var element in file) {
      if (isFileImage(element)) {
        images.add(element);
      } else if (isFileVideo(element)) {
        videos.add(element);
      } else {
        other.add(element);
      }
    }
    VideoPlayerController? videoPlayerController;
    if (videos.isNotEmpty) {
      videoPlayerController = VideoPlayerController.network(videos.first);
      videoPlayerController.initialize();
    }
    return Column(
      children: [
        if (videos.isNotEmpty && videoPlayerController != null) _buildVideo(videoPlayerController),
        _buildImages(images),
        if (other.isNotEmpty) _buildOther(other),
      ],
    );
  }

  _buildVideo(VideoPlayerController videoPlayerController) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            videoPlayerController.value.isPlaying ? videoPlayerController.pause() : videoPlayerController.play();
            setState(() {});
          },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4),
            height: 160,
            width: deviceWidth - 8,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: VideoPlayer(
                videoPlayerController,
              ),
            ),
          ),
        ),
        if (!videoPlayerController.value.isPlaying)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                videoPlayerController.value.isPlaying ? videoPlayerController.pause() : videoPlayerController.play();
                setState(() {});
              },
              child: Icon(Icons.play_arrow, color: Colors.white, size: 50),
            ),
          ),
      ],
    );
  }

  bool isFileImage(String path) {
    if (path.contains(".jpg") || path.contains(".png") || path.contains(".jpeg")) return true;
    return false;
  }

  bool isFileVideo(String path) {
    if (path.contains(".mp4") || path.contains(".avi") || path.contains(".mov")) return true;
    return false;
  }

  _buildImages(List<String> images) {
    if (images.isEmpty) return Container();

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: FullScreenWidget(
                      disposeLevel: DisposeLevel.Low,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(images[index], fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CustomImage(height: 110, imageUrl: images[index], width: 110),
              ),
            ),
          );
        },
      ),
    );
  }

  _buildOther(List<String> other) {
    return Column(
      children: [
        ...other
            .map((e) => GestureDetector(
                  onTap: () {
                    Uri _url = Uri.parse(e);
                    launchUrl(_url);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.attach_file, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(child: CustomText(e, color: Colors.blueAccent, maxLines: 1)),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }
}

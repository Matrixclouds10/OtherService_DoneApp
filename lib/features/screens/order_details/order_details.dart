import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/routing/routes.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/core/widgets/order_item_widget.dart';
import 'package:weltweit/features/logic/order/order_cubit.dart';
import 'package:weltweit/features/data/models/order/order.dart';
import 'package:weltweit/features/logic/orders/orders_cubit.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

class OrderDetails extends StatefulWidget {
  final OrderModel orderModel;
  const OrderDetails({required this.orderModel, super.key});
  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> with SingleTickerProviderStateMixin {
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
            padding: EdgeInsets.symmetric(horizontal: 4),
            iconSize: 22,
            constraints: BoxConstraints(),
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            icon: Icon(FontAwesomeIcons.message),
            onPressed: () {
              NavigationService.push(Routes.chatScreen, arguments: {
                'orderModel': widget.orderModel,
              });
            },
          ),
        ],
      ),
      backgroundColor: servicesTheme.scaffoldBackgroundColor,
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
          String orderStatus = state.data?.statusCode ?? "";
          if (state.data == null) return const Center(child: CircularProgressIndicator());
          return SingleChildScrollView(
            child: Column(
              children: [
                ListAnimator(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: [
                    const SizedBox(height: 0),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: OrderItemWidget(
                        orderModel: state.data!,
                      ),
                    ),
                    if (state.data!.file.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: _orderFiles(state.data!.file),
                      ),
                    if (orderStatus.toLowerCase().contains("pending")) ...[
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                const CustomText("حالة الطلب", bold: true).headerExtra(),
                                const Spacer(),
                                // CustomText("300 ج", color: Color.fromARGB(255, 230, 35, 35), bold: true).headerExtra(),
                                // Chip(
                                //   label: const CustomText("Pending", color: Colors.white).header(),
                                //   backgroundColor: const Color(0xffE67E23),
                                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                // ),
                                const SizedBox(width: 10),
                              ],
                            ),
                            textWithDot(text: "تم إنشاء الطلب بنجاح وبإنتظار موافقة مزود الخدمة.", color: const Color(0xffE67E23)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () async {
                                String cancelReason = "";
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const CustomText("إلغاء الطلب"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextFieldArea(
                                            onChange: (value) => cancelReason = value,
                                            hint: "سبب الإلغاء",
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              TextButton(
                                                  onPressed: () async {
                                                    if (cancelReason.isEmpty) {
                                                      AppSnackbar.show(context: context, message: "السبب مطوب");
                                                      return;
                                                    }
                                                    if (context.mounted) {
                                                      bool result = await context.read<OrderCubit>().cancelOrder(id: state.data!.id, reason: cancelReason);
                                                      if (result) {
                                                        if (context.mounted) Navigator.pop(context);
                                                        if (context.mounted) Navigator.pop(context);
                                                        if (context.mounted) AppSnackbar.show(context: context, message: "تم إلغاء الطلب بنجاح");
                                                      }
                                                    }
                                                  },
                                                  child: const CustomText("إلغاء الطلب", color: Colors.red).headerExtra()),
                                              const Spacer(),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const CustomText("إلغاء", color: Colors.black).headerExtra()),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const CustomText("إلغاء الطلب", color: Colors.white).headerExtra(),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                    if (orderStatus.toLowerCase().contains("cancel")) ...[
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                const CustomText("حالة الطلب", bold: true).headerExtra(),
                                const Spacer(),
                                // const CustomText("300 ج", color: Color(0xffE67E23), bold: true).headerExtra(),
                                // Chip(
                                //   label: CustomText("مكتمل", color: Colors.white).header(),
                                //   backgroundColor: Color(0xffE67E23),
                                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                // ),
                                const SizedBox(width: 10),
                              ],
                            ),
                            textWithDot(text: "تم إنشاء الطلب بنجاح وبإنتظار موافقة مزود الخدمة.", color: const Color(0xffE67E23)),
                            textWithDot(text: "تم إلغاء الطلب من قبل طالب الخدمة.", color: Colors.red),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: CustomButton(
                                onTap: () {
                                  NavigationService.goBack();
                                },
                                title: "عودة",
                                fontSize: 18,
                                color: const Color(0xffE67E23),
                                textColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                    if (orderStatus.contains("completed")) ...[
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                const CustomText("حالة الطلب", bold: true).headerExtra(),
                                const Spacer(),
                                // CustomText("300 ج", color: Color.fromARGB(255, 230, 35, 35), bold: true).headerExtra(),
                                Chip(
                                  label: const CustomText("مكتمل", color: Colors.white).header(),
                                  backgroundColor: const Color(0xffE67E23),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                            textWithDot(text: "تم إنشاء الطلب بنجاح وبإنتظار موافقة مزود الخدمة.", color: const Color(0xffE67E23)),
                            textWithDot(text: "وافق مزود الخدمة علي طلبك وبإنتظار ردك بالموافقة علي السعر الأساسي.", color: servicesTheme.colorScheme.secondary),
                            textWithDot(text: "تم التأكيد والطلب قيد التنفيذ.", color: Colors.black),
                            textWithDot(text: "تم الإنتهاء من الطلب من مزود الخدمة وبإنتظار تأكيدك.", color: Colors.black),
                            textWithDot(text: "تم الانتهاء من الطلب.", color: Colors.black),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                CustomText("إجمالى البلغ", bold: true, color: servicesTheme.colorScheme.secondary).headerExtra(),
                                const Spacer(),
                                CustomText("300 ج", color: servicesTheme.colorScheme.secondary, bold: true).headerExtra(),
                                const SizedBox(width: 10),
                              ],
                            ),
                            const Divider(height: 2),
                            ...["المبلغ الأساسي", "إضافات مادية ١", "إضافات مادية 2"].map((e) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: textWithDot(text: e, color: e.contains("المبلغ") ? const Color(0xffE67E23) : Colors.black),
                                  ),
                                  const SizedBox(width: 10),
                                  Chip(
                                    label: const CustomText("300 ج", color: Colors.white).footer(),
                                    backgroundColor: e.contains("المبلغ") ? const Color(0xffE67E23) : Colors.black,
                                    padding: const EdgeInsets.all(2),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              );
                            }).toList(),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: CustomButton(
                                onTap: () {},
                                title: "الدفع",
                                fontSize: 18,
                                color: Colors.black,
                                textColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                    if (orderStatus.contains("pending")) ...[],
                    if (orderStatus.contains("provider_finish")) ...[
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                const CustomText("حالة الطلب", bold: true).headerExtra(),
                                const Spacer(),
                                // CustomText("300 ج", color: Color.fromARGB(255, 230, 35, 35), bold: true).headerExtra(),
                                Chip(
                                  label: const CustomText("مكتمل", color: Colors.white).header(),
                                  backgroundColor: const Color(0xffE67E23),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                            textWithDot(text: "تم إنشاء الطلب بنجاح وبإنتظار موافقة مزود الخدمة.", color: const Color(0xffE67E23)),
                            textWithDot(text: "وافق مزود الخدمة علي طلبك وبإنتظار ردك بالموافقة علي السعر الأساسي.", color: servicesTheme.colorScheme.secondary),
                            textWithDot(text: "تم التأكيد والطلب قيد التنفيذ.", color: Colors.black),
                            textWithDot(text: "تم الإنتهاء من الطلب من مزود الخدمة وبإنتظار موافقتك.", color: Colors.black),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                CustomText("إجمالى البلغ", bold: true, color: servicesTheme.colorScheme.secondary).headerExtra(),
                                const Spacer(),
                                CustomText("${state.data!.price} ج", color: servicesTheme.colorScheme.secondary, bold: true).headerExtra(),
                                const SizedBox(width: 10),
                              ],
                            ),
                            const Divider(height: 2),
                            // ...["المبلغ الأساسي", "إضافات مادية ١", "إضافات مادية 2"].map((e) {
                            //   return Row(
                            //     children: [
                            //       Expanded(
                            //         child: textWithDot(text: e, color: e.contains("المبلغ") ? const Color(0xffE67E23) : Colors.black),
                            //       ),
                            //       const SizedBox(width: 10),
                            //       Chip(
                            //         label: const CustomText("300 ج", color: Colors.white).footer(),
                            //         backgroundColor: e.contains("المبلغ") ? const Color(0xffE67E23) : Colors.black,
                            //         padding: const EdgeInsets.all(2),
                            //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            //       ),
                            //       const SizedBox(width: 10),
                            //     ],
                            //   );
                            // }).toList(),
                            const SizedBox(height: 10),

                            BlocBuilder<OrderCubit, OrderState>(
                              builder: (context, state) {
                                if (state.finishState == BaseState.loading) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                return ElevatedButton(
                                  onPressed: () async {
                                    actionDoneOrder(context, id: state.data!.id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  ),
                                  child: CustomText(LocaleKeys.finishOrder.tr(), color: Colors.white).headerExtra(),
                                );
                              },
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],

                    //   Container(
                    //   decoration: const BoxDecoration(color: Colors.white),
                    //   child: Column(
                    //     children: [
                    //       const SizedBox(height: 10),
                    //       Row(
                    //         children: [
                    //           const SizedBox(width: 10),
                    //           const CustomText("حالة الطلب", bold: true).headerExtra(),
                    //           const Spacer(),
                    //           // const CustomText("300 ج", color: Color(0xffE67E23), bold: true).headerExtra(),
                    //           // Chip(
                    //           //   label: CustomText("مكتمل", color: Colors.white).header(),
                    //           //   backgroundColor: Color(0xffE67E23),
                    //           //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    //           // ),
                    //           const SizedBox(width: 10),
                    //         ],
                    //       ),
                    //       textWithDot(text: "تم إنشاء الطلب بنجاح وبإنتظار موافقة مزود الخدمة.", color: const Color(0xffE67E23)),
                    //       textWithDot(text: "وافق مزود الخدمة علي طلبك وبإنتظار ردك بالموافقة علي السعر الأساسي.", color: servicesTheme.colorScheme.secondary),
                    //       const SizedBox(height: 10),
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 12),
                    //         child: CustomButton(
                    //           onTap: () {
                    //             NavigationService.goBack();
                    //           },
                    //           title: LocaleKeys.back.tr(),
                    //           fontSize: 18,
                    //           color: const Color(0xffE67E23),
                    //           textColor: Colors.white,
                    //         ),
                    //       ),
                    //       const SizedBox(height: 16),
                    //     ],
                    //   ),
                    // ),

                    const SizedBox(height: 30),
                  ],
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
          const SizedBox(width: 5),
          Expanded(child: CustomText(text, color: color, align: TextAlign.start, size: 15)),
        ],
      ),
    );
  }

  void actionDoneOrder(BuildContext context, {required int id}) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: CustomText(LocaleKeys.finishOrder.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton(
                      onPressed: () async {
                        if (context.mounted) {
                          if (context.mounted) Navigator.pop(context);
                          bool result = await context.read<OrderCubit>().finishOrder(id: id, price: null);
                          if (context.mounted) Navigator.pop(context);
                          if (context.mounted) context.read<OrdersCubit>().getPendingOrders(typeIsProvider: false);
                          if (result) {
                            if (context.mounted) AppSnackbar.show(context: context, message: LocaleKeys.successfullyFinishOrder.tr());
                          }
                        }
                      },
                      child: CustomText(LocaleKeys.finishOrder.tr(), color: Colors.orange[700]!).headerExtra()),
                  const Spacer(),
                  TextButton(
                      onPressed: () async {
                        if (context.mounted) Navigator.pop(context);
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

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/routing/routes.dart';
import 'package:weltweit/domain/logger.dart';
import 'package:weltweit/features/services/core/base/base_states.dart';
import 'package:weltweit/features/services/core/routing/routes.dart';
import 'package:weltweit/features/services/core/widgets/custom_text.dart';
import 'package:weltweit/features/services/data/models/response/provider/providers_model.dart';
import 'package:weltweit/features/services/data/models/response/services/service.dart';
import 'package:weltweit/features/services/domain/usecase/create_order/create_order_usecase.dart';
import 'package:weltweit/features/services/logic/create_order/create_order_cubit.dart';
import 'package:weltweit/features/services/widgets/app_snackbar.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/presentation/component/inputs/base_form.dart';
import 'package:video_player/video_player.dart';

class ReservationPage extends StatefulWidget {
  final ProvidersModel providersModel;
  const ReservationPage({required this.providersModel, super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  VideoPlayerController? videoPlayerController;
  List<File> images = [];
  File? video;
  bool reservationTimeNow = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  ServiceModel? selectedService;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: servicesTheme.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          isCenterTitle: true,
          color: Colors.white,
          titleWidget: const CustomText("حجز موعد").header(),
        ),
        body: BlocConsumer<CreateOrderCubit, CreateOrderState>(
          listener: (context, state) {
            if (state.state == BaseState.loaded) {
              //back to home
              Navigator.popUntil(context, (route) => route.isFirst);

              NavigationService.push(RoutesServices.servicesOrderDetails, arguments: {"orderModel": state.data});

              AppSnackbar.show(context: context, message: "تم إرسال طلبك بنجاح");
            }
            if (state.state == BaseState.error) {
              AppSnackbar.show(
                context: context,
                message: state.error?.errorMessage ?? "حدث خطأ ما",
                type: SnackbarType.error,
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildVideo(),
                  _buildImages(),
                  const SizedBox(height: 12),
                  Container(
                    decoration: const BoxDecoration(color: Colors.transparent).radius(radius: 12),
                    child: CustomTextField(
                      hint: "حمل صورة أو فيديو بالمشكلة",
                      prefixIcon: Icons.camera_alt,
                      enable: false,
                      radius: 4,
                      noBorder: true,
                      prefixIconColor: Colors.grey,
                      background: Colors.white,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 150,
                              color: Colors.red,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                ),
                                height: 25,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          PickedFile? pickedFile = await (ImagePicker().getImage(source: ImageSource.camera, imageQuality: 25));

                                          if (pickedFile != null) {
                                            List<File> files = images ;
                                            File file = File(pickedFile.path);
                                            if (files.length >= 5) {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('لا يمكن إضافة أكثر من 5 صور')));
                                              return;
                                            } else {
                                              files.add(file);
                                            }
                                            images = files;
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: Colors.grey),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.camera_alt, color: Colors.grey[500]),
                                              const SizedBox(width: 8),
                                              Expanded(child: CustomText("Camera", color: Colors.grey[500]!)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          List<PickedFile>? pickedFile = await (ImagePicker().getMultiImage(imageQuality: 35));

                                          if (pickedFile != null && pickedFile.isNotEmpty) {
                                            List<File> files = images ;
                                            for (var element in pickedFile) {
                                              File file = File(element.path);
                                              if (files.length >= 5) {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('لا يمكن إضافة أكثر من 5 صور')));
                                                continue;
                                              } else {
                                                files.add(file);
                                              }
                                            }
                                            //remove dublicates
                                            files = files.toSet().toList();

                                            images = files;
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: Colors.grey),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.image, color: Colors.grey[500]),
                                              const SizedBox(width: 8),
                                              Expanded(child: CustomText("Gallery", color: Colors.grey[500]!)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          PickedFile? pickedFile = await (ImagePicker().getVideo(source: ImageSource.gallery));

                                          if (pickedFile != null) {
                                            video = File(pickedFile.path);
                                            // videoPlayerController = VideoPlayerController.file(video!);
                                            // try {
                                            //   videoPlayerController!.initialize();
                                            // } catch (e) {
                                            //   logger.e(e);
                                            // }
                                            // setState(() {});
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: Colors.grey),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.image, color: Colors.grey[500]),
                                              const SizedBox(width: 8),
                                              Expanded(child: CustomText("Video", color: Colors.grey[500]!)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const CustomText("متي تحتاج هذه الخدمة؟").header(),
                  //Two radio buttons
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: RadioListTile(
                          value: false,
                          groupValue: reservationTimeNow,
                          title: const CustomText("حسب الوقت المحدد", align: TextAlign.start),
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              reservationTimeNow = value as bool;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: RadioListTile(
                          value: true,
                          groupValue: reservationTimeNow,
                          contentPadding: EdgeInsets.zero,
                          title: const CustomText("فورا", align: TextAlign.start),
                          onChanged: (value) {
                            setState(() {
                              reservationTimeNow = value as bool;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (reservationTimeNow == false)
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomTextField(
                            hint: selectedDate == null ? "التاريخ" : DateFormat('yyyy-MM-dd').format(selectedDate!),
                            prefixIcon: Icons.calendar_today,
                            enable: false,
                            radius: 4,
                            noBorder: true,
                            prefixIconColor: Colors.grey,
                            background: Colors.white,
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 1),
                              );
                              if (picked != null) {
                                selectedDate = picked;
                                setState(() {});
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: CustomTextField(
                            hint: selectedTime == null ? "الوقت" : selectedTime!.format(context),
                            prefixIcon: Icons.access_time,
                            enable: false,
                            radius: 4,
                            noBorder: true,
                            prefixIconColor: Colors.grey,
                            background: Colors.white,
                            onTap: () async {
                              TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                selectedTime = picked;
                                setState(() {});
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 300,
                            child: StatefulBuilder(builder: (context, setState2) {
                              return ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                itemCount: widget.providersModel.services?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return RadioListTile(
                                    value: widget.providersModel.services?[index],
                                    groupValue: selectedService,
                                    title: CustomText(widget.providersModel.services?[index].title ?? ''),
                                    onChanged: (value) {
                                      selectedService = value as ServiceModel;
                                      setState2(() {});
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );
                            }),
                          );
                        },
                      );
                    },
                    child: CustomTextField(
                      hint: selectedService == null ? "اختر الخدمة" : selectedService!.title,
                      prefixIcon: Icons.handyman,
                      enable: false,
                      radius: 4,
                      noBorder: true,
                      prefixIconColor: Colors.grey,
                      background: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    title: "تأكيد الطلب",
                    loading: state.state == BaseState.loading,
                    color: Colors.black,
                    onTap: () => state.state != BaseState.loading ? _submit(context) : null,
                  ),
                ],
              ),
            );
          },
        ));
  }

  _buildImages() {
    if (images.isEmpty) return Container();

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          //check if file is image or video

          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CustomImage(
                    height: 80,
                    imageUrl: images[index].path,
                    width: 80,
                  ),
                ),
              ),
              //remove image
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    images.removeAt(index);
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(250),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _buildVideo() {
    if (video == null) return Text("No video");
    if (videoPlayerController == null) return Text("No video");
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            videoPlayerController!.value.isPlaying ? videoPlayerController!.pause() : videoPlayerController!.play();
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            height: 160,
            width: deviceWidth / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: VideoPlayer(
                videoPlayerController!,
              ),
            ),
          ),
        ),
        //remove video
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              video = null;
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(250),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: const Icon(
                Icons.close,
                color: Colors.red,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildFile(File? pdf) {
    if (pdf == null) {
      return Icon(Icons.picture_as_pdf, color: Colors.grey[500], size: 40);
    } else {
      return SizedBox(
        height: 40,
        child: Center(
          child: CustomText(
            pdf.path.split('/').last,
            size: 12,
            color: Colors.grey[500]!,
          ),
        ),
      );
    }
  }

  _submit(BuildContext context) async {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String time = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}:00";

    if (!reservationTimeNow && selectedDate == null && selectedTime == null) {
      AppSnackbar.show(context: context, message: "اختر التاريخ والوقت");
      return;
    }
    if (selectedDate != null && selectedTime != null) {
      date = DateFormat('yyyy-MM-dd').format(selectedDate!);
      time = "${selectedTime!.hour}:${selectedTime!.minute}:00";
    }
    if (selectedService == null) {
      AppSnackbar.show(context: context, message: "اختر الخدمة");
      return;
    }

    await context.read<CreateOrderCubit>().createOrder(CreateOrderParams(
          date: "$date $time",
          file: images.isNotEmpty ? images[0] : null,
          serviceId: selectedService!.id!,
          providerId: widget.providersModel.id!,
        ));
  }
}

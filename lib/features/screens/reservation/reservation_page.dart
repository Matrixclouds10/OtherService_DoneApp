import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/data/models/provider/providers_model.dart';
import 'package:weltweit/features/data/models/services/service.dart';
import 'package:weltweit/features/domain/usecase/create_order/create_order_usecase.dart';
import 'package:weltweit/features/logic/create_order/create_order_cubit.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/presentation/component/inputs/base_form.dart';

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
          titleWidget: CustomText(LocaleKeys.reservation.tr()).header(),
        ),
        body: BlocConsumer<CreateOrderCubit, CreateOrderState>(
          listener: (context, state) {
            if (state.state == BaseState.loaded) {
              Navigator.popUntil(context, (route) => route.isFirst);
              NavigationService.push(RoutesServices.servicesOrderDetails, arguments: {"orderModel": state.data});
              AppSnackbar.show(context: context, message: LocaleKeys.successfullySendOrder.tr());
            }
            if (state.state == BaseState.error) {
              AppSnackbar.show(
                context: context,
                message: state.error?.errorMessage ?? LocaleKeys.somethingWentWrong.tr(),
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
                      hint: LocaleKeys.deployImageOrVideoIssue.tr(),
                      prefixIcon: Icons.camera_alt,
                      enable: false,
                      radius: 4,
                      noBorder: true,
                      prefixIconColor: Colors.grey,
                      background: Colors.white,
                      onTap: () {
                        if (state.state == BaseState.loading) return;
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 150,
                              color: Colors.red,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                ),
                                height: 25,
                                child: Column(
                                  children: [
                                   FittedBox(
                                     child:  Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                       children: [
                                         SizedBox(width: 5),
                                         ElevatedButton.icon(
                                           onPressed: _actionCamera,
                                           icon: Icon(Icons.camera_alt),
                                           label: CustomText(LocaleKeys.camera.tr()),
                                         ),
                                         SizedBox(width: 3),

                                         ElevatedButton.icon(
                                           onPressed: _actionGallery,
                                           icon: Icon(Icons.image, color: Colors.blue.shade400),
                                           style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100),
                                           label: CustomText(LocaleKeys.gallery.tr()),
                                         ),
                                         SizedBox(width: 3),

                                         ElevatedButton.icon(
                                           onPressed: _actionVideo,
                                           icon: Icon(Icons.video_camera_back_rounded, color: Colors.green.shade400),
                                           style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade100),
                                           label: CustomText(LocaleKeys.video.tr()),
                                         ),
                                         SizedBox(width: 5),

                                       ],
                                     ),
                                   )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  CustomText(LocaleKeys.whenDoYouNeedThisService.tr()).header(),
                  //Two radio buttons
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: RadioListTile(
                          value: false,
                          groupValue: reservationTimeNow,
                          title: CustomText(LocaleKeys.accordingToSpecifiedTime.tr(), align: TextAlign.start),
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            if (state.state == BaseState.loading) return;
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
                          title: CustomText(LocaleKeys.rightNow.tr(), align: TextAlign.start),
                          onChanged: (value) {
                            if (state.state == BaseState.loading) return;
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
                            hint: selectedDate == null ? LocaleKeys.date.tr() : DateFormat('yyyy-MM-dd').format(selectedDate!),
                            prefixIcon: Icons.calendar_today,
                            enable: false,
                            radius: 4,
                            noBorder: true,
                            prefixIconColor: Colors.grey,
                            background: Colors.white,
                            onTap: () async {
                              if (state.state == BaseState.loading) return;
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
                            hint: selectedTime == null ? LocaleKeys.time.tr() : selectedTime!.format(context),
                            prefixIcon: Icons.access_time,
                            enable: false,
                            radius: 4,
                            noBorder: true,
                            prefixIconColor: Colors.grey,
                            background: Colors.white,
                            onTap: () async {
                              if (state.state == BaseState.loading) return;
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
                  // const SizedBox(height: 12),
                  // GestureDetector(
                  //   onTap: () {
                  //     // if (state.state == BaseState.loading) return;
                  //     // showModalBottomSheet(
                  //     //   context: context,
                  //     //   builder: (context) {
                  //     //     return SizedBox(
                  //     //       height: 300,
                  //     //       child: StatefulBuilder(builder: (context, setState2) {
                  //     //         return ListView.builder(
                  //     //           padding: EdgeInsets.symmetric(vertical: 8),
                  //     //           itemCount: widget.providersModel.services?.length ?? 0,
                  //     //           itemBuilder: (context, index) {
                  //     //             return RadioListTile(
                  //     //               value: widget.providersModel.services?[index],
                  //     //               groupValue: selectedService,
                  //     //               title: CustomText(widget.providersModel.services?[index].title ?? ''),
                  //     //               onChanged: (value) {
                  //     //                 selectedService = value as ServiceModel;
                  //     //                 setState2(() {});
                  //     //                 setState(() {});
                  //     //                 Navigator.pop(context);
                  //     //               },
                  //     //             );
                  //     //           },
                  //     //         );
                  //     //       }),
                  //     //     );
                  //     //   },
                  //     // );
                  //   },
                  //   child: CustomTextField(
                  //     hint: selectedService == null ? LocaleKeys.selectService.tr() : widget.providersModel.services?[0].title??'',
                  //     prefixIcon: Icons.handyman,
                  //     enable: false,
                  //     radius: 4,
                  //     noBorder: true,
                  //     prefixIconColor: Colors.grey,
                  //     background: Colors.white,
                  //   ),
                  // ),
                  const SizedBox(height: 24),

                  if (kDebugMode)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
                        title: "Reset",
                        color: Colors.black,
                        onTap: () async {
                           context.read<CreateOrderCubit>().initStates();
                        },
                      ),
                    ),

                  CustomButton(
                    title: LocaleKeys.confirmOrder.tr(),
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
    if (video == null) return Container();
    if (videoPlayerController == null) return Container();
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
    List<File> files = images.toList();
    if (video != null) {
      files.add(video!);
    }
    selectedService =widget.providersModel.services?[0];
    // if(files.isEmpty){
    //   AppSnackbar.show(context: context, message: LocaleKeys.pleaseAddImageOrVideo.tr());
    //   return;
    // }

    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String time = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}:00";

    if (!reservationTimeNow && selectedDate == null && selectedTime == null) {
      AppSnackbar.show(context: context, message: LocaleKeys.selectDateAndTime.tr());
      return;
    }
    if (selectedDate != null && selectedTime != null) {
      date = DateFormat('yyyy-MM-dd').format(selectedDate!);
      time = "${selectedTime!.hour}:${selectedTime!.minute}:00";
    }
    if (selectedService == null) {
      AppSnackbar.show(context: context, message: LocaleKeys.selectService.tr());
      return;
    }

    await context.read<CreateOrderCubit>().createOrder(CreateOrderParams(
          date: "$date $time",
          files: files,
          serviceId: selectedService!.id!,
          providerId: widget.providersModel.id!,
        ));
  }

  void _actionCamera() async {
    Navigator.pop(context);
    PickedFile? pickedFile = await (ImagePicker().getImage(source: ImageSource.camera, imageQuality: 25));

    if (pickedFile != null) {
      List<File> files = images;
      File file = File(pickedFile.path);
      if (files.length >= 5) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(LocaleKeys.cantAddMoreThan5Images.tr())));
        return;
      } else {
        files.add(file);
      }
      images = files;
    }
    setState(() {});
  }

  void _actionGallery() async {
    Navigator.pop(context);
    List<PickedFile>? pickedFile = await (ImagePicker().getMultiImage(imageQuality: 35));

    if (pickedFile != null && pickedFile.isNotEmpty) {
      List<File> files = images;
      for (var element in pickedFile) {
        File file = File(element.path);
        if (files.length >= 5) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(LocaleKeys.cantAddMoreThan5Images.tr())));
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
  }

  void _actionVideo() async {
    Navigator.pop(context);
    PickedFile? pickedFile = await (ImagePicker().getVideo(source: ImageSource.gallery));

    if (pickedFile != null) {
      video = File(pickedFile.path);
      videoPlayerController = VideoPlayerController.file(video!);
      try {
        videoPlayerController!.initialize();
      } catch (e) {
        logger.e(e);
      }
      setState(() {});
    }
  }
}

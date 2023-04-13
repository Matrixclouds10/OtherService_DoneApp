import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/features/core/routing/routes.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/presentation/component/inputs/base_form.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  List<File> images = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorLight().kScaffoldBackgroundColor,
        appBar: CustomAppBar(
          isCenterTitle: true,
          color: Colors.white,
          titleWidget: CustomText("حجز موعد").header(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              // if (images.isNotEmpty) _buildImages(images),
              SizedBox(height: 12),
              Container(
                decoration:
                    BoxDecoration(color: Colors.transparent).radius(radius: 12),
                child: CustomTextField(
                  hint: "حمل صورة أو فيديو بالمشكلة",
                  prefixIcon: Icons.camera_alt,
                  enable: false,
                  radius: 4,
                  noBorder: true,
                  prefixIconColor: Colors.grey,
                  background: Colors.white,
                  onTap: () {
                    // showBottomSheet(
                    //   context: context,
                    //   builder: (context) {
                    //     return Container(
                    //       height: 150,
                    //       color: Colors.red,
                    //       child: Container(
                    //         decoration: const BoxDecoration(
                    //           color: Colors.white,
                    //           border: Border(
                    //             top: BorderSide(color: Colors.grey, width: 1),
                    //           ),
                    //         ),
                    //         height: 25,
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //           children: [
                    //             const SizedBox(width: 12),
                    //             Expanded(
                    //               child: GestureDetector(
                    //                 onTap: () async {
                    //                   Navigator.pop(context);
                    //                   PickedFile? pickedFile = await (ImagePicker().getImage(source: ImageSource.camera, imageQuality: 25));

                    //                   if (pickedFile != null) {
                    //                     List<File> files = images ?? [];
                    //                     File file = File(pickedFile.path);
                    //                     if (files.length >= 5) {
                    //                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('لا يمكن إضافة أكثر من 5 صور')));
                    //                       return;
                    //                     } else {
                    //                       files.add(file);
                    //                     }
                    //                     images = files;
                    //                   }
                    //                   setState(() {});
                    //                 },
                    //                 child: Container(
                    //                   width: double.infinity,
                    //                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    //                   decoration: BoxDecoration(
                    //                     color: Colors.white,
                    //                     borderRadius: BorderRadius.circular(4),
                    //                     border: Border.all(color: Colors.grey),
                    //                   ),
                    //                   child: Row(
                    //                     children: [
                    //                       Icon(Icons.camera_alt, color: Colors.grey[500]),
                    //                       const SizedBox(width: 8),
                    //                       Expanded(child: CustomText("Camera", color: Colors.grey[500]!)),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             const SizedBox(width: 12),
                    //             Expanded(
                    //               child: GestureDetector(
                    //                 onTap: () async {
                    //                   Navigator.pop(context);
                    //                   List<PickedFile>? pickedFile = await (ImagePicker().getMultiImage(imageQuality: 35));

                    //                   if (pickedFile != null && pickedFile.isNotEmpty) {
                    //                     List<File> files = images ?? [];
                    //                     pickedFile.forEach((element) {
                    //                       File file = File(element.path);
                    //                       if (files.length >= 5) {
                    //                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('لا يمكن إضافة أكثر من 5 صور')));
                    //                         return;
                    //                       } else {
                    //                         files.add(file);
                    //                       }
                    //                     });
                    //                     //remove dublicates
                    //                     files = files.toSet().toList();

                    //                     images = files;
                    //                     setState(() {});
                    //                   }
                    //                 },
                    //                 child: Container(
                    //                   width: double.infinity,
                    //                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    //                   decoration: BoxDecoration(
                    //                     color: Colors.white,
                    //                     borderRadius: BorderRadius.circular(4),
                    //                     border: Border.all(color: Colors.grey),
                    //                   ),
                    //                   child: Row(
                    //                     mainAxisSize: MainAxisSize.min,
                    //                     children: [
                    //                       Icon(Icons.image, color: Colors.grey[500]),
                    //                       const SizedBox(width: 8),
                    //                       Expanded(child: CustomText("Gallery", color: Colors.grey[500]!)),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             const SizedBox(width: 12),
                    //           ],
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // );
                  },
                ),
              ),

              CustomText("متي تحتاج هذه الخدمة؟").header(),
              //Two radio buttons
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: RadioListTile(
                      value: "حسب الوقت المحدد",
                      groupValue: "حسب الوقت المحدد",
                      title: CustomText("حسب الوقت المحدد",
                          align: TextAlign.start),
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {},
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: RadioListTile(
                      value: "فورا",
                      groupValue: "اليوم",
                      contentPadding: EdgeInsets.zero,
                      title: CustomText("فورا", align: TextAlign.start),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomTextField(
                      hint: "التاريخ",
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
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: CustomTextField(
                      hint: "الوقت",
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
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              CustomTextField(
                hint: "حدد الخدمات المطلوبة",
                prefixIcon: Icons.handyman,
                enable: false,
                radius: 4,
                noBorder: true,
                prefixIconColor: Colors.grey,
                background: Colors.white,
              ),

              // Builder(builder: (context) {
              //   return GestureDetector(
              //     onTap: () {
              //       showBottomSheet(
              //         context: context,
              //         builder: (context) {
              //           return Container(
              //             height: 150,
              //             color: Colors.red,
              //             child: Container(
              //               decoration: const BoxDecoration(
              //                 color: Colors.white,
              //                 border: Border(
              //                   top: BorderSide(color: Colors.grey, width: 1),
              //                 ),
              //               ),
              //               height: 25,
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                 children: [
              //                   const SizedBox(width: 12),
              //                   Expanded(
              //                     child: GestureDetector(
              //                       onTap: () async {
              //                         Navigator.pop(context);
              //                         PickedFile? pickedFile = await (ImagePicker().getImage(source: ImageSource.camera, imageQuality: 25));

              //                         if (pickedFile != null) {
              //                           List<File> files = images ?? [];
              //                           File file = File(pickedFile.path);
              //                           if (files.length >= 5) {
              //                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('لا يمكن إضافة أكثر من 5 صور')));
              //                             return;
              //                           } else {
              //                             files.add(file);
              //                           }
              //                           images = files;
              //                         }
              //                         setState(() {});
              //                       },
              //                       child: Container(
              //                         width: double.infinity,
              //                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              //                         decoration: BoxDecoration(
              //                           color: Colors.white,
              //                           borderRadius: BorderRadius.circular(4),
              //                           border: Border.all(color: Colors.grey),
              //                         ),
              //                         child: Row(
              //                           children: [
              //                             Icon(Icons.camera_alt, color: Colors.grey[500]),
              //                             const SizedBox(width: 8),
              //                             Expanded(child: CustomText("Camera", color: Colors.grey[500]!)),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                   const SizedBox(width: 12),
              //                   Expanded(
              //                     child: GestureDetector(
              //                       onTap: () async {
              //                         Navigator.pop(context);
              //                         List<PickedFile>? pickedFile = await (ImagePicker().getMultiImage(imageQuality: 35));

              //                         if (pickedFile != null && pickedFile.isNotEmpty) {
              //                           List<File> files = images ?? [];
              //                           pickedFile.forEach((element) {
              //                             File file = File(element.path);
              //                             if (files.length >= 5) {
              //                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('لا يمكن إضافة أكثر من 5 صور')));
              //                               return;
              //                             } else {
              //                               files.add(file);
              //                             }
              //                           });
              //                           //remove dublicates
              //                           files = files.toSet().toList();

              //                           images = files;
              //                           setState(() {});
              //                         }
              //                       },
              //                       child: Container(
              //                         width: double.infinity,
              //                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              //                         decoration: BoxDecoration(
              //                           color: Colors.white,
              //                           borderRadius: BorderRadius.circular(4),
              //                           border: Border.all(color: Colors.grey),
              //                         ),
              //                         child: Row(
              //                           mainAxisSize: MainAxisSize.min,
              //                           children: [
              //                             Icon(Icons.image, color: Colors.grey[500]),
              //                             const SizedBox(width: 8),
              //                             Expanded(child: CustomText("Gallery", color: Colors.grey[500]!)),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                   const SizedBox(width: 12),
              //                 ],
              //               ),
              //             ),
              //           );
              //         },
              //       );
              //     },
              //     child: Container(
              //       width: double.infinity,
              //       margin: const EdgeInsets.symmetric(horizontal: 4),
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(6),
              //         border: Border.all(color: Colors.grey),
              //       ),
              //       child: _buildImages(images),
              //     ),
              //   );
              // }),
              SizedBox(height: 24),
              CustomButton(
                title: "تأكيد الطلب",
                color: Colors.black,
                onTap: () async {
                  Navigator.pushNamed(context, RoutesServices.servicesOrders);
                },
              ),
            ],
          ),
        ));
  }

  _buildImages(List<File> files) {
    if (files.isEmpty)
      return Center(
          child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CustomImage(
            height: 80,
            width: 80,
            imageUrl: null,
          ),
        ),
      ));
    else
      return Container(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: files.length,
          itemBuilder: (context, index) {
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
                      imageUrl: files[index].path,
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
                            offset: const Offset(
                                0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Icon(
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

  _buildFile(File? pdf) {
    if (pdf == null)
      return Icon(Icons.picture_as_pdf, color: Colors.grey[500], size: 40);
    else
      return Container(
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

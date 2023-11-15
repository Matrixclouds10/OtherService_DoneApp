import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/data/models/chat/chat_model.dart';
import 'package:weltweit/features/data/models/order/order.dart';
import 'package:weltweit/features/logic/chat/chat_cubit.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

class ChatScreen extends StatefulWidget {
  final OrderModel orderModel;
  const ChatScreen({Key? key, required this.orderModel}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatModel> _messages = [];
  Timer? timer;
  AppPrefs appPrefs = getIt<AppPrefs>();
  int myId = 0;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    myId = appPrefs.get(PrefKeys.id, defaultValue: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ChatCubit>().getChat(widget.orderModel.id);
      await Future.delayed(Duration(milliseconds: 500));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    if (timer != null) timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.orderModel.provider?.name ?? '',
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (_messages.isEmpty) _messages.addAll(state.data.reversed);
          switch (state.state) {
            case BaseState.initial:
            case BaseState.loading:
              return Center(
                child: CircularProgressIndicator(),
              );
            case BaseState.loaded:
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return Align(
                            alignment: message.providerId == myId || message.providerId == 0 ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: message.providerId == myId || message.providerId == 0 ? Colors.orangeAccent : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (message.client?.id == myId) ...[
                                    Tooltip(
                                      message: message.client?.name ?? "",
                                      triggerMode: TooltipTriggerMode.tap,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(120.0),
                                        child: CachedNetworkImage(
                                          imageUrl: message.client!.fullImage,
                                          height: 40,
                                          width: 40,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                  ],
                                  SizedBox(
                                    width: deviceWidth * 0.64,
                                    child: _buildMessage(message),
                                  ),
                                  if (message.client?.id != myId) ...[
                                    SizedBox(width: 8.0),
                                    Tooltip(
                                      message: widget.orderModel.provider?.name ?? "",
                                      triggerMode: TooltipTriggerMode.tap,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(120.0),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.orderModel.provider?.image ?? "",
                                          height: 40,
                                          width: 40,
                                        ),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (value) {
                                _addMessage(Message(
                                  text: value,
                                  isMe: true,
                                ));
                              },
                              decoration: InputDecoration(
                                hintText: 'Type a message',
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          IconButton(
                            onPressed: () {
                              _addMessage(Message(
                                text: _messageController.text,
                                isMe: true,
                              ));
                            },
                            icon: Icon(Icons.send),
                          ),
                          IconButton(
                            onPressed: () {
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
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: _actionCamera,
                                                icon: Icon(Icons.camera_alt),
                                                label: CustomText(LocaleKeys.camera.tr()),
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: _actionGallery,
                                                icon: Icon(Icons.image, color: Colors.lightBlueAccent.shade400),
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100),
                                                label: CustomText(LocaleKeys.gallery.tr()),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.camera_alt),
                          ),

                          //share live location
                          IconButton(
                            onPressed: () async {
                              bool status = await AppDialogs().confirm(context, message: LocaleKeys.share_location.tr());

                              if (status) {
                                LocationPermission checkPermission = await Geolocator.checkPermission();
                                if (checkPermission == LocationPermission.whileInUse || checkPermission == LocationPermission.always) {
                                  _getCurrentLocation();
                                } else if (checkPermission == LocationPermission.deniedForever) {
                                 if(mounted)
                                   {
                                     AppSnackbar.show(
                                       context: context,
                                       message: LocaleKeys.location_permission_denied.tr(),
                                     );
                                   }
                                } else {
                                  LocationPermission locationPermission = await Geolocator.requestPermission();
                                  if (locationPermission == LocationPermission.denied || locationPermission == LocationPermission.deniedForever) {
                                   if(mounted)
                                     {
                                       AppSnackbar.show(
                                         context: context,
                                         message: LocaleKeys.location_permission_denied.tr(),
                                       );
                                     }
                                  } else {
                                    _getCurrentLocation();
                                  }
                                }
                              }
                            },
                            icon: Icon(Icons.location_on),
                          ),

                          SizedBox(width: 8.0),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            case BaseState.error:
              return ErrorLayout(errorModel: state.error);
          }
        },
      ),
    );
  }

  void _addMessage(Message message) async {
    // AppPrefs prefs = getIt<AppPrefs>();
    try {
      _messageController.clear();
      bool status = await context.read<ChatCubit>().sendMessage(widget.orderModel.id, message.text);
      if (status) {
        setState(() {
          _messages.add(
            ChatModel(
              id: 0,
              serviceOrderId: 0,
              providerId: 0,
              image: null,
              lat: null,
              lng: null,
              message: message.text,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
        });
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      if(mounted)
        {      AppSnackbar.show(context: context, message: e.toString(), type: SnackbarType.error);
        }
    }
  }

  void _actionCamera() async {
    Navigator.pop(context);
    XFile? pickedFile = await (ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 25));

    if (pickedFile != null) {
      if (context.mounted) await context.read<ChatCubit>().sendImage(widget.orderModel.id, pickedFile.path);
      setState(() {
        _messages.add(
          ChatModel(
            id: 0,
            serviceOrderId: 0,
            providerId: 0,
            image: pickedFile.path,
            lat: null,
            lng: null,
            message: 'image',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ); // if (context.mounted) await context.read<ChatCubit>().getChat(widget.orderModel.id);
    }
  }

  void _actionGallery() async {
    Navigator.pop(context);
    XFile? pickedFile = await (ImagePicker().pickImage(imageQuality: 35, source: ImageSource.gallery));

    if (pickedFile != null) {
      if (context.mounted) await context.read<ChatCubit>().sendImage(widget.orderModel.id, pickedFile.path);
      setState(() {
        _messages.add(
          ChatModel(
            id: 0,
            serviceOrderId: 0,
            providerId: 0,
            image: pickedFile.path,
            lat: null,
            lng: null,
            message: 'image',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ); // if (context.mounted) await context.read<ChatCubit>().getChat(widget.orderModel.id);
    }
  }

  _buildMessage(ChatModel message) {
    if (message.message == 'image') {
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: FullScreenWidget(
                  disposeLevel: DisposeLevel.Low,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(message.image!, fit: BoxFit.cover),
                  ),
                ),
              );
            },
          );
        },
        child: CustomImage(
          imageUrl: message.image!,
        ),
      );
    }
    if (message.message == 'location') {
      return Column(
        children: [
          SizedBox(
            height: 130,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(message.lat!), double.parse(message.lng!)),
                zoom: 14.4746,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('1'),
                  position: LatLng(double.parse(message.lat!), double.parse(message.lng!)),
                ),
              },
            ),
          ),
          SizedBox(height: 4.0),
          TextButton(
            onPressed: () {
              launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=${message.lat},${message.lng}'));
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            child: CustomText("Open on Google map", pv: 0, white: true),
          )
        ],
      );
    } else {
      return Text(message.message);
    }
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    if(mounted){
      bool status = await context.read<ChatCubit>().sendLocation(
          widget.orderModel.id, position.latitude, position.longitude);
      if (status) {
        setState(() {
          _messages.add(
            ChatModel(
              id: 0,
              serviceOrderId: 0,
              providerId: 0,
              image: null,
              lat: position.latitude.toString(),
              lng: position.longitude.toString(),
              message: 'location',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
        });
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }
}

class Message {
  final String text;
  String? image;
  String? lat;
  String? lng;
  final bool isMe;

  Message({required this.text, required this.isMe});
}

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/data/injection.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/logic/chat/chat_cubit.dart';
import 'package:weltweit/features/data/models/chat/chat_model.dart';
import 'package:weltweit/features/data/models/order/order.dart';
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
  List<ChatModel> _messages = [];
  Timer? timer;
  AppPrefs appPrefs = getIt<AppPrefs>();
  int myId = 0;
  @override
  void initState() {
    super.initState();
    myId = appPrefs.get(PrefKeys.id, defaultValue: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatCubit>().getChat(widget.orderModel.id);
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
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return Align(
                            alignment: message.providerId == myId || message.providerId == 0 ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: message.providerId == myId || message.providerId == 0 ? Colors.lightBlueAccent : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: _buildMessage(message),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
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
                              labelText: 'Type a message',
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
                                              icon: Icon(Icons.image, color: Colors.blue.shade400),
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
                                Position position = await Geolocator.getCurrentPosition();
                                bool status = await context.read<ChatCubit>().sendLocation(widget.orderModel.id, position.latitude, position.longitude);
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
                                }
                              } else if (checkPermission == LocationPermission.deniedForever) {
                                AppSnackbar.show(
                                  context: context,
                                  message: LocaleKeys.location_permission_denied.tr(),
                                );
                              } else {
                                await Geolocator.requestPermission();
                              }
                            }
                          },
                          icon: Icon(Icons.location_on),
                        ),

                        SizedBox(width: 8.0),
                      ],
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
    AppPrefs prefs = getIt<AppPrefs>();
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
      }
    } catch (e) {
      AppSnackbar.show(context: context, message: e.toString(), type: SnackbarType.error);
    }
  }

  void _actionCamera() async {
    Navigator.pop(context);
    PickedFile? pickedFile = await (ImagePicker().getImage(source: ImageSource.camera, imageQuality: 25));

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
      // if (context.mounted) await context.read<ChatCubit>().getChat(widget.orderModel.id);
    }
  }

  void _actionGallery() async {
    Navigator.pop(context);
    PickedFile? pickedFile = await (ImagePicker().getImage(imageQuality: 35, source: ImageSource.gallery));

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
      // if (context.mounted) await context.read<ChatCubit>().getChat(widget.orderModel.id);
    }
  }

  _buildMessage(ChatModel message) {
    if (message.message == 'image') {
      return CustomImage(
        imageUrl: message.image!,
        width: deviceWidth / 2,
      );
    }
    if (message.message == 'location') {
      return Column(
        children: [
          SizedBox(
            height: 200,
            width: deviceWidth * 0.8,
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
          TextButton(
              onPressed: () {
                launch('https://www.google.com/maps/search/?api=1&query=${message.lat},${message.lng}');
              },
              child: CustomText("Open on Google map"))
        ],
      );
    } else {
      return Text(message.message);
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

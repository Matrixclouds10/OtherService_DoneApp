import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/values_manager.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/data/models/chat/chat_model.dart';
import 'package:weltweit/features/data/models/order/order.dart';
import 'package:weltweit/features/logic/chat/chat_cubit.dart';
import 'package:weltweit/features/screens/chat/widgets/chat_app_bar.dart';
import 'package:weltweit/features/screens/chat/widgets/custom_loading_widget.dart';
import 'package:weltweit/features/screens/chat/widgets/input_chat.dart';
import 'package:weltweit/features/screens/chat/widgets/message_card.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/presentation/component/component.dart';

import '../../../core/resources/color.dart';
import '../../../presentation/component/inputs/base_form.dart';
import '../../data/models/auth/user_model.dart';
import '../../data/models/chat/chat_user.dart';
import '../../data/models/chat/message_model.dart';
import '../../logic/profile/profile_cubit.dart';
import '../../logic/provider_profile/profile_cubit.dart';

class ChatScreen extends StatefulWidget {
  final OrderModel orderModel;
  final ChatUser receiverData;
  final bool isUser;

  const ChatScreen(
      {Key? key,
      required this.orderModel,
      required this.isUser,
      required this.receiverData})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatModel> _messages = [];
  Timer? timer;
  AppPrefs appPrefs = getIt<AppPrefs>();
  String myId = '0';
  final ScrollController _scrollController = ScrollController();
  ChatCubit cubit = ChatCubit.get();
  ChatUser? my;

  @override
  void initState() {
    super.initState();
    cubit.showEmoji = false;
    getUserProfile(widget.receiverData.id);
    cubit.createChat(widget.receiverData);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.isUser == true) {
        UserModel userModel =
            await BlocProvider.of<ProfileCubit>(context, listen: false)
                .getProfile();
        ChatUser user = ChatUser(
            image: userModel.image ?? '',
            about: '',
            name: userModel.name ?? '',
            createdAt: '',
            isOnline: true,
            id: userModel.id.toString() ?? '0',
            lastActive: '',
            phone: userModel.mobileNumber ?? '',
            pushToken: '');
        my = user;
        cubit.getSelfInfo(user);
      } else {
        UserModel providerUserModel =
            await BlocProvider.of<ProfileProviderCubit>(context, listen: false)
                .getProfile();
        ChatUser user = ChatUser(
            image: providerUserModel.image ?? '',
            about: '',
            name: providerUserModel.name ?? '',
            createdAt: '',
            isOnline: true,
            id: providerUserModel.id.toString() ?? '0',
            lastActive: '',
            phone: providerUserModel.mobileNumber ?? '',
            pushToken: '');
        my = user;
        cubit.getSelfInfo(user);
      }
    });
  }

  ChatUser? receiver;

  void getUserProfile(String id) async {
    receiver = await cubit.getUserInfo(id);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cubit.getChatRoomName(widget.receiverData.name ?? '');

    return PopScope(
        canPop: true,
        onPopInvoked: (_) async {
          cubit.getChatRoomName('');
        },
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: ChatAppBarWidget(
                user: receiver ?? widget.receiverData,
              )),
          body: BlocConsumer<ChatCubit, ChatState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (cubit.profile != null) {
                my = cubit.profile!;
                return SafeArea(
                  child: Column(
                    children: <Widget>[
                      Expanded(child: _buildMessageList(context)),
                      if (cubit.showEmoji) _buildEmojiPicker(),
                      _buildInputArea(context),
                    ],
                  ),
                );
              } else {
                return CustomLoadingWidget();
              }
              // return SafeArea(
              //   child: Column(
              //     children: [
              //       Expanded(
              //         child: StreamBuilder(
              //           stream: cubit.getAllMessages(provider.id.toString()==myId?widget.orderModel.client!.id.toString():provider.id.toString()),
              //           builder: (context, snapshot) {
              //             switch (snapshot.connectionState) {
              //             //if data is loading
              //               case ConnectionState.waiting:
              //               case ConnectionState.none:
              //                 return CustomLoadingWidget();
              //             //if some or all data is loaded then show it
              //               case ConnectionState.active:
              //               case ConnectionState.done:
              //                 final data = snapshot.data?.docs;
              //                 cubit.messagesList = data?.map((e) =>
              //                     MessageModel.fromJson(e.data())).toList() ?? [];
              //                 if (cubit.messagesList.isNotEmpty) {
              //                   // return Padding(
              //                   //     padding: const EdgeInsets.all(8.0),
              //                   //     child: Column(
              //                   //       children: [
              //                   //         Expanded(
              //                   //           child: ListView.builder(
              //                   //             reverse: true,
              //                   //             controller: _scrollController,
              //                   //             itemCount: cubit.messagesList.length,
              //                   //             itemBuilder: (context, index) {
              //                   //               final MessageModel message = cubit.messagesList[index];
              //                   //               return Align(
              //                   //                 alignment: message.toId != myId || message.toId == '0' ? Alignment.centerRight : Alignment.centerLeft,
              //                   //                 child: Container(
              //                   //                   margin: const EdgeInsets.all(8.0),
              //                   //                   padding: const EdgeInsets.all(8.0),
              //                   //                   decoration: BoxDecoration(
              //                   //                     color: message.toId != myId || message.toId == '0' ? Colors.orangeAccent : Colors.grey.shade300,
              //                   //                     borderRadius: BorderRadius.circular(10.0),
              //                   //                   ),
              //                   //                   child: Row(
              //                   //                     mainAxisSize: MainAxisSize.min,
              //                   //                     children: [
              //                   //                       if (message.fromId == myId) ...[
              //                   //                         Tooltip(
              //                   //                           message: userProfile?.name??'',
              //                   //                           triggerMode: TooltipTriggerMode.tap,
              //                   //                           child: ClipRRect(
              //                   //                             borderRadius: BorderRadius.circular(120.0),
              //                   //                             child: CachedNetworkImage(
              //                   //                               imageUrl: userProfile?.image??'',
              //                   //                               height: 40,
              //                   //                               width: 40,
              //                   //                             ),
              //                   //                           ),
              //                   //                         ),
              //                   //                         SizedBox(width: 8.0),
              //                   //                       ],
              //                   //                       SizedBox(
              //                   //                         // width: deviceWidth * 0.64,
              //                   //                         child: _buildMessage(message),
              //                   //                       ),
              //                   //                       if (message.fromId != myId) ...[
              //                   //                         SizedBox(width: 8.0),
              //                   //                         Tooltip(
              //                   //                           message: widget.orderModel.provider?.name ?? "",
              //                   //                           triggerMode: TooltipTriggerMode.tap,
              //                   //                           child: ClipRRect(
              //                   //                             borderRadius: BorderRadius.circular(120.0),
              //                   //                             child: CachedNetworkImage(
              //                   //                               imageUrl: widget.orderModel.provider?.image ?? "",
              //                   //                               height: 40,
              //                   //                               width: 40,
              //                   //                             ),
              //                   //                           ),
              //                   //                         ),
              //                   //                       ]
              //                   //                     ],
              //                   //                   ),
              //                   //                 ),
              //                   //               );
              //                   //             },
              //                   //           ),
              //                   //         ),
              //                   //
              //                   //       ],
              //                   //     ),
              //                   //   );
              //
              //                    return ListView.builder(
              //                       reverse: true,
              //                       itemCount: cubit.messagesList.length,
              //                       padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .01,left: 10),
              //                       physics: const BouncingScrollPhysics(),
              //                       itemBuilder: (context, index) {
              //                         return MessageCard(message: cubit.messagesList[index], isMe:cubit.messagesList[index].fromId == myId,);
              //                       });
              //                 }
              //                 else {
              //                   return const Center(
              //                     child: Text('Say Hii! 👋',
              //                         style: TextStyle(fontSize: 20)),
              //                   );
              //                 }
              //             }
              //           },
              //         ),
              //       ),
              //
              //       // if (cubit.isUploading)
              //       //   const Align(
              //       //       alignment: Alignment.centerRight,
              //       //       child: Padding(
              //       //           padding:
              //       //           EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              //       //           child: CircularProgressIndicator(strokeWidth: 2))),
              //       //
              //       // //chat input filed
              //       // ChatInputWidget(user: userProfile!,),
              //       // //show emojis on keyboard emoji button click & vice versa
              //       if (cubit.showEmoji)
              //         SizedBox(
              //           height: MediaQuery.of(context).size.height * .35,
              //           child: EmojiPicker(
              //             textEditingController: cubit.textController,
              //             config: const Config(),
              //           ),
              //         ),
              //       Padding(
              //         padding: const EdgeInsets.only(top: 8),
              //         child: Row(
              //           children: [
              //             SizedBox(width: 5.0),
              //
              //             InkWell(
              //               onTap: (){
              //                 FocusScope.of(context).unfocus();
              //                 setState(() => cubit.showEmoji = !cubit.showEmoji);
              //               },
              //               child: Icon(Icons.emoji_emotions_outlined,
              //                 size: 28,
              //                 color: Colors.grey.shade700,),
              //             ),
              //             SizedBox(width: 5.0),
              //
              //             Expanded(
              //               child: TextField(
              //                 controller: cubit.textController,
              //                 textInputAction: TextInputAction.send,
              //                 onSubmitted: (value) {
              //                   if (cubit.messagesList.isEmpty) {
              //                     //on first message (add user to my_user collection of chat user)
              //                     cubit.sendFirstMessage(
              //                         providerProfile!, cubit.textController.text, TypeMessage.text);
              //                   } else {
              //                     //simply send message
              //                     cubit.sendMessageFirebase(
              //                         providerProfile!, cubit.textController.text, TypeMessage.text);
              //                   }
              //                   // cubit.sendMessage(widget.user, cubit.textController.text, Type.text);
              //                   cubit.textController.text = '';
              //                   // _addMessage(MessageModel(
              //                   //   text: value,
              //                   //   isMe: true,
              //                   // ));chatScreen
              //                 },
              //                 decoration: InputDecoration(
              //                   hintText: 'Type a message',
              //                 ),
              //               ),
              //             ),
              //             SizedBox(width: 8.0),
              //             InkWell(
              //               onTap: (){
              //                   if (cubit.messagesList.isEmpty) {
              //                   //on first message (add user to my_user collection of chat user)
              //                   cubit.sendFirstMessage(
              //                   providerProfile!, cubit.textController.text, TypeMessage.text);
              //                   } else {
              //                   //simply send message
              //                   cubit.sendMessageFirebase(
              //                   providerProfile!, cubit.textController.text, TypeMessage.text);
              //                   }
              //                   // cubit.sendMessage(widget.user, cubit.textController.text, Type.text);
              //                   cubit.textController.text = '';
              //                   },
              //               child: Icon(Icons.send),
              //             ),
              //             SizedBox(width: 5.0),
              //
              //             InkWell(
              //               onTap: () {
              //                 showModalBottomSheet(
              //                   context: context,
              //                   builder: (context) {
              //                     return Container(
              //                       height: 150,
              //                       color: Colors.red,
              //                       child: Container(
              //                         padding: EdgeInsets.symmetric(vertical: 12),
              //                         decoration: const BoxDecoration(
              //                           color: Colors.white,
              //                           border: Border(
              //                             top: BorderSide(color: Colors.grey, width: 1),
              //                           ),
              //                         ),
              //                         height: 25,
              //                         child: Column(
              //                           children: [
              //                             Row(
              //                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                               children: [
              //                                 ElevatedButton.icon(
              //                                   onPressed: _actionCamera,
              //                                   icon: Icon(Icons.camera_alt),
              //                                   label: CustomText(LocaleKeys.camera.tr()),
              //                                 ),
              //                                 ElevatedButton.icon(
              //                                   onPressed: _actionGallery,
              //                                   icon: Icon(Icons.image, color: Colors.lightBlueAccent.shade400),
              //                                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100),
              //                                   label: CustomText(LocaleKeys.gallery.tr()),
              //                                 ),
              //                               ],
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     );
              //                   },
              //                 );
              //               },
              //               child: Icon(Icons.camera_alt),
              //             ),
              //             SizedBox(width: 5.0),
              //
              //             InkWell(
              //               onTap: () async {
              //                 bool status = await AppDialogs().confirm(context, message: LocaleKeys.share_location.tr());
              //
              //                 if (status) {
              //                   LocationPermission checkPermission = await Geolocator.checkPermission();
              //                   if (checkPermission == LocationPermission.whileInUse || checkPermission == LocationPermission.always) {
              //                     _getCurrentLocation();
              //                   } else if (checkPermission == LocationPermission.deniedForever) {
              //                     AppSnackbar.show(
              //                       context: context,
              //                       message: LocaleKeys.location_permission_denied.tr(),
              //                     );
              //                   } else {
              //                     LocationPermission locationPermission = await Geolocator.requestPermission();
              //                     if (locationPermission == LocationPermission.denied || locationPermission == LocationPermission.deniedForever) {
              //                       AppSnackbar.show(
              //                         context: context,
              //                         message: LocaleKeys.location_permission_denied.tr(),
              //                       );
              //                     } else {
              //                       _getCurrentLocation();
              //                     }
              //                   }
              //                 }
              //               },
              //               child: Icon(Icons.location_on),
              //             ),
              //             SizedBox(width: 5.0),
              //           ],
              //         ),
              //       ),
              //
              //     ],
              //   ),
              // );
            },
          ),

          // BlocBuilder<ChatCubit, ChatState>(
          //   builder: (context, state) {
          //     if (_messages.isEmpty) _messages.addAll(state.data.reversed);
          //     switch (state.state) {
          //       case BaseState.initial:
          //       case BaseState.loading:
          //         return Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       case BaseState.loaded:
          //         return Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Column(
          //             children: [
          //               Expanded(
          //                 child: ListView.builder(
          //                   controller: _scrollController,
          //                   itemCount: _messages.length,
          //                   itemBuilder: (context, index) {
          //                     final message = _messages[index];
          //                     return Align(
          //                       alignment: message.providerId == myId || message.providerId == 0 ? Alignment.centerRight : Alignment.centerLeft,
          //                       child: Container(
          //                         margin: const EdgeInsets.all(8.0),
          //                         padding: const EdgeInsets.all(8.0),
          //                         decoration: BoxDecoration(
          //                           color: message.providerId == myId || message.providerId == 0 ? Colors.orangeAccent : Colors.grey.shade300,
          //                           borderRadius: BorderRadius.circular(10.0),
          //                         ),
          //                         child: Row(
          //                           mainAxisSize: MainAxisSize.min,
          //                           children: [
          //                             if (message.client?.id == myId) ...[
          //                               Tooltip(
          //                                 message: message.client?.name ?? "",
          //                                 triggerMode: TooltipTriggerMode.tap,
          //                                 child: ClipRRect(
          //                                   borderRadius: BorderRadius.circular(120.0),
          //                                   child: CachedNetworkImage(
          //                                     imageUrl: message.client!.fullImage,
          //                                     height: 40,
          //                                     width: 40,
          //                                   ),
          //                                 ),
          //                               ),
          //                               SizedBox(width: 8.0),
          //                             ],
          //                             SizedBox(
          //                               width: deviceWidth * 0.64,
          //                               child: _buildMessage(message),
          //                             ),
          //                             if (message.client?.id != myId) ...[
          //                               SizedBox(width: 8.0),
          //                               Tooltip(
          //                                 message: widget.orderModel.provider?.name ?? "",
          //                                 triggerMode: TooltipTriggerMode.tap,
          //                                 child: ClipRRect(
          //                                   borderRadius: BorderRadius.circular(120.0),
          //                                   child: CachedNetworkImage(
          //                                     imageUrl: widget.orderModel.provider?.image ?? "",
          //                                     height: 40,
          //                                     width: 40,
          //                                   ),
          //                                 ),
          //                               ),
          //                             ]
          //                           ],
          //                         ),
          //                       ),
          //                     );
          //                   },
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.only(top: 8),
          //                 child: Row(
          //                   children: [
          //                     Expanded(
          //                       child: TextField(
          //                         controller: _messageController,
          //                         textInputAction: TextInputAction.send,
          //                         onSubmitted: (value) {
          //                           _addMessage(Message(
          //                             text: value,
          //                             isMe: true,
          //                           ));
          //                         },
          //                         decoration: InputDecoration(
          //                           hintText: 'Type a message',
          //                         ),
          //                       ),
          //                     ),
          //                     SizedBox(width: 8.0),
          //                     IconButton(
          //                       onPressed: () {
          //                         _addMessage(Message(
          //                           text: _messageController.text,
          //                           isMe: true,
          //                         ));
          //                       },
          //                       icon: Icon(Icons.send),
          //                     ),
          //                     IconButton(
          //                       onPressed: () {
          //                         showModalBottomSheet(
          //                           context: context,
          //                           builder: (context) {
          //                             return Container(
          //                               height: 150,
          //                               color: Colors.red,
          //                               child: Container(
          //                                 padding: EdgeInsets.symmetric(vertical: 12),
          //                                 decoration: const BoxDecoration(
          //                                   color: Colors.white,
          //                                   border: Border(
          //                                     top: BorderSide(color: Colors.grey, width: 1),
          //                                   ),
          //                                 ),
          //                                 height: 25,
          //                                 child: Column(
          //                                   children: [
          //                                     Row(
          //                                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                                       children: [
          //                                         ElevatedButton.icon(
          //                                           onPressed: _actionCamera,
          //                                           icon: Icon(Icons.camera_alt),
          //                                           label: CustomText(LocaleKeys.camera.tr()),
          //                                         ),
          //                                         ElevatedButton.icon(
          //                                           onPressed: _actionGallery,
          //                                           icon: Icon(Icons.image, color: Colors.lightBlueAccent.shade400),
          //                                           style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100),
          //                                           label: CustomText(LocaleKeys.gallery.tr()),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ],
          //                                 ),
          //                               ),
          //                             );
          //                           },
          //                         );
          //                       },
          //                       icon: Icon(Icons.camera_alt),
          //                     ),
          //
          //                     //share live location
          //                     IconButton(
          //                       onPressed: () async {
          //                         bool status = await AppDialogs().confirm(context, message: LocaleKeys.share_location.tr());
          //
          //                         if (status) {
          //                           LocationPermission checkPermission = await Geolocator.checkPermission();
          //                           if (checkPermission == LocationPermission.whileInUse || checkPermission == LocationPermission.always) {
          //                             _getCurrentLocation();
          //                           } else if (checkPermission == LocationPermission.deniedForever) {
          //                             AppSnackbar.show(
          //                               context: context,
          //                               message: LocaleKeys.location_permission_denied.tr(),
          //                             );
          //                           } else {
          //                             LocationPermission locationPermission = await Geolocator.requestPermission();
          //                             if (locationPermission == LocationPermission.denied || locationPermission == LocationPermission.deniedForever) {
          //                               AppSnackbar.show(
          //                                 context: context,
          //                                 message: LocaleKeys.location_permission_denied.tr(),
          //                               );
          //                             } else {
          //                               _getCurrentLocation();
          //                             }
          //                           }
          //                         }
          //                       },
          //                       icon: Icon(Icons.location_on),
          //                     ),
          //
          //                     SizedBox(width: 8.0),
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           ),
          //         );
          //       case BaseState.error:
          //         return ErrorLayout(errorModel: state.error);
          //     }
          //   },
          // ),
        ));
  }

  Widget _buildMessageList(BuildContext context) {
    return StreamBuilder(
      stream: cubit.getAllMessages(receiver?.id ?? widget.receiverData.id),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return CustomLoadingWidget();
          case ConnectionState.active:
          case ConnectionState.done:
            final List<QueryDocumentSnapshot<Map<String, dynamic>>>? data =
                snapshot.data?.docs;
            cubit.messagesList = data
                    ?.map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                        MessageModel.fromJson(e.data()))
                    .toList() ??
                <MessageModel>[];
            if (cubit.messagesList.isNotEmpty) {
              return ListView.builder(
                  reverse: true,
                  itemCount: cubit.messagesList.length,
                  padding: EdgeInsets.only(top: 10, left: 10),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    // return Text('ss');
                    return MessageCard(
                      message: cubit.messagesList[index],
                      isMe: cubit.messagesList[index].fromId == my!.id,
                    );
                  });
            } else {
              return const Center(
                child: Text('Say Hii! 👋', style: TextStyle(fontSize: 20)),
              );
            }
        }
      },
    );
  }

  Widget _buildEmojiPicker() {
    return SizedBox(
      height: 350.h,
      child: EmojiPicker(
        textEditingController: cubit.textController,
        config: const Config(),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 0),
        child: Container(
          color: primaryColor.withOpacity(0.2),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: <Widget>[
              SizedBox(width: 5.0),
              InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  setState(() => cubit.showEmoji = !cubit.showEmoji);
                },
                child: Icon(
                  Icons.emoji_emotions_outlined,
                  size: 28,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(width: 5.0),
              Expanded(
                  child: CustomTextField(
                      onTap: () {
                        cubit.showEmoji = false;
                      },
                      hint: 'Type a message',
                      textInputAction: TextInputAction.send,
                      onSubmit: (String value) {
                        if(cubit.textController.text.isEmpty) return;
                        if (cubit.messagesList.isEmpty) {
                          cubit.sendFirstMessage(
                              receiver ?? widget.receiverData,
                              cubit.textController.text,
                              TypeMessage.text);
                        } else {
                          cubit.sendMessageFirebase(
                              receiver ?? widget.receiverData,
                              cubit.textController.text,
                              TypeMessage.text);
                        }
                        cubit.textController.text = '';
                      },
                      controller: cubit.textController)),
              SizedBox(width: 8.0),
              InkWell(
                onTap: () {
                  if(cubit.textController.text.isEmpty) return;
                  if (cubit.messagesList.isEmpty) {
                    cubit.sendFirstMessage(receiver ?? widget.receiverData,
                        cubit.textController.text, TypeMessage.text);
                  } else {
                    cubit.sendMessageFirebase(receiver ?? widget.receiverData,
                        cubit.textController.text, TypeMessage.text);
                  }
                  cubit.textController.text = '';
                },
                child: Icon(Icons.send),
              ),
              SizedBox(width: 5.0),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 200,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.5),
                            boxShadow: const [
                              BoxShadow(color: Colors.white, blurRadius: 7)
                            ],
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20)),
                            border: Border.all(color: primaryColor, width: 2),
                          ),
                          height: 25,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  InkWell(
                                    onTap: _actionCamera,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: primaryColor, width: 2),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black45,
                                                blurRadius: 7)
                                          ]),
                                      height: 100.h,
                                      width: 120.w,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: primaryColor,
                                        size: 60,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: _actionGallery,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: primaryColor, width: 2),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black45,
                                                blurRadius: 7)
                                          ]),
                                      height: 100.h,
                                      width: 120.w,
                                      child: Icon(
                                        Icons.image,
                                        color: primaryColor,
                                        size: 60,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Icon(Icons.camera_alt),
              ),
              SizedBox(width: 5.0),
              InkWell(
                onTap: () async {
                  bool status = await AppDialogs().confirm(context,
                      message: LocaleKeys.share_location.tr());

                  if (status) {
                    LocationPermission checkPermission =
                        await Geolocator.checkPermission();
                    if (checkPermission == LocationPermission.whileInUse ||
                        checkPermission == LocationPermission.always) {
                      _getCurrentLocation();
                    } else if (checkPermission ==
                        LocationPermission.deniedForever) {
                      AppSnackbar.show(
                        context: context,
                        message: LocaleKeys.location_permission_denied.tr(),
                      );
                    } else {
                      LocationPermission locationPermission =
                          await Geolocator.requestPermission();
                      if (locationPermission == LocationPermission.denied ||
                          locationPermission ==
                              LocationPermission.deniedForever) {
                        AppSnackbar.show(
                          context: context,
                          message: LocaleKeys.location_permission_denied.tr(),
                        );
                      } else {
                        _getCurrentLocation();
                      }
                    }
                  }
                },
                child: Icon(Icons.location_on),
              ),
              SizedBox(width: 5.0),
            ],
          ),
        ));
  }

  void _actionCamera() async {
    Navigator.pop(context);
    XFile? pickedFile = await (ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10));
    if (pickedFile != null) {
      await cubit.sendChatImage(
          receiver ?? widget.receiverData, File(pickedFile.path));
    }
  }

  void _actionGallery() async {
    Navigator.pop(context);
    XFile? pickedFile = await (ImagePicker()
        .pickImage(imageQuality: 10, source: ImageSource.gallery));
    if (pickedFile != null) {
      await cubit.sendChatImage(
          receiver ?? widget.receiverData, File(pickedFile.path));
    }
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    if (cubit.messagesList.isEmpty) {
      cubit.sendFirstMessage(receiver ?? widget.receiverData,
          cubit.textController.text, TypeMessage.location);
    } else {
      cubit.sendMessageFirebase(receiver ?? widget.receiverData,
          cubit.textController.text, TypeMessage.text);
    }
    cubit.textController.text = '';
    cubit.sendLocationFirebase(receiver ?? widget.receiverData,
        position.latitude.toString(), position.longitude.toString());
  }

// void _addMessage(Message message) async {
//   // AppPrefs prefs = getIt<AppPrefs>();
//   try {
//     _messageController.clear();
//     bool status = await context.read<ChatCubit>().sendMessage(widget.orderModel.id, message.text);
//     if (status) {
//       setState(() {
//         _messages.add(
//           ChatModel(
//             id: 0,
//             serviceOrderId: 0,
//             providerId: 0,
//             image: null,
//             lat: null,
//             lng: null,
//             message: message.text,
//             createdAt: DateTime.now(),
//             updatedAt: DateTime.now(),
//           ),
//         );
//       });
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   } catch (e) {
//     AppSnackbar.show(context: context, message: e.toString(), type: SnackbarType.error);
//   }
// }

// void _actionCamera2() async {
//   Navigator.pop(context);
//   PickedFile? pickedFile = await (ImagePicker().getImage(source: ImageSource.camera, imageQuality: 10));
//
//   if (pickedFile != null) {
//      await cubit.sendChatImage(widget.isUser==true?providerProfile!:userProfile!, File(pickedFile.path));
//     // setState(() {
//     //   cubit.messagesList.add(
//     //     MessageModel(
//     //       toId: userProfile?.id??'',
//     //       msg: '',
//     //       read: '',
//     //       type: TypeMessage.image,
//     //       lat: '',
//     //       long: '',
//     //       fromId: '',
//     //       sentTime:DateTime.now().toString(),
//     //     ),
//     //   );
//     // // });
//     // _scrollController.animateTo(
//     //   _scrollController.position.maxScrollExtent,
//     //   duration: const Duration(milliseconds: 300),
//     //   curve: Curves.easeOut,
//     // ); // if (context.mounted) await context.read<ChatCubit>().getChat(widget.orderModel.id);
//   }
// }

// void _actionGallery() async {
//   Navigator.pop(context);
//   PickedFile? pickedFile = await (ImagePicker().getImage(imageQuality: 10, source: ImageSource.gallery));
//
//   if (pickedFile != null) {
//     // if (context.mounted) await context.read<ChatCubit>().sendImage(widget.orderModel.id, pickedFile.path);
//     await cubit.sendChatImage(widget.isUser==true?providerProfile!:userProfile!, File(pickedFile.path));
//
//     setState(() {
//       // _messages.add(
//       //   ChatModel(
//       //     id: 0,
//       //     serviceOrderId: 0,
//       //     providerId: 0,
//       //     image: pickedFile.path,
//       //     lat: null,
//       //     lng: null,
//       //     message: 'image',
//       //     createdAt: DateTime.now(),
//       //     updatedAt: DateTime.now(),
//       //   ),
//       // );
//     });
//     // _scrollController.animateTo(
//     //   _scrollController.position.maxScrollExtent,
//     //   duration: const Duration(milliseconds: 300),
//     //   curve: Curves.easeOut,
//     // ); // if (context.mounted) await context.read<ChatCubit>().getChat(widget.orderModel.id);
//   }
// }
//
//
//
// void _getCurrentLocation() async {
//   Position position = await Geolocator.getCurrentPosition();
//   if (cubit.messagesList.isEmpty) {
//     cubit.sendFirstMessage(providerProfile!, cubit.textController.text, TypeMessage.location);
//   } else {
//     //simply send message
//     cubit.sendMessageFirebase(providerProfile!, cubit.textController.text, TypeMessage.text);
//   }
//   // cubit.sendMessage(widget.user, cubit.textController.text, Type.text);
//   cubit.textController.text = '';
//    cubit.sendLocationFirebase(widget.isUser==true?providerProfile!:userProfile!,position.latitude.toString(),position.longitude.toString());
//   // bool status = await context.read<ChatCubit>().sendLocation(widget.orderModel.id, position.latitude, position.longitude);
//   // if (status) {
//   //   setState(() {
//   //     _messages.add(
//   //       ChatModel(
//   //         id: 0,
//   //         serviceOrderId: 0,
//   //         providerId: 0,
//   //         image: null,
//   //         lat: position.latitude.toString(),
//   //         lng: position.longitude.toString(),
//   //         message: 'location',
//   //         createdAt: DateTime.now(),
//   //         updatedAt: DateTime.now(),
//   //       ),
//   //     );
//   //   });
//   //   _scrollController.animateTo(
//   //     _scrollController.position.maxScrollExtent,
//   //     duration: const Duration(milliseconds: 300),
//   //     curve: Curves.easeOut,
//   //   );
//   // }
// }
}
// _buildMessage(MessageModel message) {
//   if (message.type == TypeMessage.image) {
//     return GestureDetector(
//       onTap: () {
//         showDialog(
//           context: context,
//           builder: (context) {
//             return Dialog(
//               child: FullScreenWidget(
//                 disposeLevel: DisposeLevel.Low,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Image.network(message.msg??'', fit: BoxFit.cover,
//                     errorBuilder: (c,s,r){
//                       return Center(child: CircularProgressIndicator(),);
//                     },
//
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//       child: CustomImage(
//         imageUrl: message.msg!,
//       ),
//     );
//   }
//   if (message.type == TypeMessage.location) {
//     return
//       Column(
//         children: [
//           SizedBox(
//             height: 130,
//             child: GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(double.parse(message.lat), double.parse(message.long!)),
//                 zoom: 14.4746,
//               ),
//               markers: {
//                 Marker(
//                   markerId: MarkerId('1'),
//                   position: LatLng(double.parse(message.lat), double.parse(message.long!)),
//                 ),
//               },
//             ),
//           ),
//           SizedBox(height: 4.0),
//           TextButton(
//             onPressed: () {
//               launch('https://www.google.com/maps/search/?api=1&query=${message.lat},${message.long}');
//             },
//             style: TextButton.styleFrom(
//               backgroundColor: Colors.black,
//             ),
//             child: CustomText("Open on Google map", pv: 0, white: true),
//           )
//         ],
//       );
//   } else {
//     return Text(message.msg);
//   }
// }
// class Message {
//   final String text;
//   String? image;
//   String? lat;
//   String? lng;
//   final bool isMe;
//
//   Message({required this.text, required this.isMe});
// }

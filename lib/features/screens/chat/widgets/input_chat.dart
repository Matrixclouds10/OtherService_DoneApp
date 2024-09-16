import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/chat/chat_user.dart';
import '../../../data/models/chat/message_model.dart';
import '../../../logic/chat/chat_cubit.dart';


class ChatInputWidget extends StatefulWidget {
  final ChatUser user;
  const ChatInputWidget({super.key, required this.user});

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {


  @override
  Widget build(BuildContext context) {
    ChatCubit cubit =ChatCubit.get();
    var mq =MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => cubit.showEmoji = !cubit.showEmoji);
                      },
                      icon: const Icon(Icons.emoji_emotions_outlined,
                          color: Colors.grey, size: 25)),

                  Expanded(
                      child: TextField(
                        controller:cubit.textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onTap: () {
                          if (cubit.showEmoji) setState(() =>cubit.showEmoji = !cubit.showEmoji);
                        },
                        decoration: const InputDecoration(
                            hintText: 'Message',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none),
                      )),

                  //pick image from gallery button
                  InkWell(
                    onTap: ()async {
                      final ImagePicker picker = ImagePicker();

                      // Picking multiple images
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);

                      // uploading & sending image one by one
                      for (var i in images) {
                        setState(() => cubit.isUploading = true);
                        await cubit.sendChatImage(widget.user, File(i.path));
                        setState(() => cubit.isUploading = false);
                      }
                    },
                    child: const Icon(Icons.image,
                        color: Colors.grey, size: 26),
                  ),

                  SizedBox(width: mq.width * .01),

                  //take image from camera button
                  InkWell(
                    onTap: ()async{
                      final ImagePicker picker = ImagePicker();

                      // Pick an image
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        setState(() => cubit.isUploading = true);

                        await cubit.sendChatImage(
                            widget.user, File(image.path));
                        setState(() => cubit.isUploading = false);
                      }
                    },
                    child: const Icon(Icons.camera_alt_rounded,
                        color: Colors.grey, size: 26),
                  ),
                  //adding some space
                  SizedBox(width: mq.width * .03),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: (){
              if (cubit.messagesList.isEmpty) {
                //on first message (add user to my_user collection of chat user)
                cubit.sendFirstMessage(
                    widget.user, cubit.textController.text, TypeMessage.text);
              } else {
                //simply send message
                cubit.sendMessageFirebase(
                    widget.user, cubit.textController.text, TypeMessage.text);
              }
                    // cubit.sendMessage(widget.user, cubit.textController.text, Type.text);
                    cubit.textController.text = '';
            },
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.green,
              child: Icon(Icons.send,color: Colors.white, size: 18),
            ),
          )

          //send message button

          // MaterialButton(
          //   onPressed: () {
          //     if (cubit.textController.text.isNotEmpty) {
          //       // if (cubit.messagesList.isEmpty) {
          //       //   //on first message (add user to my_user collection of chat user)
          //       //   cubit.sendFirstMessage(
          //       //       widget.user, cubit.textController.text, Type.text);
          //       // } else {
          //       //   //simply send message
          //       //   cubit.sendMessage(
          //       //       widget.user, cubit.textController.text, Type.text);
          //       // }
          //       cubit.sendMessage(
          //           widget.user, cubit.textController.text, Type.text);
          //       cubit.textController.text = '';
          //     }
          //   },
          //   minWidth: 0,
          //   padding:
          //   const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
          //   shape: const CircleBorder(),
          //   color: Colors.green,
          //   child: const Icon(Icons.send, color: Colors.white, size: 28),
          //
        //






        ],
      ),
    );
  }
}

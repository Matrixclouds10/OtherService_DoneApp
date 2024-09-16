
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver_updated/gallery_saver.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';

import '../../../../core/helper/dialogs.dart';
import '../../../../core/helper/my_date_util.dart';
import '../../../../core/routing/navigation_services.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../data/models/chat/message_model.dart';
import '../../../logic/chat/chat_cubit.dart';
import '../../../logic/profile/profile_cubit.dart';


// for showing single message details
class MessageCard extends StatefulWidget {
   final bool isMe;
  const MessageCard({super.key, required this.message, required this.isMe});
  final MessageModel message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  ChatCubit cubit =ChatCubit.get();
  var mq =MediaQuery.of(NavigationService.navigationKey.currentContext!).size;

  @override
  Widget build(BuildContext context) {

    return InkWell(
        onLongPress: () {
          _showBottomSheet(widget.isMe);
        },
        child: widget.isMe ?_blueMessage(): _greenMessage() );
  }

  // sender or another user message
  Widget _blueMessage() {
    //update last read message if sender and receiver are different

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == TypeMessage.image
                ? mq.width * .03
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color:  Colors.orangeAccent.shade100,
                border: Border.all(color: Colors.orangeAccent.shade200),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Column(
              children: [
                 if(widget.message.type == TypeMessage.text)
                Text(
                  widget.message.msg,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                )
                else if (widget.message.type == TypeMessage.image)
                   ClipRRect(
                     borderRadius: BorderRadius.circular(15),
                     child: CachedNetworkImage(
                       imageUrl: widget.message.msg,
                       fit: BoxFit.cover,
                       placeholder: (context, url) => const Padding(
                         padding: EdgeInsets.all(8.0),
                         child: CircularProgressIndicator(strokeWidth: 2),
                       ),
                       errorWidget: (context, url, error) =>
                       const Icon(Icons.image, size: 70),
                     ),
                   )
                 else if (widget.message.type == TypeMessage.location)
                     Column(
                       children: [
                         SizedBox(
                           height: 130,
                           child: GoogleMap(
                             initialCameraPosition: CameraPosition(
                               target: LatLng(double.parse(widget.message.lat), double.parse(widget.message.long!)),
                               zoom: 14.4746,
                             ),
                             markers: {
                               Marker(
                                 markerId: MarkerId('1'),
                                 position: LatLng(double.parse(widget.message.lat), double.parse(widget.message.long!)),
                               ),
                             },
                           ),
                         ),
                         SizedBox(height: 4.0),
                         TextButton(
                           onPressed: () {
                             launch('https://www.google.com/maps/search/?api=1&query=${widget.message.lat},${widget.message.long}');
                           },
                           style: TextButton.styleFrom(
                             backgroundColor: Colors.black,
                           ),
                           child: CustomText("Open on Google map", pv: 0, white: true),
                         )
                       ],
                     )
              ],
            )
          ),
        ),
        Row(
          children: [
            //double tick blue icon for message read
            if (widget.message.read.isNotEmpty)
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20)
            else
              const Icon(Icons.done, color: Colors.grey, size: 20),
            //message time
            Padding(
              padding: EdgeInsets.only(right: mq.width * .01),
              child: Text(
                MyDateUtil.getFormattedTime(
                    context: context, time: widget.message.sentTime),
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),
          ],
        )

      ],
    );
  }

  // our or user message
  Widget _greenMessage() {
    if (widget.message.read.isEmpty) {
      cubit.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message time
        Row(
          children: [
            //for adding some space
            SizedBox(width: mq.width * .04),
            //  :



            //for adding some space
            const SizedBox(width: 2),

            //sent time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sentTime),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == TypeMessage.image
                ? mq.width * .03
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                border: Border.all(color: Colors.grey.shade600),
                //making borders curved
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            child:
            widget.message.type == TypeMessage.text ?
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                :
    widget.message.type == TypeMessage.image?
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ):
               Column(
      children: [
        SizedBox(
          height: 130,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(double.parse(widget.message.lat), double.parse(widget.message.long!)),
              zoom: 14.4746,
            ),
            markers: {
              Marker(
                markerId: MarkerId('1'),
                position: LatLng(double.parse(widget.message.lat), double.parse(widget.message.long!)),
              ),
            },
          ),
        ),
        SizedBox(height: 4.0),
        TextButton(
          onPressed: () {
            launch('https://www.google.com/maps/search/?api=1&query=${widget.message.lat},${widget.message.long}');
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          child: CustomText("Open on Google map", pv: 0, white: true),
        )
      ],
    )
          ),
        ),
      ],
    );
  }

  // bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    var context =NavigationService.navigationKey.currentContext!;
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView(
              shrinkWrap: true,
              children: [
                //black divider
                Container(
                  height: 4,
                  margin: EdgeInsets.symmetric(
                      vertical: mq.height * .015, horizontal: mq.width * .4),
                  decoration: BoxDecoration(
                      color: Colors.grey, borderRadius: BorderRadius.circular(8)),
                ),

                widget.message.type == TypeMessage.text
                    ?
                    //copy option
                    _OptionItem(
                        icon: const Icon(Icons.copy_all_rounded,
                            color: Colors.blue, size: 26),
                        name: 'Copy Text',
                        onTap: () async {
                          await Clipboard.setData(
                                  ClipboardData(text: widget.message.msg))
                              .then((value) {
                            //for hiding bottom sheet
                            Navigator.pop(context);

                            DialogsClass.showSnackbar(context, 'Text Copied!');
                          });
                        })
                    :
                    //save option
                    _OptionItem(
                        icon: const Icon(Icons.download_rounded,
                            color: Colors.blue, size: 26),
                        name: 'Save Image',
                        onTap: () async {
                          try {
                            await GallerySaver.saveImage(widget.message.msg,
                                    albumName: 'Cogina Chat')
                                .then((success) {
                              //for hiding bottom sheet
                              Navigator.pop(context);
                              if (success != null && success) {
                                DialogsClass.showSnackbar(
                                    context, 'Image Successfully Saved!');
                              }
                            });
                          } catch (e) {
                          }
                        }),

                //separator or divider
                if (isMe)
                  Divider(
                    color: Colors.black54,
                    endIndent: mq.width * .04,
                    indent: mq.width * .04,
                  ),

                //edit option
                if (widget.message.type == TypeMessage.text && isMe)
                  _OptionItem(
                      icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                      name: 'Edit Message',
                      onTap: () {
                        //for hiding bottom sheet
                        Navigator.pop(context);

                        _showMessageUpdateDialog();
                      }),

                //delete option
                if (isMe)
                  _OptionItem(
                      icon: const Icon(Icons.delete_forever,
                          color: Colors.red, size: 26),
                      name: 'Delete Message',
                      onTap: () async {
                        await cubit.deleteMessage(widget.message).then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);
                        });
                      }),

                //separator or divider
                Divider(
                  color: Colors.black54,
                  endIndent: mq.width * .04,
                  indent: mq.width * .04,
                ),

                //sent time
                _OptionItem(
                    icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                    name:
                        'Sent At: ${MyDateUtil.getMessageTime(time: widget.message.sentTime)}',
                    onTap: () {}),

                //read time
                _OptionItem(
                    icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                    name: widget.message.read.isEmpty
                        ? 'Read At: Not seen yet'
                        : 'Read At: ${MyDateUtil.getMessageTime( time: widget.message.read)}',
                    onTap: () {}),
              ],
            ),
          );
        });
  }

  //dialog for updating message content
  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;
    var context =NavigationService.navigationKey.currentContext!;
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: const Row(
                children: [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(' Update Message')
                ],
              ),

              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                      cubit.updateMessage(widget.message, updatedMsg);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}



//custom options card (for copy, edit, delete, etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var mq =MediaQuery.of(context).size;

    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: mq.width * .05,
              top: mq.height * .015,
              bottom: mq.height * .015),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}

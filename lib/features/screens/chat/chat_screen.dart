import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/logic/chat/chat_cubit.dart';
import 'package:weltweit/features/services/data/models/response/order/order.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/presentation/component/component.dart';

class ChatScreen extends StatefulWidget {
  final OrderModel orderModel;
  const ChatScreen({Key? key, required this.orderModel}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatCubit>().getChat(widget.orderModel.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.orderModel.provider?.name ?? '',
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
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
                            alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: message.isMe ? Colors.blue : Colors.grey,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                message.text,
                                style: TextStyle(color: Colors.white),
                              ),
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
                          onPressed: () {},
                          icon: Icon(Icons.camera_alt),
                        ),
                        SizedBox(width: 8.0),
                      ],
                    ),
                  ],
                ),
              );

              break;
            case BaseState.error:
              return ErrorLayout(errorModel: state.error);
          }
        },
      ),
    );
  }

  void _addMessage(Message message) async {
    try {
      _messageController.clear();
      await context.read<ChatCubit>().sendMessage(widget.orderModel.id, message.text);
      setState(() {
        _messages.add(message);
      });
    } catch (e) {
      AppSnackbar.show(context: context, message: e.toString(), type: SnackbarType.error);
    }
  }
}

class Message {
  final String text;
  final bool isMe;

  Message({required this.text, required this.isMe});
}

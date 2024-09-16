import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/data/datasource/remote/exception/error_widget.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/features/domain/usecase/chat_messages/chat_messages_usecase.dart';
import 'package:weltweit/features/domain/usecase/chat_send_message/chat_send_message_usecase.dart';
import 'package:weltweit/features/data/models/chat/chat_model.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

import '../../../core/notification/device_token.dart';
import '../../../core/notification/notification_access_token.dart';
import '../../../core/routing/navigation_services.dart';
import '../../data/models/auth/user_model.dart';
import '../../data/models/chat/chat_user.dart';
import '../../data/models/chat/message_model.dart';
import '../profile/profile_cubit.dart';
import 'package:http/http.dart';

import '../provider_profile/profile_cubit.dart';


part 'chat_state.dart';


class ChatCubit extends Cubit<ChatState> with WidgetsBindingObserver{
  final ChatMessagesUseCase chatUseCase;
  final ChatSendMessageUseCase chatSendMessageUseCase;
  ChatCubit(
    this.chatUseCase,
    this.chatSendMessageUseCase,
  ) : super(const ChatState()){
    WidgetsBinding.instance.addObserver(this);
    putToken();
  }

  String? fcmToken;
  void putToken()async{
    fcmToken =await getDeviceToken();
  }
  // Future<void> getChat(int orderId, {bool loading = true}) async {
  //   initStates();
  //   if (loading) emit(state.copyWith(state: BaseState.loading));
  //   final result = await chatUseCase(ChatMessagesParams(id: orderId));
  //   if (loading) {
  //     result.fold(
  //       (error) => emit(state.copyWith(state: BaseState.error, error: error)),
  //       (data) {
  //         emit(state.copyWith(state: BaseState.loaded, data: data));
  //       },
  //     );
  //   }
  //   if (!loading) {
  //     result.fold(
  //       (error) => null,
  //       (data) {
  //         emit(state.copyWith(data: data));
  //       },
  //     );
  //   }
  // }
  //
  // Future<bool> sendMessage(int id, String text) async {
  //   final result = await chatSendMessageUseCase(ChatSendMessageParams(id: id, message: text));
  //
  //   return result.fold(
  //     (error) {
  //       throw error.errorMessage ?? LocaleKeys.somethingWentWrong.tr();
  //     },
  //     (data) {
  //       return true;
  //     },
  //   );
  // }
  //
  // Future<bool> sendImage(int id, String path) async {
  //   final result = await chatSendMessageUseCase(ChatSendMessageParams(id: id, message: '', image: path));
  //
  //   return result.fold(
  //     (error) {
  //       throw error.errorMessage ?? LocaleKeys.somethingWentWrong.tr();
  //     },
  //     (data) {
  //       return true;
  //     },
  //   );
  // }

  // void initStates() {
  //   emit(state.copyWith(
  //     state: BaseState.initial,
  //     data: [],
  //     error: null,
  //   ));
  // }
  //
  // Future<bool> sendLocation(int id, double latitude, double longitude) async {
  //   final result = await chatSendMessageUseCase(ChatSendMessageParams(id: id, message: 'location', lat: latitude.toString(), lng: longitude.toString()));
  //   return result.fold(
  //     (error) {
  //       throw error.errorMessage ?? LocaleKeys.somethingWentWrong.tr();
  //     },
  //     (data) {
  //       return true;
  //     },
  //   );
  // }


  ///Firebase

  static final appContext =NavigationService.navigationKey.currentContext!;
  static ChatCubit get ()=>BlocProvider.of(appContext);
  ChatUser? me ;
  List<MessageModel> messagesList = [];
  bool showEmoji = false, isUploading = false;
  TextEditingController textController = TextEditingController();

  // for accessing cloud fireStore database
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> createChat(ChatUser chatUser) async {
    DocumentSnapshot<Map<String, dynamic>> chat = await fireStore
        .collection('chats')
        .doc(getConversationID(chatUser.id))
        .get();
    if (chat.exists) {
      // final CollectionReference<Map<String, dynamic>> ref = fireStore
      //     .collection('chats/${getConversationID(chatUser.id)}/messages/');
    }
    else {
      print('dsdfgggggggggggggggggggggggggg');
      final CollectionReference<Map<String, dynamic>> ref = fireStore
          .collection('chats/${getConversationID(chatUser.id)}/messages/');
      // قم بإنشاء مستند فارغ لبدء المجموعة إذا لم يكن هناك مستندات فيها بعد
      final docRef = ref.doc('initial_doc'); // يمكنك استخدام معرف فريد آخر هنا
      await docRef.set({}); // تعيين مستند فارغ
    }
  }

  // for accessing firebase storage
  FirebaseStorage storage = FirebaseStorage.instance;
  ChatUser? profile;
  // for getting current user info
  Future<void> getSelfInfo(ChatUser userModel) async {
    profile =userModel;
    await fireStore.collection('users').doc(userModel.id.toString()).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        // await getFirebaseMessagingToken();
        updateActiveStatus(true);
      } else {
        await createUser().then((value) => getSelfInfo(userModel));
      }
    });
  }

  // for creating a new user
  Future<void> createUser() async {
    print('createUser');
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        id: profile?.id.toString()??'',
        name: profile?.name??'',
        phone:profile?.phone??'',
        about: "Hey, I'm using Done Chat!",
        image: profile?.image??'',
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken:fcmToken??'');

    return await fireStore
        .collection('users')
        .doc(profile?.id.toString())
        .set(chatUser.toJson());
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.detached) {
      updateActiveStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      updateActiveStatus(true);
    }
  }



  // update online or last active status of user
  Future<void> updateActiveStatus(bool isOnline) async {
    fireStore.collection('users').doc(profile?.id!.toString()).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': fcmToken,
    });
  }

  ///Update Users Profile
  Future<void> updateUserProfile({String? name, String? phone, String? image}) async {
    final ref =fireStore.collection('users').
    doc(profile?.id!.toString());
    if(name!=null){
      ref.update({
        'name': name,
      });
    }
    if(phone!=null){
      ref.update({
        'phone': phone,
      });
    }
    if(image!=null){
      ref.update({
        'image': image,
      });
    }
  }

  ///************** Chat Screen Related APIs **************


  // useful for getting conversation id
  String getConversationID(String id) => profile!.id.toString().hashCode <= id.hashCode
      ? '${profile?.id!.toString()}_$id'
      : '${id}_${profile?.id!.toString()}';

  Future<void> openNewChat(String userId) async {
    await fireStore
        .collection('users')
        .doc(profile?.id.toString())
        .collection('my_users')
        .doc(userId.toString())
        .set({});

  }
  // for getting id's of known users from fireStore database
  Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return fireStore
        .collection('users')
        .doc(profile?.id.toString())
        .collection('my_users')
        .snapshots();

  }


  // for getting all users from fireStore database
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(List<String> userIds) {
    return fireStore
        .collection('users')
        .where('id',
        whereIn: userIds.isEmpty
            ? ['']
            : userIds) //because empty list throws an error
    // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfoAppBar(
      String userId) {
    return fireStore
        .collection('users')
        .where('id', isEqualTo: userId)
        .snapshots();
  }

  // for getting specific user info
  Future<ChatUser> getUserInfo(String userId) async {
    // 1. الحصول على الوثائق من Firestore باستخدام get() بدلاً من snapshots().
    final querySnapshot = await fireStore
        .collection('users')
        .where('id', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // 3. إذا كانت هناك وثيقة، استخدمها لإنشاء وإرجاع كائن ChatUser.
      final doc = querySnapshot.docs.first;
      return ChatUser.fromJson(doc.data());
    } else {
      // 4. إذا لم يتم العثور على المستخدم، يمكنك إرجاع null أو رمي استثناء.
      throw Exception('User not found');
    }
  }


  //get only last message of a specific chat
  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return fireStore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent_time', descending: true)
        .limit(1)
        .snapshots();
  }

// دالة لحساب عدد الرسائل غير المقروءة
  Future<void> getUnreadMessagesCount(String userId) async {
    try {
      // الحصول على معرف المحادثة
      String conversationId = getConversationID(userId);

      // استعلام لجلب الرسائل التي تحتوي على الحقل 'read' فارغ
      QuerySnapshot querySnapshot = await fireStore
          .collection('chats/$conversationId/messages/')
          .where('read', isEqualTo: '')
          .get();

      // حساب عدد الرسائل غير المقروءة
      int unreadCount = querySnapshot.docs.length+1;

      // عرض عدد الرسائل أو التعامل معه كما تريد
      getCountMessage(unreadCount);
    } catch (e) {
      print('حدث خطأ: $e');
    }
  }


  ///Message
  // for getting all messages of a specific conversation from fireStore database
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(String userId) {
    return fireStore
        .collection('chats/${getConversationID(userId)}/messages/')
        .orderBy('sent_time', descending: true)
        .snapshots();
  }
  // for adding an user to my user when first message is send
  Future<void> sendFirstMessage(ChatUser chatUser, String msg, TypeMessage type) async {
    await fireStore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(profile?.id.toString())
        .set({}).then((value) => sendMessageFirebase(chatUser, msg, type));

  }
  // for sending message
  Future<void> sendMessageFirebase(ChatUser chatUser, String msg, TypeMessage type) async {
    //message sending time (also used as id)
    print('sendMessageFirebase IMage');
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    //message to send
    final MessageModel message = MessageModel(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: profile?.id.toString()??'',
        sentTime: time, lat: '', long: '');
    final ref = fireStore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == TypeMessage.text ? msg : type == TypeMessage.image?'image':'location'));
  }

  Future<void> sendLocationFirebase(ChatUser chatUser, String lat,String long) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    //message to send
    final MessageModel message = MessageModel(
        toId: chatUser.id,
        msg: '',
        read: '',
        type: TypeMessage.location,
        fromId: profile?.id.toString()??'',
        sentTime: time, lat: lat, long: long);
    final ref = fireStore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, 'location'));
  }

  //update read status of message
  Future<void> updateMessageReadStatus(MessageModel message) async {
    fireStore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sentTime)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});

  }

  //send chat image
  Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {});

    //updating image in fireStore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessageFirebase(chatUser, imageUrl, TypeMessage.image);
  }

  //delete message
  Future<void> deleteMessage(MessageModel message) async {
    await fireStore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sentTime)
        .delete();

    if (message.type == TypeMessage.image) {
      await storage.refFromURL(message.msg).delete();
    }

  }

  //update message
  Future<void> updateMessage(MessageModel message, String updatedMsg) async {
    await fireStore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sentTime)
        .update({'msg': updatedMsg});
  }




  ///Notification
  // for sending push notification (Updated Codes)
  Future<void> sendPushNotification(ChatUser chatUser, String msg) async {

    try {

      final body = {
        "message": {
          "token": chatUser.pushToken,
          "notification": {
            "title": profile?.name??'', //our name should be send
            "body": msg,
          },
        }
      };

      // Firebase Project > Project Settings > General Tab > Project ID
      const projectID = 'done-8e8c2';

      // get firebase admin token
      final bearerToken = await NotificationAccessToken.getToken;

      // handle null token
      if (bearerToken == null) return;

      var res =await post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/$projectID/messages:send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
        },
        body: jsonEncode(body),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  int countMessage =1;
  void getCountMessage(int x){
    countMessage=x;
    emit(IncreaseCountState());
  }
  void removeCount(){
    countMessage = 1;
    emit(IncreaseCountState());
  }
  String? chatRoom;
  void getChatRoomName(String name){
    chatRoom =name;
    emit(IncreaseCountState());
  }
}

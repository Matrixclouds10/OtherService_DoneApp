class MessageModel {
  MessageModel({
    required this.toId,
    required this.msg,
    required this.read,
    required this.type,
    required this.lat,
    required this.long,
    required this.fromId,
    required this.sentTime,
  });

  late final String toId;
  late final String msg;
  late final String read;
  late final String fromId;
  late final String lat;
  late final String long;
  late final String sentTime;
  late final TypeMessage type;

  MessageModel.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    lat = json['lat'].toString();
    long = json['long'].toString();
    type = json['type'].toString() == TypeMessage.image.name ? TypeMessage.image :(json['type'].toString() == TypeMessage.text.name ?TypeMessage.text:TypeMessage.location) ;
    fromId = json['fromId'].toString();
    sentTime = json['sent_time'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['msg'] = msg;
    data['read'] = read;
    data['type'] = type.name;
    data['fromId'] = fromId;
    data['lat'] = lat;
    data['long'] = long;
    data['sent_time'] = sentTime;
    return data;
  }
}

enum TypeMessage { text, image,location }

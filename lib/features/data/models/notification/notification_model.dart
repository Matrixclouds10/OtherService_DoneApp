import 'package:equatable/equatable.dart';
import 'package:weltweit/features/data/models/order/order.dart';

// {
//               "title": "Pending new Order",
//               "message": "You have new pending Order for your approval",
//               "service_order_id": 65,
//               "order": {
//                   "id": 65,
//                   "date": "2023-05-23 01:29:00",
//                   "file": [
//                       "/storage/service_orders/images/scaled_3b4b53ab-ec3e-4a15-ba34-73b131fa32b26590831339077893995.jpg"
//                   ],
//                   "price": 500,
//                   "status_code": "client_done",
//                   "status": "Client done",
//                   "client": {
//                       "id": 229,
//                       "name": "عميل ٢٣-٥",
//                       "email": "walaayyyy@gmail.com",
//                       "mobile_number": "01060905252",
//                       "otp_verified": 1,
//                       "country_code": "20",
//                       "gender": "",
//                       "image": "/assets/media/users/blank.png",
//                       "country_id": null,
//                       "country": null
//                   },
//                   "provider": {
//                       "id": 376,
//                       "name": "walaa 23-5",
//                       "email": "walvjgk@gmail.com",
//                       "mobile_number": "01060905253",
//                       "country_code": "20",
//                       "otp_verified": 1,
//                       "approved": 1,
//                       "lat": "30.0600546",
//                       "lng": "31.3976525",
//                       "image": "/assets/media/users/blank.png",
//                       "distance": null,
//                       "services": [
//                           {
//                               "id": 23,
//                               "title": "كهرباء",
//                               "breif": "كهرباء",
//                               "image": "/storage/services/images/g6f6JIx2UwIrtgai89TLVIyiFbjTAvlM6roxInqA.png",
//                               "my_service": true
//                           },
//                           {
//                               "id": 24,
//                               "title": "صيانة مصاعد",
//                               "breif": "صيانة مصاعد",
//                               "image": "/storage/services/images/l9WL4WHXzyGhsCPdDXVai49ON8E6J48f9SsdKMKG.png",
//                               "my_service": true
//                           },
//                           {
//                               "id": 67,
//                               "title": "Transportation",
//                               "breif": "Delivery",
//                               "image": "/storage/services/images/BVQQgAlRnNlFkymlTTPgoHbbnzBYIz3llMHkeeZn.png",
//                               "my_service": true
//                           },
//                           {
//                               "id": 25,
//                               "title": "كاميرات",
//                               "breif": "كاميرات",
//                               "image": "/storage/services/images/z4mAJc3A0hutvKyH6p56KjAnGKQjXHIZONlc8fFd.png",
//                               "my_service": true
//                           },
//                           {
//                               "id": 26,
//                               "title": "صيانة جوال",
//                               "breif": "صيانة جوال",
//                               "image": "/storage/services/images/FkWhAc3mzuQGLGc6P9VVh4U85NJDgDqgcmV98BAO.png",
//                               "my_service": true
//                           },
//                           {
//                               "id": 27,
//                               "title": "حفر ودعم",
//                               "breif": "حفر ودعم",
//                               "image": "/storage/services/images/cBDXJTLQBKqnkKZTDJ0g1FFcPuxiezEB96eYE4e5.png",
//                               "my_service": true
//                           },
//                           {
//                               "id": 28,
//                               "title": "ستلايت",
//                               "breif": "ستلايت",
//                               "image": "/storage/services/images/hPgV2jMzocS153j4yYc3OE5QLEtKgGRbhGwFDpe1.png",
//                               "my_service": true
//                           },
//                           {
//                               "id": 29,
//                               "title": "تكييف",
//                               "breif": "تكييف",
//                               "image": "/storage/services/images/9RuvwBZuEd31740DFGM1NW4orrjyX8iWi4X4OLUe.png",
//                               "my_service": true
//                           }
//                       ],
//                       "rate_avg": "5",
//                       "rate_count": 1,
//                       "is_fav": "false",
//                       "is_online": "yes"
//                   },
//                   "service": {
//                       "id": 67,
//                       "title": "Transportation",
//                       "breif": "Delivery",
//                       "image": "/storage/services/images/BVQQgAlRnNlFkymlTTPgoHbbnzBYIz3llMHkeeZn.png",
//                       "my_service": true
//                   },
//                   "all_status": [
//                       "Pending",
//                       "Provider accept",
//                       "Provider finish",
//                       "Client done"
//                   ]
//               },
//               "type": "provider"
//           }
class NotificationModel extends Equatable {
  final String? title;
  final String? message;
  final int? serviceOrderId;
  final OrderModel? order;
  final String? type;

  const NotificationModel({
    required this.title,
    required this.message,
    required this.serviceOrderId,
    required this.order,
    required this.type,
  });

  @override
  List<Object?> get props => [title, message, serviceOrderId, order, type];

  NotificationModel copyWith({
    String? title,
    String? message,
    int? serviceOrderId,
    OrderModel? order,
    String? type,
  }) {
    return NotificationModel(
      title: title ?? this.title,
      message: message ?? this.message,
      serviceOrderId: serviceOrderId ?? this.serviceOrderId,
      order: order ?? this.order,
      type: type ?? this.type,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'],
      message: map['message'],
      serviceOrderId: map['service_order_id'],
      order: OrderModel.fromJson(map['order']),
      type: map['type'],
    );
  }

  @override
  bool get stringify => true;
}

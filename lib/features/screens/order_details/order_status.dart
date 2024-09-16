import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';
import '../../core/widgets/custom_text.dart';
import '../../data/models/order/order.dart';

class OrderStatusScreen extends StatelessWidget {
  final OrderModel orderModel;

  const OrderStatusScreen( {super.key,required this.orderModel,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(onTap: (){Navigator.pop(context);},child: Icon(Icons.arrow_back, color: Colors.black),),
        title: CustomText('Order Status'),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.favorite_border, color: Colors.black),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           Center(child: ClipRRect(
             borderRadius: BorderRadius.circular(0),
             child:  Image.asset('assets/images/logo.png',
             height: 100,
               width: 100,
             ),
           ),),
            SizedBox(height: 10),
            Text(
              'Order Status',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('Order id: ${orderModel.id??''}', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),
            // Order progress timeline
            ...orderModel.allStatus?.map((e) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                if(orderModel.allStatus?.indexOf(e)!=0)
                  buildDashedLine(),
                orderStep(
                  context,
                  icon: Icons.info,
                  title: e,
                  time: (e=='في الطريق' || e=='in_way')?orderModel.estimatedTime.toString():'',
                  distance: (e=='في الطريق' || e=='in_way')?orderModel.distance.toString():'',
                  isCompleted:orderModel.allStatus?.last==e?true: false,
                )
              ],
            )).toList()??[],
            // Expanded(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       orderStep(
            //         context,
            //         icon: Icons.fastfood,
            //         title: LocaleKeys.waitingForYourResponse.tr(),
            //         time: '09.10 AM, 9 May 2018',
            //         isCompleted: true,
            //       ),
            //       buildDashedLine(), orderStep(
            //         context,
            //         icon: Icons.fastfood,
            //         title: 'مقدم الخدمه قبل الطلب',
            //         time: '09.10 AM, 9 May 2018',
            //         isCompleted: true,
            //       ),
            //       buildDashedLine(),
            //       orderStep(
            //         context,
            //         icon: Icons.local_shipping,
            //         title: 'On the way',
            //         time: '09.15 AM, 9 May 2018',
            //         isCompleted: true,
            //         showTracking: true,
            //       ),
            //       buildDashedLine(),
            //       orderStep(
            //         context,
            //         icon: Icons.check_circle_outline,
            //         title: 'Delivered',
            //         time: 'Finish time in 3 min',
            //         isCompleted: false,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget orderStep(BuildContext context,
      {required IconData icon,
        required String title,
        required String time,
        required String distance,
        required bool isCompleted,
        bool showTracking = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 50),
        Column(
          children: [
            Icon(icon, color: isCompleted ? Colors.blue : Colors.grey),
          ],
        ),
        SizedBox(width: 0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      color: isCompleted ? Colors.blue : Colors.grey)),
              if(title.isNotEmpty) ...[
                SizedBox(height: 5),
                Text(time,
                    style: TextStyle(
                        color: isCompleted ? Colors.blue : Colors.grey)),
                SizedBox(height: 5),
                Text(distance,
                    style: TextStyle(
                        color: isCompleted ? Colors.blue : Colors.grey)),
                ],
              if (showTracking)
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('TRACKING'),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDashedLine() {
    return Container(
      margin: EdgeInsets.only(right: 50),
      height: 40,
      child: VerticalDivider(
        color: Colors.grey,
        thickness: 1,
        indent: 5,
        endIndent: 5,
      ),
    );
  }
}
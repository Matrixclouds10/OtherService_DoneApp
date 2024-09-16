import 'package:flutter/material.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';

import '../../../../presentation/component/images/custom_image.dart';

class UserDetailsWidget extends StatelessWidget {
  final UserDetails userDetails;
  const UserDetailsWidget({super.key, required this.userDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450.h,
      width: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
         ClipRRect(
           borderRadius: BorderRadius.circular(20),
           child:  Image.network( userDetails.image??'',
             height:450.h,
             width: double.infinity,
             errorBuilder: (e,r,t){
             return Image.asset(
                 'assets/images/holder.png',
                height:  450.h,
             );
             },
           ),
         ),
          Container(
            height: 450.h,
            width: double.infinity,
            decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [Colors.black87,Colors.black54,Colors.black45,Colors.black12]
              )
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Column(
              children: [
               SizedBox(height: 10,),
                Text(userDetails.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),),
                Text(userDetails.phone,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70
                  ),),

              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child:
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                Text(userDetails.status,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),),
              ),
            ),
          )
        ],
      ),
    );
  }
}
class UserDetails{
  final String image;
  final String name;
  final String phone;
  final String status;

  UserDetails({required this.image,required this.name,required this.phone,required this.status});
}
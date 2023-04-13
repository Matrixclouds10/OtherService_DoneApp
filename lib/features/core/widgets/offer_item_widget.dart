import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/decoration.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';

class OfferItemWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final bool isFavorite;
  const OfferItemWidget({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.isFavorite,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(color: Colors.white).radius(radius: 12),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                Image.asset(
                  imageUrl,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.white)
                        .radius(radius: 12),
                    child:
                        const Icon(Icons.favorite, color: Colors.red, size: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(title,
                    color: Colors.black54, align: TextAlign.start, pv: 0),
                CustomText(description,
                        maxLines: 2,
                        color: Colors.grey,
                        align: TextAlign.start,
                        pv: 0)
                    .footer(),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

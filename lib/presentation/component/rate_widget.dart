import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateWidget extends StatelessWidget {
  final num? initialRating;
  final ValueChanged<double>? onRatingUpdate;
  final bool ignoreGestures;
  final double iconSize;

  const RateWidget(
      {Key? key,
      this.initialRating,
      this.onRatingUpdate,
      this.ignoreGestures = true,
      this.iconSize = 15})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: (initialRating ?? 0).toDouble(),
      itemSize: iconSize,
      minRating: 1,
      ignoreGestures: ignoreGestures,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
      onRatingUpdate: onRatingUpdate ?? (rate) {},
      ratingWidget: RatingWidget(
        full: Icon(
          Icons.star_outlined,
          size: iconSize,
          color: Colors.amber,
        ),
        half: Icon(
          Icons.star_half,
          size: iconSize,
          color: Colors.amber,
        ),
        empty: Icon(
          Icons.star_border,
          size: iconSize,
          color: Colors.grey,
        ),
      ),
    );
  }
}

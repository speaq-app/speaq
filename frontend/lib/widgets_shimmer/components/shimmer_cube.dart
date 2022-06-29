import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:shimmer/shimmer.dart';

/// Width should be between 1 and 100; representing a percentage of the available space.
/// Height should be between 1 and 100; representing a percentage of the available space.
class ShimmerCube extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerCube({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Shimmer.fromColors(
      baseColor: spqLightGrey,
      highlightColor: spqWhite,
      child: SizedBox(
        width: deviceSize.width / 100 * width,
        height: deviceSize.width / 100 * height,
        child: const DecoratedBox(
          decoration: BoxDecoration(color: spqBlack),
        ),
      ),
    );
  }
}

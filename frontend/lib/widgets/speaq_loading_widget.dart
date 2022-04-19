import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/utils/all_utils.dart';

class SpqLoadingWidget extends StatelessWidget {
  final double radius;

  const SpqLoadingWidget(
    this.radius, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: spqWhite,
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: SpinKitWave(
                color: spqPrimaryBlue,
                size: radius,
              ),
            ),
          )
        ],
      ),
    );
  }
}

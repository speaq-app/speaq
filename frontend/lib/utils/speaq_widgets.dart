import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/utils/all_utils.dart';

class SpqLoadingWidget extends StatelessWidget {
  const SpqLoadingWidget(this.radius, {
    Key? key,
  }) : super(key: key);

  final double radius;

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
              child: SpinKitFoldingCube(
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

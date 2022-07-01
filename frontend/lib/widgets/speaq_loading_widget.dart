import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/utils/all_utils.dart';

/// Custom loading widget used after logging in to app.
class SpqLoadingWidget extends StatelessWidget {
  final double radius;
  final Widget? child;

  const SpqLoadingWidget(
    this.radius, {
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: spqWhite,
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: SpinKitWave(
              color: spqPrimaryBlue,
              size: radius,
            ),
          ),
          if (child != null)
            Expanded(
              child: child!,
            ),
        ],
      ),
    );
  }
}

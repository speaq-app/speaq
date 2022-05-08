import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:shimmer/shimmer.dart';

class SpqAppBarShimmer extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String spqImage = "assets/images/logo/speaq_logo.svg";

  const SpqAppBarShimmer({
    Key? key,
    required this.preferredSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height * 0.075,
      child: AppBar(
        centerTitle: true,
        toolbarHeight: preferredSize.height * 0.075,
        title: Center(
          child: InkWell(
            child: SvgPicture.asset(
              spqImage,
              height: preferredSize.height * 0.055,
              alignment: Alignment.center,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 4.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            color: spqPrimaryBlue,
            iconSize: 25,
            onPressed: () => {},
          )
        ],
        leading: Shimmer.fromColors(
          baseColor: spqLightGrey,
          highlightColor: spqWhite,
          child: IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const CircleAvatar(
              radius: 20,
            ),
          ),
        ),
      ),
    );
  }
}

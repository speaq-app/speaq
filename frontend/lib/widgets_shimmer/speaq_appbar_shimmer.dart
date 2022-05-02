import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:shimmer/shimmer.dart';

class SpqAppBarShimmer extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const SpqAppBarShimmer({
    Key? key,
    required this.preferredSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: spqLightGrey,
      highlightColor: spqWhite,
      child: SizedBox(
        height: preferredSize.height * 0.075,
        child: AppBar(
          centerTitle: true,
          toolbarHeight: preferredSize.height * 0.075,
          backgroundColor: spqWhite,
          elevation: 4.0,
          // title: Builder(
          //   builder: (context) {
          //     return Shimmer.fromColors(
          //       baseColor: spqLightGrey,
          //       highlightColor: spqWhite,
          //       child: IconButton(
          //         onPressed: null,
          //         icon: SvgPicture.asset("assets/images/logo/speaq_logo.svg"),
          //       ),
          //     );
          //   },
          // ),

          // leading: Shimmer.fromColors(
          //   baseColor: spqLightGrey,
          //   highlightColor: spqWhite,
          //   child: Container(
          //     width: 25,
          //     height: 25,
          //     decoration: const BoxDecoration(
          //       shape: BoxShape.circle,
          //       image: DecorationImage(
          //         fit: BoxFit.cover,
          //         image: NetworkImage(
          //             "https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg"),
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}

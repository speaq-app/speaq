import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets_shimmer/shimmer_profile_picture.dart';

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
        title: _buildSpeaqLogo(),
        backgroundColor: Colors.white,
        elevation: 4.0,
        actions: [_buildFilterButton()],
        leading: Padding(
          padding: EdgeInsets.only(
            left: preferredSize.width / 100 * 1.7,
          ),
          child: const ShimmerProfilePicture(diameter: 10),
        ),
        leadingWidth: preferredSize.width / 100 * 11.6,
      ),
    );
  }

  Widget _buildSpeaqLogo() {
    return Center(
      child: InkWell(
        child: SvgPicture.asset(
          spqImage,
          height: preferredSize.height * 0.055,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return IconButton(
      icon: const Icon(Icons.filter_alt_outlined),
      color: spqPrimaryBlue,
      iconSize: 25,
      onPressed: () => {},
    );
  }
}

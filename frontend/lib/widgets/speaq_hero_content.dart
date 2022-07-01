import 'package:flutter/material.dart';
import 'package:frontend/utils/speaq_styles.dart';

class SpqHeroContent extends StatelessWidget {
  final Widget child;
  final Widget content;
  final String tag;

  const SpqHeroContent({
    Key? key,
    required this.child,
    required this.content,
    required this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              _buildFullScreen(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        ),
      ),
      child: Hero(
        tag: tag,
        child: child,
      ),
    );
  }

  Scaffold _buildFullScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: spqBlack,
        ),
        backgroundColor: spqWhite,
      ),
      body: Container(
        color: spqWhite,
        child: Center(
          child: Hero(
            tag: tag,
            child: content,
          ),
        ),
      ),
    );
  }
}

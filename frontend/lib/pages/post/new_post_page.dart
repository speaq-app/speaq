import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/api/model/post.dart';
import 'package:frontend/blocs/post_bloc/post_bloc.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final PostBloc _postBloc = PostBloc();
  final dateNow = DateTime.now();
  final TextEditingController _postController = TextEditingController();

  bool emojiShowing = false;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    return SafeArea(
      child: BlocConsumer<PostBloc, PostState>(
          bloc: _postBloc,
          listener: (context, state) async {
            if (state is PostSaving) {

            }
          },
          builder: (context, state) {
            if (state is PostSaving) {
              return SpqLoadingWidget(
                  MediaQuery.of(context).size.shortestSide * 0.15,
              );

            } else if (state is PostSaved) {
              Navigator.popAndPushNamed(context, "home");
            }
            return Scaffold(
                appBar: SpqAppBar(
                  preferredSize: deviceSize,
                  actionList: [_buildSendPostButton()
                  ],
                ),
                body: _buildPostTextField(appLocale)
            );
          }
          ),
    );
  }

  Widget _buildPostTextField(AppLocalizations appLocale) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: SpqPostTextField(
          height: double.infinity,
          minLines: 30,
          controller: _postController,
          hintText: appLocale.newPost,
        ),
      );

  Widget _buildSendPostButton() => TextButton(
        onPressed: _savePost,
        child: Container(
          child: const Text("speaq"),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
          decoration: BoxDecoration(
              border: Border.all(color: spqPrimaryBlue, width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(16.0))),
        ),
      );

  void _savePost() {
    Navigator.pop(context);
    Post _post = Post(
        date: dateNow, description: _postController.text, resourceID: 1, id: 1);
    _postBloc.add(SavePost(userId: 1, post: _post));
  }

  @override
  void dispose() {
    super.dispose();
    _disposeController();
    _postBloc.close();
  }

  void _disposeController() {
    _postController.dispose();
  }
}

class SpqPostTextField extends StatelessWidget {
  const SpqPostTextField({
    Key? key,
    required this.controller,
    this.obscureText = false,
    this.isPassword = false,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.validator,
    this.keyboardType,
    this.minLines,
    this.maxLines,
    this.width,
    this.height = 56,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
    this.enabled = true,
  }) : super(key: key);

  final TextEditingController? controller;
  final bool obscureText;
  final bool isPassword;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? minLines;
  final int? maxLines;
  final double? width;
  final double? height;
  final EdgeInsets? contentPadding;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        minLines: minLines,
        maxLines: maxLines,
        obscureText: obscureText,
        readOnly: isPassword,
        keyboardType: keyboardType,
        enableSuggestions: !isPassword,
        autocorrect: !isPassword,
        controller: controller,
        validator: (value) => validator!(value),
        style: const TextStyle(color: spqBlack, fontSize: 16),
        enabled: enabled,
        decoration: InputDecoration(
          isDense: true,
          label: Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Text(hintText,
                style: const TextStyle(
                    color: spqLightGrey, fontWeight: FontWeight.w100)),
          ),
          contentPadding: contentPadding,
          labelStyle:
              const TextStyle(color: spqLightGrey, fontWeight: FontWeight.w100),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          alignLabelWithHint: true,
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: prefixIcon,
                )
              : null,
          suffixIcon: suffixIcon,
          fillColor: spqWhite,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: spqPrimaryBlue, width: 1.0),
          ),
          hintStyle: const TextStyle(
              color: spqLightGrey, fontSize: 16, fontWeight: FontWeight.w100),
          //hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: spqWhite, width: 1.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: spqWhite, width: 1.0),
          ),
          border: const OutlineInputBorder(),
        ),
        onTap: onTap,
      ),
    );
  }
}

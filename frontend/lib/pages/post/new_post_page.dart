import 'package:flutter/material.dart';
import 'package:frontend/widgets/all_widgets.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return SafeArea(child: Scaffold(appBar: SpqAppBar(title: const Text("Speaq"), preferredSize: deviceSize,),));
  }
}

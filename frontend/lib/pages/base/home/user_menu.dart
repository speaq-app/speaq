import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserMenu extends StatelessWidget{

  const UserMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildHeader(context),
          buildMenu(context),
        ],
      ),
    ),
  );

  Widget buildHeader(BuildContext context) => Container(

  );


  Widget buildMenu(BuildContext context) => Container(

  );

}


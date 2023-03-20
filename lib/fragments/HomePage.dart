import 'package:flutter/material.dart';
import 'package:garden_sms_app/navigation_drawer/NavigationDrawerMain.dart'
    as nav;

import 'dart:async';

class HomePageFragment extends StatefulWidget {
  const HomePageFragment({Key? key, required this.title}) : super(key: key);
  static const String routeName = '/HomePage';
  final String title;

  @override
  State<HomePageFragment> createState() => _HomePageFragmentState();
}

class _HomePageFragmentState extends State<HomePageFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: nav.NavigationDrawer(),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Pheonix01.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}

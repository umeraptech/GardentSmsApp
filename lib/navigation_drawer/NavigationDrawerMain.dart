import 'package:flutter/material.dart';
import 'package:garden_sms_app/navigation_drawer/NavigationDrawerMain.dart';
import 'package:garden_sms_app/widgets/CustomNavigationDrawer.dart';
import 'package:garden_sms_app/routes/PageRoutes.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(),
          createDrawerBodyItem(
            icon: Icons.home,text: 'Home Page', onTap: () =>
              Navigator.pushReplacementNamed(context, pageRoutes.home),),
          createDrawerBodyItem(
            icon: Icons.mail,text: 'Monthly Sms', onTap: () =>
              Navigator.pushReplacementNamed(context, pageRoutes.smsSpar),),
          createDrawerBodyItem(
            icon: Icons.mail,text: 'Sms Status', onTap: () =>
              Navigator.pushReplacementNamed(context, pageRoutes.smsStatus),),
          const Divider(),
          ListTile(
            title: const Text('App version 1.0.0'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Powered by EServices'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
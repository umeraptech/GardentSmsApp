import 'package:flutter/material.dart';
import 'package:garden_sms_app/navigation_drawer/NavigationDrawerMain.dart'
    as nav;
import 'dart:async';
import 'package:garden_sms_app/models/message_status.dart';
import 'package:garden_sms_app/services/sharedPreferences_service.dart';

class SmsStatusFragment extends StatefulWidget {
  const SmsStatusFragment({Key? key, required this.title}) : super(key: key);
  static const String routeName = '/SmsStatus';
  final String title;

  @override
  State<SmsStatusFragment> createState() => _SmsStatusFragmentState();
}

class _SmsStatusFragmentState extends State<SmsStatusFragment> {
  List<MessageStatus> listMsg = <MessageStatus>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      drawer: nav.NavigationDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/female01.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            color:Colors.black45 ,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                TextButton(
                    onPressed: (){
                      setState(() {
                        listMsg = SharedPreferencesService.getList();
                        listMsg.reversed;
                      });
                    },
                    child: const Text('Load Sms Status', style: TextStyle(
                      color: Colors.grey
                    ),)
                ),
                const SizedBox(height: 10.0,),
                TextButton(
                    onPressed: (){},
                    child: const Text('Clear Sms Status', style: TextStyle(
                        color: Colors.grey
                    ),)
                ),
                const SizedBox(height: 10.0,),
                Expanded(
                  child: ListView.builder(
                    itemCount: listMsg.length,
                    itemBuilder: (context, index){
                      final item = listMsg[index];
                      return Card(
                        elevation: 1.0,
                        color: Colors.transparent.withOpacity(0.50),
                        margin: const EdgeInsets.all(5.0,),
                        // color: Colors.transparent.withOpacity(0.50),
                        child: ListTile(
                          leading: const Icon(Icons.add_alert_rounded,color:Colors.greenAccent),
                          title: Text(
                            item.toString(),
                            style: const TextStyle(fontSize: 15,color:Colors.green),
                          ),
                        ),
                      );
                    }
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

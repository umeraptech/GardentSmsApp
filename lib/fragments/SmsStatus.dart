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
  List<MessageStatus> listMsg = [];
  late int _messageCounter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _messageCounter = 0;
    });
  }

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
            image: AssetImage("assets/images/background3.png"),
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
                        // listMsg = SharedPreferencesService.getList();
                        // for(MessageStatus mStatus in listMsg){
                        //   // print("total no of message ${mStatus.totalNoOfMessages}");
                        //   _messageCounter +=int.parse(mStatus.totalNoOfMessages);
                        // }
                        SharedPreferencesService.getData().then((value){
                          for (var messageStatus in value) {
                            // print("Time ${messageStatus.time}");
                            listMsg.add(messageStatus);
                          }
                          print("length of list ${listMsg.length}");
                          for(MessageStatus mStatus in listMsg){
                            // print("total no of message ${mStatus.totalNoOfMessages}");
                            _messageCounter +=int.parse(mStatus.totalNoOfMessages);
                          }
                        });

                      });
                    },
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
                    child: const Text('Load Sms Status', style: TextStyle(
                      color: Colors.green
                    ),)
                ),
                const SizedBox(height: 5.0,),
                TextButton(
                    onPressed: (){
                      setState(() {
                        _confirmDialog();
                      });
                    },
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
                    child: const Text('Clear Sms Status', style: TextStyle(
                        color: Colors.green
                    ),)
                ),
                const SizedBox(height: 5.0,),
                Center(
                  child: Text('Daily Message Counter: $_messageCounter', style: const TextStyle(
                      color: Colors.green
                  ),),
                ),
                const SizedBox(height: 5.0,),
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

  Future<void> _confirmDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white70,
          title: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.blueGrey,
              child: const Center(
                  child: Text(
                    'Confirmation Required',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ))),
          content: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: const <Widget>[
                Text(
                  'You are about to delete status click\nOk or Cancel to continue.',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.blueAccent,
                  ),
                ),
                Divider(color: Colors.blueGrey, thickness: 3.0,),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _removeList();
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red),
              ),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {


                Navigator.of(context).pop();
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.grey),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        );
      },
    );
  }

  void _removeList() {
    setState(() {
      listMsg.clear();
      print("no of elements ${listMsg.length}");

      SharedPreferencesService.deleteData();

    });
  }
}

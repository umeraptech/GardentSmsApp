import 'dart:async';
//import 'package:direct_sms/direct_sms.dart';
import 'package:flutter/material.dart';
import 'package:garden_sms_app/fragments/HomePage.dart';
import 'package:garden_sms_app/navigation_drawer/NavigationDrawerMain.dart'
    as nav;
import 'package:garden_sms_app/services/api_service.dart';
import 'package:garden_sms_app/models/monthly_spars.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:garden_sms_app/models/message_status.dart';
import 'package:garden_sms_app/services/sharedPreferences_service.dart';

class SmsSparsFragment extends StatefulWidget {
  const SmsSparsFragment({Key? key, required this.title}) : super(key: key);
  static const String routeName = '/SmsPage';
  final String title;

  @override
  State<SmsSparsFragment> createState() => _SmsSparsFragmentState();
}

class _SmsSparsFragmentState extends State<SmsSparsFragment> {
  final ApiService api = ApiService();
  late Future<List<MonthlySpars>> monthlySpars;
  late TextEditingController _month;
  final TextEditingController _staff = TextEditingController(text: "Anonymous");
  late TextEditingController _msg1 = TextEditingController();
  late TextEditingController _msg2 = TextEditingController();
  late String month;
  late List<MonthlySpars> listSpars;
  late double _progressValue;
  late int _noOfMessages;
  late int _currentMessage;
  List<MessageStatus> listMsg=[];
  int _messageCounter =0;
  late MessageStatus messageStatus;
  // var directSms = DirectSms();

  Future<void> loadSmsSpar() async {
    listSpars = await api.getSpars();
    print(listSpars);
  }

  Future<void> loadMessageStatus() async{
    setState(() {
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
  }

  _sendSms({required String number, required String message}) async {
    final permission = Permission.sms.request();
    if (await permission.isGranted) {
      // directSms.sendSms(message: message, phone: number);
    }

  }

  Future<void> loadElements() async {
    monthlySpars.then((spars) => {_noOfMessages = spars.length});
    month = (int.parse(DateTime.now().month.toString()) - 1).toString();
    switch (month) {
      case "1":
        _month = TextEditingController(text: "Jan");
        break;
      case "2":
        _month = TextEditingController(text: "Feb");
        break;
      case "3":
        _month = TextEditingController(text: "Mar");
        break;
      case "4":
        _month = TextEditingController(text: "Apr");
        break;
      case "5":
        _month = TextEditingController(text: "May");
        break;
      case "6":
        _month = TextEditingController(text: "Jun");
        break;
      case "7":
        _month = TextEditingController(text: "July");
        break;
      case "8":
        _month = TextEditingController(text: "Aug");
        break;
      case "9":
        _month = TextEditingController(text: "Sep");
        break;
      case "10":
        _month = TextEditingController(text: "Oct");
        break;
      case "11":
        _month = TextEditingController(text: "Nov");
        break;
      case "12":
        _month = TextEditingController(text: "Dec");
        break;
    }

    loadSmsSpar().then((_) {
      MonthlySpars msg = listSpars.first;
      String name = msg.getName().toUpperCase();
      String stdid = msg.getStudentId();
      String batch = msg.getBatch();
      String sem = msg.getSemester();
      String held = msg.getHeld();
      String attend = msg.getAttended();
      String flty = msg.getFaculty().toUpperCase();
      String leaves = msg.getLeave();
      String prog = msg.getProgress();
      String assign = msg.getAssignment();
      String internal = msg.getInternal();
      String mnt = _month.text;
      String msg1 =
          "The Academic record of $name,\nbatch $batch for the month of $mnt\nSID:$stdid\nSem:$sem\nClasses Held:$held\nAttended:$attend";
      String msg2 =
          "Leaves:$leaves\nProgress:$prog\nMarks:$internal\nAssignment:$assign\n*For details contact 03458885535";

      _msg1 = TextEditingController(text: msg1);
      _msg2 = TextEditingController(text: msg2);
    });
  }

  @override
  void initState() {
    // TODO: implement initState;
    _progressValue = 0.0;
    _currentMessage = 0;
    _noOfMessages = 0;
    monthlySpars = api.getSpars();

    loadElements();
    super.initState();
  }

  _sendSpars(String month) {
    setState(() {
      monthlySpars.then((spars) => {
            spars.forEach((mSpar) {
              String name = mSpar.getName().toUpperCase();
              String stdid = mSpar.getStudentId();
              String batch = mSpar.getBatch();
              String sem = mSpar.getSemester();
              String held = mSpar.getHeld();
              String attend = mSpar.getAttended();
              String flty = mSpar.getFaculty().toUpperCase();
              String leaves = mSpar.getLeave();
              String prog = mSpar.getProgress();
              String assign = mSpar.getAssignment();
              String internal = mSpar.getInternal();
              _currentMessage += 1;
              _progressValue = _currentMessage / _noOfMessages!;
              String msg1 =
                  "The Academic record of $name,  batch $batch for the month of $month\nSID:$stdid\nSem:$sem\nClasses Held:$held\nAttended:$attend";
              String msg2 =
                  "Leaves:$leaves\nProgress:$prog\nMarks:$internal\nAssignment:$assign\n*For details contact 03458885535";
             // print(msg1);

              _sendSms(number: mSpar.studentno, message: msg1);
              _sendSms(number: mSpar.studentno, message: msg2);

              // _sendSms(number: mSpar.studentno, message: msg1);
              // _sendSms(number: mSpar.studentno, message: msg2);
            })
          });

      var date = DateTime.now().toString();
      var dateParse = DateTime.parse(date);
      var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
      String sName = _staff.text;
      String sDate = formattedDate.toString();
      String sTime = DateFormat('hh:mm:ss a').format(DateTime.now()).toString();

      var messageStatus = MessageStatus(lastSenderName: sName, date: sDate, time: sTime, type: "Monthly Spars", totalNoOfMessages: _noOfMessages!.toString());

     // _messageCounter += _noOfMessages!;
      print(messageStatus.totalNoOfMessages);
      listMsg.add(messageStatus);
      print(listMsg.length);
      SharedPreferencesService.saveData(listMsg);

    });
    Timer(
        const Duration(seconds: 5),
            () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePageFragment(title: "Home Page"),
            )));
  }

  Future<void> _confirmDialog() async {
    String msg1 = _msg1.text;
    String msg2 = _msg2.text;
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
                'Message Preview',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ))),
          content: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Message 1:',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(
                  msg1,
                  style: const TextStyle(
                    fontSize: 10.0,
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                const Text(
                  'Message 2:',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(
                  msg2,
                  style: const TextStyle(
                    fontSize: 10.0,
                  ),
                ),
                const Divider(color: Colors.blueGrey, thickness: 3.0,),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.grey),
              ),
              child: const Text(
                'Exit',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: nav.NavigationDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _month,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Month',
                        hintText: 'Enter Month'),
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _staff,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Staff',
                        hintText: 'Enter Staff Name'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: TextButton(
                      onPressed: () {
                        _confirmDialog();
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.grey),
                      ),
                      child: const Text(
                        'Preview Message',
                        style: TextStyle(color: Colors.white70),
                      )),
                ),
                const SizedBox(width: 5.0,),
                Expanded(
                  flex: 1,
                  child: TextButton(
                      onPressed: () {
                        loadMessageStatus();
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.grey),
                      ),
                      child: const Text(
                        'Preview Status',
                        style: TextStyle(color: Colors.white70),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 5.0,
            ),
            TextButton(
                onPressed: () {
                  String month = _month.text.toUpperCase();
                  String msg1 = "";
                  String msg2 = "";
                  setState(() {
                    MonthlySpars obj = listSpars[0];
                    String name = obj.getName();
                    String stdid = obj.getStudentId();
                    String batch = obj.getBatch();
                    String sem = obj.getSemester();
                    String held = obj.getHeld();
                    String attend = obj.getAttended();
                    String leaves = obj.getLeave();
                    String prog = obj.getProgress();
                    String assign = obj.getAssignment();
                    String internal = obj.getInternal();
                    msg1 =
                        "The Academic record of $name,\nbatch $batch for the month of $month\nSID:$stdid\nSem:$sem\nClasses Held:$held\nAttended:$attend";
                    msg2 =
                        "Leaves:$leaves\nProgress:$prog\nMarks:$internal\nAssignment:$assign\n*For details contact 03458885535";

                    _sendSpars(month);
                    //_confirmDialog(msg1,msg2,month);
                  });
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.grey),
                ),
                child: const Text(
                  'Send Message',
                  style: TextStyle(color: Colors.white70),
                )),
            const SizedBox(
              height: 10.0,
            ),
            LinearProgressIndicator(
              backgroundColor: Colors.grey,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueGrey),
              value: _progressValue,
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text('Daily Message Counter: $_messageCounter'),
            const SizedBox(
              height: 5.0,
            ),
            Text('Progress: ${(_progressValue * 100).round()}%'),
            const SizedBox(
              height: 5.0,
            ),
            Text('Send: $_currentMessage of $_noOfMessages messages'),
            const SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: FutureBuilder<List<MonthlySpars>>(
                future: monthlySpars,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  // By default, show a loading spinner.
                  if (!snapshot.hasData) {
                    return const Expanded(
                      flex: 1,
                      child: Text('Loading Data'),
                    );
                  }
                  // Render student lists
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = snapshot.data[index] as MonthlySpars;
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(
                            data.toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
//https://meysam-mahfouzi.medium.com/understanding-future-in-dart-3c3eea5a22fb

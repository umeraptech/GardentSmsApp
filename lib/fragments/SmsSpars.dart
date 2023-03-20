import 'dart:async';
 import 'package:direct_sms/direct_sms.dart';
import 'package:flutter/material.dart';
import 'package:garden_sms_app/fragments/HomePage.dart';
import 'package:garden_sms_app/navigation_drawer/NavigationDrawerMain.dart'
    as nav;
import 'package:garden_sms_app/services/api_service.dart';
import 'package:garden_sms_app/models/monthly_spars.dart';
import 'package:permission_handler/permission_handler.dart';

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

  final TextEditingController _month = TextEditingController();
  late List<MonthlySpars> listSpars;
  late double _progressValue;
  int? _noOfMessages;
  late int _currentMesssage;
  var directSms = DirectSms();

  Future<void> LoadSmsSpar() async {
    listSpars = await api.getSpars();

    print(listSpars);
  }

  _sendSms({required String number, required String message}) async {
    final permission = Permission.sms.request();
    if (await permission.isGranted) {
      directSms.sendSms(message: message, phone: number);

    }
    Timer(const Duration(seconds: 4),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                HomePageFragment(title: "Home Page"),
            )
        )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    monthlySpars = api.getSpars();

    super.initState();

    _progressValue = 0.0;
    _currentMesssage = 0;
    _noOfMessages = 0;

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
            TextFormField(
              controller: _month,
              decoration: const InputDecoration(hintText: 'Enter Month'),
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Month is empty';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 5.0,
            ),
            TextButton(
                onPressed: () {
                  String month = _month.text.toUpperCase();
                  setState(() {
                    monthlySpars
                        .then((spars) => {_noOfMessages = spars.length ?? 0});
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
                        _currentMesssage += 1;
                        _progressValue = _currentMesssage / _noOfMessages!;
                        String internal = mSpar.getInternal();
                        String msg1 =
                            "The Academic record of $name,  batch $batch for the month of $month\nSID:$stdid\nSem:$sem\nClasses Held:$held\nAttended:$attend";
                        String msg2 =
                              "Leaves:$leaves\nProgress:$prog\nMarks:$internal\nAssignment:$assign\n*For details contact 03458885535";

                        print(msg1);
                        _sendSms(number: mSpar.studentno,message: msg1);
                        _sendSms(number: mSpar.studentno, message: msg2);
                      })
                    });
                  });
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.grey),
                ),
                child: const Text('Send Message')),
            const SizedBox(
              height: 10.0,
            ),
            LinearProgressIndicator(
              backgroundColor: Colors.grey,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
              value: _progressValue,
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text('Progress: ${(_progressValue * 100).round()}%'),
            const SizedBox(
              height: 5.0,
            ),
            Text('Send: $_currentMesssage of $_noOfMessages messages'),
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
                  } else {
                    //setState(() {

                    //});
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
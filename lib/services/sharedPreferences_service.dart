import 'package:garden_sms_app/models/message_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService{
  static Future saveData(List<MessageStatus> list) async{
    final preferences = await SharedPreferences.getInstance();
    final String encodedData = MessageStatus.encodeList(list);
    print(encodedData);
    await preferences.setString("messageStatusKey", encodedData);
    print("save done");
  }

  static Future<List<MessageStatus>> getData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String spList = prefs.getString("messageStatusKey").toString();
    print (spList);
    return MessageStatus.decodeList(spList);
  }

  static List<MessageStatus> getList() {
    List<MessageStatus> mList = [];
    getData().then((value){
      for (var messageStatus in value) {
        print("Time ${messageStatus.time}");
        mList.add(messageStatus);

      }
    });
    // print("length of list ${mList.length}");
    //print("lenght of list ${mList.length}");
    return mList;
  }

  static Future<void> deleteData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

}
import 'dart:convert';

class MessageStatus{
  String lastSenderName;
  String date;
  String time;
  String type;
  String totalNoOfMessages;

  MessageStatus(
      {
        required this.lastSenderName,
        required this.date,
        required this.time,
        required this.type,
        required this.totalNoOfMessages
      });

  static Map<String,dynamic> toMap (MessageStatus mt)=>{
    "lastSenderName": mt.lastSenderName,
    "date": mt.date,
    "time": mt.time,
    "type": mt.type,
    "totalNoOfMessages":mt.totalNoOfMessages
  };

  static String encodeList(lStatus)=>json.encode(
    lStatus.map<Map<String,dynamic>>((lStatuses) => MessageStatus.toMap(lStatuses)).toList(), );

  factory MessageStatus.fromJsonList(Map<String,dynamic> jsonData){
    return MessageStatus(
        lastSenderName: jsonData['lastSenderName'],
        date: jsonData['data'],
        time: jsonData['time'],
        type: jsonData['type'],
        totalNoOfMessages: jsonData['totalNoOfMessages']
    );
  }

  static List<MessageStatus> decodeList(String status) =>
      (json.decode(status) as List<dynamic>)
      .map<MessageStatus>((item)=>MessageStatus.fromJsonList(item))
      .toList();

}
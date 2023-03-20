import 'dart:convert';
import 'package:garden_sms_app/models/monthly_spars.dart';
import 'package:http/http.dart';

class ApiService{
  final String apiUrl = "https://www.azfamtech.com/api/sendspars";

  Future<List<MonthlySpars>> getSpars() async{
    Response res = await get(Uri.parse(apiUrl));

    if(res.statusCode == 200){
     // print(res.body);
      List<dynamic> body = jsonDecode(res.body);
      List<MonthlySpars> mspars = body.map((e) => MonthlySpars.fromJson(e)).toList();
      //print(mspars);
      return mspars;
    }else{
      throw "Failed to load members list";
    }
  }





}
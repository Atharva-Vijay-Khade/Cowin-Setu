import 'dart:convert';
import 'package:cowin_setu/PODO_By_Pin/podo_by_pin.dart';
import 'package:http/http.dart' as https;

class Network {
  
  static Future<PodoByPin> getData(String date,String pinCode) async {
     
    final response = await https.get(Uri.parse("https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=${pinCode}&date=${date}"));

    if(response.statusCode == 200)
    {
      return PodoByPin.fromJson(jsonDecode(response.body));
    }
    else 
    {
      PodoByPin error_podo = PodoByPin();
      error_podo.error = true;
      return error_podo;
    }


  }

}

import 'package:shared_preferences/shared_preferences.dart';

class cashhelper{
  static late SharedPreferences shared;
  static init() async => shared= await SharedPreferences.getInstance();
  static Future<void> savedata({
    required String key,
    required dynamic value,

  })async
  {
    if (value is String) await shared.setString(key, value);
    if (value is int) await shared.setInt(key, value);
    if (value is bool) await shared.setBool(key, value);
    if (value is double) await  shared.setDouble(key, value);
  }
  static Future<dynamic> removedata({required String key,}
      ) async {
    return await shared.remove(key);
  }
  static Future<String?> gettoken({required String key,}
      ) async {
    return await shared.getString(key);


  }
  static Future<int?> getid({required String key,}
      ) async {
    return await shared.getInt(key);


  }
}
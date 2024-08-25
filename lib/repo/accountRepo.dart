import 'package:shared_preferences/shared_preferences.dart';


class AccountRepo{
  late SharedPreferences sharedPreferences;
  AccountRepo({required this.sharedPreferences});

  String getUserData(String keys) {
    return sharedPreferences.getString(keys) ?? "";
  }

  Future<bool> setUserData(String keys, String userData){
    return sharedPreferences.setString(keys, userData);
  }

  Future<bool> removeUser(String keys) async {
    return await sharedPreferences.clear();
    // return await sharedPreferences.remove(keys);
  }


}



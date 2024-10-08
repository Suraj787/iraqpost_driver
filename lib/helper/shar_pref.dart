import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class Shared_Preferences {
  static SharedPreferences? prefs;
  static const String keyUserData = "UserData";
  static const String keyToken = "token";
  static const String barcodeDataList = "barcodeDataList";
  static const String packageId = "packageId";
  static const String trackData = "trackData";
  static const String trackData1 = "trackData1";
  static const String language = "language";
  static const String latKey = "latitude";
  static const String lngKey = "longitude";

  static Future prefSetInt(String key, int value) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setInt(key, value);
  }

  static Future<int?> prefGetInt(String key, int intDef) async {
    prefs = await SharedPreferences.getInstance();

    if (prefs!.getInt(key) != null) {
      return prefs!.getInt(key);
    } else {
      return intDef;
    }
  }

  static Future prefSetBool(String key, bool value) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setBool(key, value);
  }

  static Future<bool?> prefGetBool(String key, bool boolDef) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs!.getBool(key) != null) {
      return prefs!.getBool(key);
    } else {
      return boolDef;
    }
  }

  static Future prefSetString(String key, String value) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString(key, value);
  }

  static Future<String?> prefGetString(String key, String strDef) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs!.getString(key) != null) {
      return prefs!.getString(key);
    } else {
      return strDef;
    }
  }

  static Future prefSetStringList(String key, List<String> value) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setStringList(key, value);
  }

  static Future prefSaveSearchHistory(String location) async {
    List<String>? history =
        await Shared_Preferences.prefGetStringList('searchHistory');

    if (!history!.contains(location)) {
      history.add(location);
      await Shared_Preferences.prefSetStringList('searchHistory', history);
    }
  }

  static Future<List<String>?> getSearchHistory() async {
    return await Shared_Preferences.prefGetStringList('searchHistory');
  }

  static Future<List<String>?> prefGetStringList(String key) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs!.getStringList(key.toString()) != null) {
      return prefs!.getStringList(key);
    } else {
      return null;
    }
  }

  static Future prefSetDouble(String key, double value) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setDouble(key, value);
  }

  static Future<double?> prefGetDouble(String key, double douDef) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs!.getDouble(key) != null) {
      return prefs!.getDouble(key);
    } else {
      return douDef;
    }
  }

  static Future<void> saveLocation(double latitude, double longitude) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(latKey, latitude);
    await prefs.setDouble(lngKey, longitude);
  }

  static Future<Map<String, double?>> getLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble(latKey);
    double? longitude = prefs.getDouble(lngKey);

    return {
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  static Future clearAllPref() async {
    prefs = await SharedPreferences.getInstance();
    prefs!.clear();
  }

  static Future clearPref(String key) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.remove(key);
  }
}

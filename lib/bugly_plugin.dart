
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class BuglyPlugin {
  static const MethodChannel _channel =
      const MethodChannel('kaige.com/bugly_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  static Future<bool> init({
    String androidAppId,
    String iosAppId,
    bool logEnabled = false,
    String appChannel,
    String appVersion,
    String appPackageName,
    int appReportDelay = 10
  })async{
    assert((Platform.isAndroid && androidAppId != null) ||
        (Platform.isIOS && iosAppId != null));
    Map<String, dynamic> map = {
      'appId': Platform.isAndroid ? androidAppId : iosAppId,
      'logEnabled': logEnabled,
      'appChannel': appChannel,
      'appVersion': appVersion,
      'appPackageName': appPackageName,
      'appReportDelay': appReportDelay
    };
    return _channel.invokeMethod<bool>('init',map);
  }
  static Future<bool> setUserId(String userId){
    Map<String, dynamic> map = {
      'userId': userId
    };
    return _channel.invokeMethod<bool>('setUserId',map);
  }

  static Future<bool> setUserSceneTag(int userSceneTag){
    Map<String, dynamic> map = {
      'userSceneTag': userSceneTag
    };
    return _channel.invokeMethod<bool>('setUserSceneTag',map);
  }
  static Future<bool> putUserData(String userKey,String userValue)async{
    Map<String, dynamic> map = {
      'userKey': userKey,
      'userValue': userValue
    };
    return _channel.invokeMethod<bool>('putUserData',map);
  }
  static Future<bool> setIsDevelopmentDevice(bool isDebug){
    Map<String, dynamic> map = {
      'isDebug': isDebug
    };
    return _channel.invokeMethod<bool>('setIsDevelopmentDevice',map);
  }

  static Future<bool> postCatchedException({@required String message, @required String detail, Map extData})async{
    Map<String, dynamic> map = {
      'error_message': message,
      'error_detail': detail,
      'error_ext': extData
    };
    return _channel.invokeMethod<bool>('postCatchedException',map);
  }
}

#import "BuglyPlugin.h"
#import <Bugly/Bugly.h>

@implementation BuglyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"kaige.com/bugly_plugin"
            binaryMessenger:[registrar messenger]];
  BuglyPlugin* instance = [[BuglyPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if([@"init" isEqualToString:call.method]){
      [self init:call result:result];
  }else if([@"setUserId" isEqualToString:call.method]){
      [self setUserId:call result:result];
  }else if([@"setUserSceneTag" isEqualToString:call.method]){
      [self setUserSceneTag:call result:result];
  }else if([@"putUserData" isEqualToString:call.method]){
      [self putUserData:call result:result];
  }else if([@"postCatchedException" isEqualToString:call.method]){
      [self postCatchedException:call result:result];
  }
  else if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)init:(FlutterMethodCall*)call result:(FlutterResult)result{
    BuglyConfig* config = [[BuglyConfig alloc] init];
    config.channel = call.arguments[@"appChannel"];
    config.version = call.arguments[@"appVersion"];
    config.consolelogEnable = call.arguments[@"logEnabled"];
    [Bugly startWithAppId:call.arguments[@"appId"] config:config];
    result([NSNumber numberWithBool:YES]);
}

- (void)setUserId:(FlutterMethodCall*)call result:(FlutterResult)result{
    [Bugly setUserIdentifier:call.arguments[@"userId"]];
    result([NSNumber numberWithBool:YES]);
}

- (void)setUserSceneTag:(FlutterMethodCall*)call result:(FlutterResult)result{
    [Bugly setTag:[call.arguments[@"userSceneTag"] integerValue]];
    result([NSNumber numberWithBool:YES]);
}

- (void)putUserData:(FlutterMethodCall*)call result:(FlutterResult)result{
    [Bugly setUserValue:call.arguments[@"userKey"] forKey:call.arguments[@"userValue"]];
    result([NSNumber numberWithBool:YES]);
}

- (void)postCatchedException:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSString *crash_detail = call.arguments[@"error_detail"];
    NSString *crash_message = call.arguments[@"error_message"];
    if (crash_detail == nil || crash_detail == NULL) {
       crash_message = @"";
    }
    if ([crash_detail isKindOfClass:[NSNull class]]) {
        crash_message = @"";
    }
    NSArray *stackTraceArray = [crash_detail componentsSeparatedByString:@""];
    NSDictionary *data = call.arguments[@"error_ext"];
    if(data == nil){
      data = [NSMutableDictionary dictionary];
    }
    [Bugly reportExceptionWithCategory:5 name:@"Flutter自定义异常" reason:crash_message callStack:stackTraceArray extraInfo:data terminateApp:NO];
    result([NSNumber numberWithBool:YES]);
}
@end

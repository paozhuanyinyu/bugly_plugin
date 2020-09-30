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
  }else if([@"logV" isEqualToString:call.method]){
      [self logV:call result:result];
  }else if([@"logD" isEqualToString:call.method]){
      [self logD:call result:result];
  }else if([@"logI" isEqualToString:call.method]){
      [self logI:call result:result];
  }else if([@"logW" isEqualToString:call.method]){
      [self logW:call result:result];
  }else if([@"logE" isEqualToString:call.method]){
      [self logE:call result:result];
  }else if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)init:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSString* appId = call.arguments[@"appId"];
    BuglyConfig* config = [[BuglyConfig alloc] init];
    
    NSString *channel = call.arguments[@"appChannel"];
    BOOL isChannelEmpty = [self isBlankString:channel];
    if(!isChannelEmpty){
      config.channel = channel;
    }
    NSString *version = call.arguments[@"appVersion"];
    BOOL isVersionEmpty = [self isBlankString:version];
    if(!isVersionEmpty){
      config.version = version;
    }
    
    NSNumber *reportLevel = call.arguments[@"reportLevel"];
    if([reportLevel isEqualToNumber: [NSNumber numberWithInt:0]]){
        config.reportLogLevel = BuglyLogLevelSilent;
    }else if([reportLevel isEqualToNumber: [NSNumber numberWithInt:1]]){
        config.reportLogLevel = BuglyLogLevelError;
    }else if([reportLevel isEqualToNumber: [NSNumber numberWithInt:2]]){
        config.reportLogLevel = BuglyLogLevelWarn;
    }else if([reportLevel isEqualToNumber: [NSNumber numberWithInt:3]]){
        config.reportLogLevel = BuglyLogLevelInfo;
    }else if([reportLevel isEqualToNumber: [NSNumber numberWithInt:4]]){
        config.reportLogLevel = BuglyLogLevelDebug;
    }else if([reportLevel isEqualToNumber: [NSNumber numberWithInt:5]]){
        config.reportLogLevel = BuglyLogLevelVerbose;
    }
    NSNumber *logEnabled = call.arguments[@"logEnabled"];
    config.consolelogEnable = [logEnabled boolValue];
    [Bugly startWithAppId:appId config:config];
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

- (void)logV:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSString *log = call.arguments[@"log"];
    BLYLogv(BuglyLogLevelVerbose, log, nil);
    result([NSNumber numberWithBool:YES]);
}
- (void)logD:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSString *log = call.arguments[@"log"];
    BLYLogv(BuglyLogLevelDebug, log, nil);
    result([NSNumber numberWithBool:YES]);
}
- (void)logI:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSString *log = call.arguments[@"log"];
    BLYLogv(BuglyLogLevelInfo, log, nil);
    result([NSNumber numberWithBool:YES]);
}
- (void)logW:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSString *log = call.arguments[@"log"];
    BLYLogv(BuglyLogLevelWarn, log, nil);
    result([NSNumber numberWithBool:YES]);
}
- (void)logE:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSString *log = call.arguments[@"log"];
    BLYLogv(BuglyLogLevelError, log, nil);
    result([NSNumber numberWithBool:YES]);
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
    
}
@end

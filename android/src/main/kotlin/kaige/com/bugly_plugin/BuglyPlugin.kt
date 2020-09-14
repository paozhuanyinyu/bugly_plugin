package kaige.com.bugly_plugin

import android.content.Context
import androidx.annotation.NonNull
import com.tencent.bugly.crashreport.CrashReport
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** BuglyPlugin */
class BuglyPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "kaige.com/bugly_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method){
      "init" -> init(call,result)
      "setUserId" -> setUserId(call,result)
      "setUserSceneTag" -> setUserSceneTag(call,result)
      "putUserData" -> putUserData(call,result)
      "setIsDevelopmentDevice" -> setIsDevelopmentDevice(call,result)
      "postCatchedException" -> postCatchedException(call,result)
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
       else -> result.notImplemented()
    }
  }

  private fun init(call: MethodCall, result: MethodChannel.Result) {
    val appId = call.argument<String>("appId")
    val logEnabled = call.argument<Boolean>("logEnabled")
    val userStrategy: CrashReport.UserStrategy = CrashReport.UserStrategy(context)
    call.argument<String>("appChannel")?.let {
      userStrategy.appChannel = it
    }
    call.argument<String>("appVersion")?.let{
      userStrategy.appVersion = it
    }
    call.argument<String>("appPackageName")?.let{
      userStrategy.appPackageName = it
    }
    call.argument<Int>("appReportDelay")?.let {
      userStrategy.appReportDelay = it * 1000L
    }
    if(appId == null) CrashReport.initCrashReport(context) else CrashReport.initCrashReport(context, appId, logEnabled ?: false, userStrategy)
    result.success(true)
  }

  private fun setUserId(call: MethodCall, result: MethodChannel.Result) {
    CrashReport.setUserId(context, call.argument<String>("userId"))
    result.success(true)
  }

  private fun setUserSceneTag(call: MethodCall, result: MethodChannel.Result) {
    call.argument<Int>("userSceneTag")?.let {
      CrashReport.setUserSceneTag(context, it)
    }
    result.success(true)
  }

  private fun putUserData(call: MethodCall, result: MethodChannel.Result) {
    CrashReport.putUserData(context, call.argument<String>("userKey"),call.argument<String>("userValue"))
    result.success(true)
  }

  private fun setIsDevelopmentDevice(call: MethodCall, result: MethodChannel.Result){
    call.argument<Boolean>("isDebug")?.let {
      CrashReport.setIsDevelopmentDevice(context, it)
    }
    result.success(true)
  }
  private fun postCatchedException(call: MethodCall, result: MethodChannel.Result){
    CrashReport.postException(8, "Flutter自定异常", call.argument("error_message"),call.argument("error_detail"),call.argument("error_ext"))
    result.success(true)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

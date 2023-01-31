package com.bvidya

import android.util.Log
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
//    private val CHANNEL_LOCK = "channel.unlock";
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL_LOCK).setMethodCallHandler { call, result ->
//            val flag = call.argument<String>("state")
//            Log.e(CHANNEL_LOCK, "param:$flag");
//            if(flag=="ON"){
//                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O_MR1) {
//                    setShowWhenLocked(true);
//                    setTurnScreenOn(true);
//                } else {
//                    window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);
//                }
//            }else{
//                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O_MR1) {
//                    setShowWhenLocked(false);
//                    setTurnScreenOn(false);
//                } else {
//                    window.clearFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);
//                }
//            }
//
//        }
//    }


}

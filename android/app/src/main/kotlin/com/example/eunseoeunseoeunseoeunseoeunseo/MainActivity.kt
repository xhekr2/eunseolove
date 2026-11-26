package com.example.eunseoeunseoeunseoeunseoeunseo

import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "channel"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "toast" -> {
                    Toast.makeText(this, call.arguments as String, Toast.LENGTH_SHORT).show()
                    result.success(null)
                }
            }
        }
    }
}
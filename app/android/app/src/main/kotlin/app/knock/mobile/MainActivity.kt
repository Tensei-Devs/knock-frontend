package app.knock.mobile

import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Spec 016, R-18: la pantalla de la visita apaga la miniatura de la vista
        // de tareas recientes (Android 13+) para que el código no quede ahí.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "knock/pantalla")
            .setMethodCallHandler { llamada, resultado ->
                if (llamada.method == "capturaEnRecientes") {
                    val permitir = llamada.arguments as? Boolean ?: true
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        setRecentsScreenshotEnabled(permitir)
                    }
                    resultado.success(null)
                } else {
                    resultado.notImplemented()
                }
            }
    }
}

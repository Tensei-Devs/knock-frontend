package app.knock.mobile

import android.app.UiModeManager
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
                when (llamada.method) {
                    "capturaEnRecientes" -> {
                        val permitir = llamada.arguments as? Boolean ?: true
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                            setRecentsScreenshotEnabled(permitir)
                        }
                        resultado.success(null)
                    }
                    // El modo de noche de ESTA app (no el del teléfono): 0 sigue
                    // al sistema, 1 claro y 2 oscuro. Así el mapa nativo, que se
                    // oscurece con el modo de noche de Android, sigue el ajuste
                    // «Apariencia» de la app. Android 12 o superior.
                    "modoNoche" -> {
                        val modo = llamada.arguments as? Int ?: 0
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            getSystemService(UiModeManager::class.java)
                                ?.setApplicationNightMode(
                                    when (modo) {
                                        1 -> UiModeManager.MODE_NIGHT_NO
                                        2 -> UiModeManager.MODE_NIGHT_YES
                                        else -> UiModeManager.MODE_NIGHT_AUTO
                                    },
                                )
                        }
                        resultado.success(null)
                    }
                    else -> resultado.notImplemented()
                }
            }
    }
}

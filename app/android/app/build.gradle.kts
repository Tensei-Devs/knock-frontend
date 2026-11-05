import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Clave de Maps SDK for Android (TT-MOB-04). Nunca se versiona: se lee de
// android/local.properties (ignorado por git) o de la variable de entorno
// MAPS_API_KEY. Sin clave el valor es vacío: la app compila (como en el CI)
// y el mapa no carga.
val propiedadesLocales = Properties().apply {
    val archivo = rootProject.file("local.properties")
    if (archivo.exists()) {
        archivo.inputStream().use { load(it) }
    }
}
val mapsApiKey: String = propiedadesLocales.getProperty("MAPS_API_KEY")
    ?: System.getenv("MAPS_API_KEY")
    ?: ""

android {
    namespace = "app.knock.mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "app.knock.mobile"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["mapsApiKey"] = mapsApiKey
    }

    // Llave de subida a Google Play (spec 007, R-05). Solo llega por variables de entorno (en el CI salen de GitHub Secrets);
    // nunca se versiona. Sin ellas el build de release se firma con la llave de depuración, así `flutter run --release`
    // y el CI normal funcionan, y el workflow de publicación rechaza un AAB firmado con ella.
    val rutaLlave: String? = System.getenv("KNOCK_KEYSTORE_PATH")
    // Nombres cortos a propósito (kspw, keypw): la regla de Gitleaks `knock-android-keystore-password` pensada para
    // key.properties marca cualquier `storePassword = <6 o más caracteres>`, también la lectura de una variable de entorno.
    val kspw: String? = System.getenv("KNOCK_KEYSTORE_PASSWORD")
    val keypw: String? = System.getenv("KNOCK_KEY_PASSWORD")
    signingConfigs {
        if (rutaLlave != null) {
            create("subida") {
                storeFile = file(rutaLlave)
                storePassword = kspw
                keyAlias = System.getenv("KNOCK_KEY_ALIAS")
                keyPassword = keypw
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (rutaLlave != null) {
                signingConfigs.getByName("subida")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

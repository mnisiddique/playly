import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val debugKeystorePropertiesFile = rootProject.file("keys/debug-key.properties")
val debugKeystoreProperties = Properties()

// 2. Load the properties if the file exists
if (debugKeystorePropertiesFile.exists()) {
    debugKeystoreProperties.load(FileInputStream(debugKeystorePropertiesFile))
} else {
    // Optional: Print a warning if the file is missing
    logger.warn("Warning: debug-key.properties not found at ${debugKeystorePropertiesFile.path}")
}

val releaseKeystorePropertiesFile = rootProject.file("keys/upload-key.properties")
val releaseKeystoreProperties = Properties()

// 2. Load the properties if the file exists
if (releaseKeystorePropertiesFile.exists()) {
    releaseKeystoreProperties.load(FileInputStream(releaseKeystorePropertiesFile))
} else {
    // Optional: Print a warning if the file is missing
    logger.warn("Warning: debug-key.properties not found at ${releaseKeystorePropertiesFile.path}")
}

android {
    namespace = "mni.siddique.playly"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "mni.siddique.playly"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 27
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    signingConfigs {
        create("release") {
            keyAlias = releaseKeystoreProperties.getProperty("keyAlias")
            keyPassword = releaseKeystoreProperties.getProperty("keyPassword")
            storeFile = releaseKeystoreProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = releaseKeystoreProperties.getProperty("storePassword")
        }
        getByName("debug") {
            keyAlias = debugKeystoreProperties.getProperty("keyAlias")
            keyPassword = debugKeystoreProperties.getProperty("keyPassword")
            storeFile = debugKeystoreProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = debugKeystoreProperties.getProperty("storePassword")
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

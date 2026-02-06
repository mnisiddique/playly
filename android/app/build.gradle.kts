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


if (debugKeystorePropertiesFile.exists()) {
    debugKeystoreProperties.load(FileInputStream(debugKeystorePropertiesFile))
} else {
    // Optional: Print a warning if the file is missing
    logger.warn("Warning: debug-key.properties not found at ${debugKeystorePropertiesFile.path}")
}

val releaseKeystorePropertiesFile = rootProject.file("keys/upload-key.properties")
val releaseKeystoreProperties = Properties()


if (releaseKeystorePropertiesFile.exists()) {
    releaseKeystoreProperties.load(FileInputStream(releaseKeystorePropertiesFile))
} else {
    // Optional: Print a warning if the file is missing
    logger.warn("Warning: debug-key.properties not found at ${releaseKeystorePropertiesFile.path}")
}

android {
    namespace = "mni.siddique.playly"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "mni.siddique.playly"

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

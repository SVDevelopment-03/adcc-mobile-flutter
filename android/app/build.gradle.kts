import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    // Load signing properties from the Flutter project key.properties file.
    // This project stores the file at the repo root, but we also support an Android-local copy.
    val keystorePropertiesFile = rootProject.file("android/key.properties").takeIf { it.exists() }
        ?: rootProject.file("key.properties")
    val keystoreProperties = Properties()
    if (keystorePropertiesFile.exists()) {
        FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
    }
    namespace = "com.example.adcc"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11)
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.adcc"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Configure signing configs (reads from key.properties if present)
    signingConfigs {
        // Create a release signing config only if keystore settings are present.
        create("release") {
            val storeFilePath = keystoreProperties.getProperty("storeFile")
            val storePassword = keystoreProperties.getProperty("storePassword")
            val keyAlias = keystoreProperties.getProperty("keyAlias")
            val keyPassword = keystoreProperties.getProperty("keyPassword")

            val resolvedStoreFile = if (!storeFilePath.isNullOrEmpty()) {
                val projectRelative = rootProject.file(storeFilePath)
                if (projectRelative.exists()) projectRelative else file(storeFilePath)
            } else {
                null
            }

            if (resolvedStoreFile != null) {
                storeFile = resolvedStoreFile
            }
            if (!storePassword.isNullOrEmpty()) {
                this.storePassword = storePassword
            }
            if (!keyAlias.isNullOrEmpty()) {
                this.keyAlias = keyAlias
            }
            if (!keyPassword.isNullOrEmpty()) {
                this.keyPassword = keyPassword
            }
        }
    }

    buildTypes {
        release {
            // Use release signing config - MUST be configured in key.properties
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

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
    // Load signing properties from key.properties (kept out of VCS)
    val keystorePropertiesFile = rootProject.file("key.properties")
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
        // Create release signing config only if properties are provided
        create("release") {
            val storeFilePath = keystoreProperties.getProperty("storeFile")
            val storePassword = keystoreProperties.getProperty("storePassword")
            val keyAlias = keystoreProperties.getProperty("keyAlias")
            val keyPassword = keystoreProperties.getProperty("keyPassword")

            if (!storeFilePath.isNullOrEmpty()) {
                storeFile = file(storeFilePath)
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
            // Prefer release signing config when available, otherwise fall back to debug
            signingConfig = signingConfigs.findByName("release")?.takeIf { signingConfig ->
                // Ensure storeFile is set for release config
                try {
                    val storeFile = signingConfig.storeFile
                    storeFile != null && storeFile.exists()
                } catch (e: Exception) {
                    false
                }
            } ?: signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

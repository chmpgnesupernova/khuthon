plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.khuthon"
    compileSdk = flutter.compileSdkVersion

    // ✅ 명시적으로 필요한 NDK 버전 지정
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.khuthon"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ✅ Java 11 + Desugaring 설정
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Java 8+ 기능을 위한 Desugaring 라이브러리
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
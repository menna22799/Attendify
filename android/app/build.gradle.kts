plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.untitled2"
    compileSdk = flutter.compileSdkVersion  // Use the flutter SDK version for compileSdk

    ndkVersion = "27.2.12479018"  // Specify the correct NDK version

    compileOptions {
        isCoreLibraryDesugaringEnabled = true  // Enable desugaring for Java 8+ APIs
        sourceCompatibility = JavaVersion.VERSION_1_8  // Set Java source compatibility
        targetCompatibility = JavaVersion.VERSION_1_8  // Set Java target compatibility
    }
    kotlinOptions {
        jvmTarget = "1.8"  // or use "11" if that's your target version
    }




    defaultConfig {
        applicationId = "com.example.untitled2"
        minSdk = flutter.minSdkVersion  // Use Flutter's defined minimum SDK version
        targetSdk = flutter.targetSdkVersion  // Use Flutter's defined target SDK version
        versionCode = flutter.versionCode  // Use Flutter's version code
        versionName = flutter.versionName  // Use Flutter's version name
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")  // Use the debug signing config for release (make sure this is what you want)
        }
    }
}

flutter {
    source = "../.."  // Path to your Flutter source directory
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.2.0")  // Enable desugaring for Java 8+ features
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.ironfist.torfin"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "25.1.8937393"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.ironfist.torfin"
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val userHome = System.getProperty("user.home")
            val keystoreFilePath =
                "${userHome}\\AppData\\Local\\Temp\\keystore-repo\\upload-keystore.jks"
            val keyPropertiesFilePath =
                "${userHome}\\AppData\\Local\\Temp\\keystore-repo\\key.properties"

            val keystoreFile = File(keystoreFilePath)
            val keyPropertiesFile = File(keyPropertiesFilePath)

            if (!keystoreFile.exists()) {
                throw GradleException("Keystore file not found at: ${keystoreFile.absolutePath}")
            }

            if (!keyPropertiesFile.exists()) {
                throw GradleException("Key properties file not found at: ${keyPropertiesFile.absolutePath}")
            }

            val keyProperties = keyPropertiesFile.readLines()
                .associate { line ->
                    val (key, value) = line.split("=")
                    key.trim() to value.trim()
                }

            storeFile = keystoreFile
            storePassword = keyProperties["storePassword"]
                ?: throw GradleException("storePassword not found in key.properties")
            keyAlias = keyProperties["keyAlias"]
                ?: throw GradleException("keyAlias not found in key.properties")
            keyPassword = keyProperties["keyPassword"]
                ?: throw GradleException("keyPassword not found in key.properties")
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

tasks.register<Exec>("downloadKeystore") {
    workingDir = projectDir
    commandLine("cmd", "/c", "$projectDir/signer.bat")
}

afterEvaluate {
    tasks.named("assembleRelease").configure {
        dependsOn("downloadKeystore")
    }
}
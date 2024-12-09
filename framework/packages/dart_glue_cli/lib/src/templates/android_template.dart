import 'dart:io';

class AndroidProjectTemplate {
  Future<void> createAndroidProject(String projectName, Directory projectDir) async {
    final androidDir = Directory('${projectDir.path}/android');
    await androidDir.create(recursive: true);
    
    await _createProjectStructure(androidDir, projectName);
    await _createGradleFiles(androidDir, projectName);
    await _createBridgeFiles(androidDir, projectName);
    await _createResources(androidDir, projectName);
    
    print('Android project created successfully');
  }

  Future<void> _createProjectStructure(Directory androidDir, String projectName) async {
    final appDir = Directory('${androidDir.path}/app');
    await appDir.create();
    
    await Directory('${appDir.path}/src/main/java/com/${projectName.toLowerCase()}').create(recursive: true);
    await Directory('${appDir.path}/src/main/res/layout').create(recursive: true);
    await Directory('${appDir.path}/src/main/res/values').create(recursive: true);
    await Directory('${appDir.path}/src/main/cpp').create(recursive: true);
  }

  Future<void> _createBridgeFiles(Directory androidDir, String projectName) async {
    final javaDir = Directory('${androidDir.path}/app/src/main/java/com/${projectName.toLowerCase()}/bridge');
    await javaDir.create();

    // Create DNBridge.java
    await File('${javaDir.path}/DNBridge.java').writeAsString('''
package com.${projectName.toLowerCase()}.bridge;

import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import org.json.JSONObject;
import java.util.HashMap;
import java.util.Map;
import com.${projectName.toLowerCase()}.MainActivity;

public class DNBridge {
    private static DNBridge instance;
    private final MainActivity activity;
    private final Map<String, View> viewRegistry;
    
    private DNBridge(MainActivity activity) {
        this.activity = activity;
        this.viewRegistry = new HashMap<>();
    }
    
    public static synchronized DNBridge getInstance(MainActivity activity) {
        if (instance == null) {
            instance = new DNBridge(activity);
        }
        return instance;
    }

    public void createView(String viewId, String propsJson) {
        activity.runOnUiThread(() -> {
            try {
                JSONObject props = new JSONObject(propsJson);
                View view = new FrameLayout(activity);
                configureView(view, props);
                viewRegistry.put(viewId, view);
                activity.addView(view);
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }

    private void configureView(View view, JSONObject props) {
        try {
            if (props.has("style")) {
                JSONObject style = props.getJSONObject("style");
                // Apply styles
                if (style.has("width")) {
                    view.getLayoutParams().width = style.getInt("width");
                }
                if (style.has("height")) {
                    view.getLayoutParams().height = style.getInt("height");
                }
                // Add more style handling
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
''');

    // Create native bridge C++ file
    final cppDir = Directory('${androidDir.path}/app/src/main/cpp');
    await cppDir.create();

    await File('${cppDir.path}/native_bridge.cpp').writeAsString('''
#include <jni.h>
#include <string>

extern "C" {
    JNIEXPORT void JNICALL
    Java_com_${projectName.toLowerCase()}_bridge_DNBridge_createView(
        JNIEnv* env,
        jobject thiz,
        jstring viewId,
        jstring propsJson
    ) {
        const char* nativeViewId = env->GetStringUTFChars(viewId, 0);
        const char* nativeProps = env->GetStringUTFChars(propsJson, 0);
        
        // Process view creation
        
        env->ReleaseStringUTFChars(viewId, nativeViewId);
        env->ReleaseStringUTFChars(propsJson, nativeProps);
    }
}
''');

    // Create MainActivity with bridge support
    await File('${androidDir.path}/app/src/main/java/com/${projectName.toLowerCase()}/MainActivity.java').writeAsString('''
package com.${projectName.toLowerCase()};

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import com.${projectName.toLowerCase()}.bridge.DNBridge;

public class MainActivity extends Activity {
    private FrameLayout rootContainer;
    private DNBridge bridge;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        rootContainer = new FrameLayout(this);
        setContentView(rootContainer);
        
        bridge = DNBridge.getInstance(this);
    }
    
    public void addView(View view) {
        if (rootContainer != null) {
            rootContainer.addView(view);
        }
    }
}
''');

    // Create CMakeLists.txt
    await File('${androidDir.path}/app/CMakeLists.txt').writeAsString('''
cmake_minimum_required(VERSION 3.4.1)

add_library(native_bridge SHARED
            src/main/cpp/native_bridge.cpp)

target_link_libraries(native_bridge
                     android
                     log)
''');
  }

  Future<void> _createGradleFiles(Directory androidDir, String projectName) async {
    // Root build.gradle
    await File('${androidDir.path}/build.gradle').writeAsString('''
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:7.0.4'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
''');

    // settings.gradle
    await File('${androidDir.path}/settings.gradle').writeAsString('''
include ':app'
rootProject.name = "$projectName"
''');

    // app/build.gradle with C++ support
    await File('${androidDir.path}/app/build.gradle').writeAsString('''
plugins {
    id 'com.android.application'
}

android {
    compileSdkVersion 33
    
    defaultConfig {
        applicationId "com.${projectName.toLowerCase()}"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0"
    }
    
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    externalNativeBuild {
        cmake {
            path "CMakeLists.txt"
        }
    }
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.4.1'
    implementation 'com.google.android.material:material:1.5.0'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.3'
}
''');

    // Create gradle wrapper properties
    await Directory('${androidDir.path}/gradle/wrapper').create(recursive: true);
    await File('${androidDir.path}/gradle/wrapper/gradle-wrapper.properties').writeAsString('''
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\\://services.gradle.org/distributions/gradle-7.2-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
''');
  }

  Future<void> _createResources(Directory androidDir, String projectName) async {
    final appDir = Directory('${androidDir.path}/app');
    await File('${appDir.path}/src/main/res/values/strings.xml').writeAsString('''
<resources>
    <string name="app_name">$projectName</string>
</resources>
''');

    await File('${appDir.path}/src/main/AndroidManifest.xml').writeAsString('''
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.${projectName.toLowerCase()}">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.AppCompat">
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
''');
  }
}

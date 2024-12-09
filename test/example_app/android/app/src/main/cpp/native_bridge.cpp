#include <jni.h>
#include <string>

extern "C" {
    JNIEXPORT void JNICALL
    Java_com_example_app_bridge_DNBridge_createView(
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

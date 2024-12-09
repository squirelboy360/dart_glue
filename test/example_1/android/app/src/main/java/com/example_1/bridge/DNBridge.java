package com.example_1.bridge;

import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import org.json.JSONObject;
import java.util.HashMap;
import java.util.Map;
import com.example_1.MainActivity;

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

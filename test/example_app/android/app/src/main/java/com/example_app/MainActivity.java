package com.example_app;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import com.example_app.bridge.DNBridge;

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

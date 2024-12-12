package com.dartglue

import android.app.Activity
import android.os.Bundle

class MainActivity : Activity() {
    private lateinit var viewManager: NativeViewManager
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        viewManager = NativeViewManager(this)
        setContentView(viewManager.rootView)
    }
}

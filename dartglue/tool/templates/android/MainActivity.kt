package com.dartglue

import android.app.Activity
import android.os.Bundle
import android.widget.FrameLayout

class MainActivity : Activity() {
    private lateinit var viewManager: NativeViewManager

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        viewManager = NativeViewManager(this)
        setContentView(FrameLayout(this))
    }
}

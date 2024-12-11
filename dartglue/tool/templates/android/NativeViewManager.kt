package com.dartglue

import android.content.Context
import android.view.View
import android.widget.TextView
import android.widget.FrameLayout
import android.view.ViewGroup

class NativeViewManager(private val context: Context) {
    private val viewCache = mutableMapOf<Long, View>()
    private var handleCounter: Long = 1

    fun createView(type: Int): Long {
        val view = when (type) {
            0 -> FrameLayout(context)
            1 -> TextView(context)
            else -> throw IllegalArgumentException("Unknown view type: $type")
        }

        val handle = handleCounter++
        viewCache[handle] = view
        return handle
    }

    fun setViewProps(handle: Long, props: String) {
        val view = viewCache[handle] ?: return
        // Apply properties based on props string
    }
}

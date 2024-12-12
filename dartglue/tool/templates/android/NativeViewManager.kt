package com.dartglue

import android.content.Context
import android.view.View
import android.widget.TextView
import android.widget.FrameLayout
import android.view.ViewGroup
import org.json.JSONObject

class NativeViewManager(private val context: Context) {
    private val viewCache = mutableMapOf<Long, View>()
    private var handleCounter: Long = 1
    val rootView = FrameLayout(context)

    fun createView(type: Int): Long {
        val view = when (type) {
            0 -> FrameLayout(context)  // View
            1 -> TextView(context)     // Text
            else -> throw IllegalArgumentException("Unknown view type: $type")
        }
        
        val handle = handleCounter++
        viewCache[handle] = view
        return handle
    }

    fun updateViewProps(handle: Long, propsJson: String) {
        val view = viewCache[handle] ?: return
        val props = JSONObject(propsJson)
        
        // Update common properties
        props.optDouble("width", -1.0).takeIf { it > 0 }?.let {
            view.layoutParams?.width = it.toInt()
        }
        
        props.optDouble("height", -1.0).takeIf { it > 0 }?.let {
            view.layoutParams?.height = it.toInt()
        }
        
        // Handle text properties
        if (view is TextView) {
            props.optString("text")?.let { view.text = it }
            props.optDouble("fontSize", -1.0).takeIf { it > 0 }?.let {
                view.textSize = it.toFloat()
            }
        }
    }
}
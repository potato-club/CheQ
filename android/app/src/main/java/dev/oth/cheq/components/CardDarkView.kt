package dev.oth.cheq.components

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.PorterDuff
import android.graphics.PorterDuffXfermode
import android.graphics.RectF
import android.view.View

/**
 * Created By isaacjang on 2023/07/24
 */
class CardDarkView (private val context: Context, private val rect : RectF) : View(context, null) {
    private val paint = Paint().apply {
        setAlpha(0.4f)
        color = Color.BLACK
    }
    private val eraser = Paint().apply {
        isAntiAlias = true
        xfermode = PorterDuffXfermode(PorterDuff.Mode.CLEAR)
    }

    private val curve = 10f
    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)

//        canvas.drawRect(0f, 0f, width.toFloat(), height.toFloat(), paint)
        canvas.drawPaint(paint)
        canvas.drawRoundRect(rect, dpToPx(curve), dpToPx(curve), eraser)
    }

    private fun dpToPx(dp: Float): Float {
        val density = context.resources.displayMetrics.density
        return dp * density
    }
}
package dev.oth.cheq

import android.view.LayoutInflater
import android.view.View
import androidx.core.content.ContextCompat
import com.google.android.material.snackbar.Snackbar
import dev.oth.cheq.base.BaseActivity
import dev.oth.cheq.databinding.SnackCommonBinding
import dev.oth.cheq.utils.DLog
import dev.oth.cheq.viewModels.CommonSnackBarViewModel

/**
 * CommonSnackBar.make(this, "call SnackBar").show()
* */

class CommonSnackBar(
    private var activity: BaseActivity,
    private var view: View,
    private var duration: Int = 5000,
    private var message: String? = null,
    private var onClickPositive: ((CommonSnackBar)->Unit)? = null,
    private var onClickNegative: ((CommonSnackBar)->Unit)? = null,
) {

    fun setDuration(duration: Int) : CommonSnackBar {
        snackbar = Snackbar.make(view, "", duration)
        return this
    }

    fun setMessage(msg: String) : CommonSnackBar {
        DLog.w("msg :: $msg")
        DLog.w("vm.message.value :: ${vm.message.value}")
        vm.message.value = msg
        return this
    }

    fun setOnClickPositive(
        text: String = "확인",
        event: (CommonSnackBar)->Unit
    ) : CommonSnackBar {
        vm.positiveMsg.value = text
        onClickPositive = event
//        vm.activePositive.value = true
        return this
    }

    fun setOnClickNegative(
        text: String = "취소",
        event: (CommonSnackBar)->Unit
    ) : CommonSnackBar {
        DLog.w("setOnClickNegative")
        vm.negativeMsg.value = text
        onClickNegative = event
        vm.activeNegative.value = true
        return this
    }

    private val vm = CommonSnackBarViewModel(application = activity.application)

    private lateinit var snackbar : Snackbar
    private lateinit var snackbarLayout : Snackbar.SnackbarLayout

    private val snackbarBinding: SnackCommonBinding = SnackCommonBinding.inflate(LayoutInflater.from(activity))

    init {
        addDataObserver()
        initData()
        initObj()
    }

    private fun addDataObserver() {
        vm.message.observe(activity) {
            initObj()
        }
        vm.duration.observe(activity) {
            initObj()
        }

    }

    private fun initData() {
        vm.message.value = message
        vm.duration.value = duration

        snackbarBinding.vm = vm
        snackbarBinding.common = this
    }

    private fun initObj() {

        snackbar = Snackbar.make(view, vm.message.value ?: "", vm.duration.value!!)
//        snackbar = Snackbar.make(view, "", 3000)
        snackbarLayout = snackbar.view as Snackbar.SnackbarLayout
    }


    private fun initView() {
        with(snackbarLayout) {
            removeAllViews()
            setPadding(0, 0, 0, 0)
            setBackgroundColor(ContextCompat.getColor(context, android.R.color.transparent))
            addView(snackbarBinding.root, 0)
        }
    }

    fun show() : CommonSnackBar {
        if (isShowing()) {
            return this
        }
        initView()
        snackbar.show()
        return this
    }

    fun dismiss() {
        snackbar.dismiss()
    }

    fun isShowing() : Boolean {
        return snackbar.isShown
    }

    fun clickedByXmlPositive() {
        snackbar.dismiss()
        onClickPositive?.invoke(this)
    }

    fun clickedByXmlNegative() {
        snackbar.dismiss()
        onClickNegative?.invoke(this)
    }
}
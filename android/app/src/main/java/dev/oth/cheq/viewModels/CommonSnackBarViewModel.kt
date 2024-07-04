package dev.oth.cheq.viewModels

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.MutableLiveData

/**
 * @Creator: isaacJang-dev
 * @Date: 2023-01-19
 */
class CommonSnackBarViewModel(application: Application) : AndroidViewModel(application) {

    var message = MutableLiveData<String>("Default")
    var duration = MutableLiveData<Int>(5000)

//    var oneButton = MutableLiveData(false)
//    var activePositive = MutableLiveData(false)
    var activeNegative = MutableLiveData(false)

    var negativeMsg = MutableLiveData<String>()
    var positiveMsg = MutableLiveData<String>()

    var editable = MutableLiveData<Boolean>(false)

    private var checkable = MutableLiveData(false)
    private var key = MutableLiveData<Int>()

    fun setNeverShowAble(key: Int) {
        this.key.value = key
        checkable.value = true
    }

    fun getCheckAble() : Boolean {
        return this.checkable.value!!
    }

    init {
//        message.value = ""
//        oneButton.value = true
//        editable.value = false

        negativeMsg.value = "취소"
        positiveMsg.value = "확인"
    }
}
package dev.oth.cheq.responses

/**
 * Created By isaacjang on 2023/07/20
 */
class ResponseClass<T> private constructor(val classType: Class<T>) {
    var eventer: ((T) -> Unit)? = null
    private var errorEventer: ((dev.oth.cheq.responses.NetHeader) -> Unit)? = null

    fun setListener(listener: (T) -> Unit): ResponseClass<T> {
        this.eventer = listener
        return this
    }

    fun setErrorListener(listener: (dev.oth.cheq.responses.NetHeader) -> Unit): ResponseClass<T> {
        this.errorEventer = listener
        return this
    }


    companion object {
        fun <T> init(type: Class<T>): ResponseClass<T> {
            return ResponseClass(type)
        }
    }
}
package dev.oth.cheq.utils

/**
 * Created By isaacjang on 2023/07/24
 */
class DataSession {
    companion object {
        @Volatile
        private var instance: DataSession? = null

        @JvmStatic
        fun shared(): DataSession =
            instance ?: synchronized(this) {
                instance ?: DataSession().also {
                    instance = it
                }
            }
    }

    var lastBase64: String? = null
}
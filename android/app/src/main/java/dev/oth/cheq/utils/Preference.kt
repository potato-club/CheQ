package dev.oth.cheq.utils

/**
 * @Creator: isaacJang-dev
 * @Date: 2023-01-19
 */
import android.content.Context
import android.content.SharedPreferences
import android.text.TextUtils
import java.util.UUID

public class Preference {

    companion object {
        @Volatile private var instance: Preference? = null

        @JvmStatic fun shared(context: Context): Preference =
            instance ?: synchronized(this) {
                instance ?: Preference(context).also {
                    instance = it
                }
            }

        const val KEY_IS_FIRST_LOADING = "KEY_IS_FIRST_LOADING"

        const val KEY_FCM_TOKEN = "KEY_FCM_TOKEN"

        const val NULL_STRING = "NIL"
        const val NULL_DOUBLE = 3.1415926535897932111

        private const val KEY_UUID = "KEY_UUID"
    }

    private val PREFERENCE_FILE_NAME = "CHEQ"

    private var mSharedPreference: SharedPreferences
    private var mSharedEditor: SharedPreferences.Editor

    constructor(context: Context) {
        mSharedPreference = context.getSharedPreferences(PREFERENCE_FILE_NAME, Context.MODE_PRIVATE)
        mSharedEditor = mSharedPreference.edit()
    }

    fun isNull(key: String?) : Boolean {
        val str = getString(key) ?: return true
        if (TextUtils.isEmpty(str)) {
            return true
        }
        if (str == NULL_STRING) {
            return true
        }
        return false
    }

    fun getUUID(): String {
        var uuid = getString(KEY_UUID)
        if (isNull(getString(KEY_UUID))) {
            uuid = UUID.randomUUID().toString()
            put(key= KEY_UUID, uuid)
        }
        return uuid!!
    }

    fun getString(key: String?): String? {
        return getString(key, NULL_STRING)
    }

    fun getString(key: String?, def: String?): String? {
        return mSharedPreference.getString(key, def)
    }

    fun getInt(key: String?): Int {
        return getInt(key, -1)
    }

    fun getInt(key: String?, def: Int): Int {
        return mSharedPreference.getInt(key, def)
    }

    fun getBoolean(key: String?): Boolean {
        return getBoolean(key, false)
    }

    fun getBoolean(key: String?, def: Boolean): Boolean {
        return mSharedPreference.getBoolean(key, def)
    }

    fun put(key: String?, value: String?) : Boolean {
        return mSharedEditor.putString(key, value).commit()
    }

    fun put(key: String?, value: Int) : Boolean {
        return mSharedEditor.putInt(key, value).commit()
    }

    fun put(key: String?, value: Boolean): Boolean {
        return mSharedEditor.putBoolean(key, value).commit()
    }

    fun remove(key: String?) : Boolean {
        return mSharedEditor.remove(key).commit()
    }

    fun put(key: String?, value: HashSet<String>) : Boolean {
        return mSharedEditor.putStringSet(key, value).commit()
    }
}

package dev.oth.cheq.services

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.bluetooth.le.BluetoothLeScanner
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION
import android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK
import android.os.Binder
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import com.google.gson.Gson
import dev.oth.cheq.BuildConfig
import dev.oth.cheq.R
import dev.oth.cheq.utils.DLog

class NotiService : Service() {

    private lateinit var scanner: BluetoothLeScanner
    private val mBinder: IBinder = LocalBinder()

    private val CHANNEL_ID = 940714

    inner class LocalBinder : Binder() {
        val service: NotiService
            get() = this@NotiService
    }

    override fun onBind(intent: Intent?): IBinder {
        DLog.w()
        return mBinder
    }

    private var notification : Notification? = null
    private fun foregroundNotificationBuilder() : NotificationCompat.Builder {
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val  mChannelName = getString(R.string.app_name)
            val notificationManager = this.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            val notificationChannel = NotificationChannel(
                CHANNEL_ID.toString(),
                mChannelName,
                NotificationManager.IMPORTANCE_MAX
            )
            notificationManager.createNotificationChannel(notificationChannel)
            NotificationCompat.Builder(this, notificationChannel.id)
        } else {
            NotificationCompat.Builder(this)
        }

        builder
            .setSmallIcon(R.mipmap.ic_launcher_round)
            .setContentTitle("CheQ")
            .setContentText("Beacon 추적이 진행중입니다.")
            .setPriority(NotificationCompat.PRIORITY_MAX)

        return builder
    }


    override fun onCreate() {
        super.onCreate()
        DLog.w()
        startForegroundService()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        DLog.w()
        return START_STICKY
    }

    override fun onDestroy() {
        DLog.w()
        stopForeground(STOP_FOREGROUND_REMOVE)
        super.onDestroy()
    }

    private fun startForegroundService() {
        DLog.w()
        notification = foregroundNotificationBuilder().build()
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            startForeground(940714, notification)
        } else {
            startForeground(940714, notification!!,
                FOREGROUND_SERVICE_TYPE_LOCATION)
        }
    }

    fun startScan(btAdapter: BluetoothAdapter) {

//        var btManager: BluetoothManager? = null
//        var btAdapter: BluetoothAdapter? = null
        DLog.w()
        scanner = btAdapter.getBluetoothLeScanner()
        val setting = ScanSettings.Builder()
            .setScanMode(ScanSettings.SCAN_MODE_LOW_POWER)
            .build()

//        val filter = ScanFilter.Builder()
//            .setDeviceAddress("54:6C:0E:B7:D1:04")
//            .build()

        //특정 device 만 scan
//        scanner.startScan(mutableListOf(null) , setting, scanCallback)
        scanner.startScan(scanCallback)
    }

    private val scanCallback = object : ScanCallback() {
        override fun onScanResult(callbackType: Int, result: ScanResult?) {
            super.onScanResult(callbackType, result)
//            DLog.i("[type=$callbackType] $result")
            if (result == null) {
                return
            }
//            DLog.w(gson.toJson(result.scanRecord))
//            DLog.w(result.scanRecord?.advertiseFlags)
            if (result.scanRecord != null) {
                onLeScan(result.device, result.rssi, result.scanRecord!!.bytes)
            }
            else {
                DLog.w("scanData is null")
            }
        }

        override fun onScanFailed(errorCode: Int) {
            super.onScanFailed(errorCode)
        }

        fun onLeScan(device: BluetoothDevice, rssi: Int, scanRecord: ByteArray) {
            var startByte = 2
            var patternFound = false
            while (startByte <= 5) {
                if (scanRecord[startByte + 2].toInt() and 0xff == 0x02 &&
                    scanRecord[startByte + 3].toInt() and 0xff == 0x15) {
                    patternFound = true
                    break
                }
                startByte++
            }

            if (patternFound) {
                // Convert to hex String
                val uuidBytes = ByteArray(16)
                System.arraycopy(scanRecord, startByte + 4, uuidBytes, 0, 16)
                val hexString = bytesToHex(uuidBytes)

                // Here is your UUID
                val uuid = "${hexString.substring(0, 8)}-${hexString.substring(8, 12)}-${hexString.substring(12, 16)}-${hexString.substring(16, 20)}-${hexString.substring(20, 32)}"

                // Here is your Major value
                val major = (scanRecord[startByte + 20].toInt() and 0xff) * 0x100 + (scanRecord[startByte + 21].toInt() and 0xff)

                // Here is your Minor value
                val minor = (scanRecord[startByte + 22].toInt() and 0xff) * 0x100 + (scanRecord[startByte + 23].toInt() and 0xff)

                DLog.w("parsing device : [$uuid][$major][$minor][$rssi]")
            }
            else {
                DLog.d("wrong pattern : ${device.name}")
            }
        }

        /**
         * bytesToHex method
         * Found on the internet
         * http://stackoverflow.com/a/9855338
         */
        private val hexArray = "0123456789ABCDEF".toCharArray()
        private fun bytesToHex(bytes: ByteArray): String {
            val hexChars = CharArray(bytes.size * 2)
            for (j in bytes.indices) {
                val v = bytes[j].toInt() and 0xFF
                hexChars[j * 2] = hexArray[v ushr 4]
                hexChars[j * 2 + 1] = hexArray[v and 0x0F]
            }
            return String(hexChars)
        }

    }

    public fun stopScan() {
        scanner.stopScan(scanCallback)
    }


}
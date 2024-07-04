package dev.oth.cheq.services

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.bluetooth.BluetoothAdapter
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
            DLog.i("[type=$callbackType] $result")
        }

        override fun onScanFailed(errorCode: Int) {
            super.onScanFailed(errorCode)
        }
    }

    public fun stopScan() {
        scanner.stopScan(scanCallback)
    }


}
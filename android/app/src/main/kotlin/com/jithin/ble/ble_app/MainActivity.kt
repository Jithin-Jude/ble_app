package com.jithin.ble.ble_app

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val PAIRING_CHANNEL = "com.jithin.ble/pairing"
    private val EVENTS_CHANNEL = "com.jithin.ble/pairing/events"

    private var eventSink: EventChannel.EventSink? = null
    private var bluetoothAdapter: BluetoothAdapter? = null

    private val bondStateReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == BluetoothDevice.ACTION_BOND_STATE_CHANGED) {
                val state = intent.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, BluetoothDevice.ERROR)
                eventSink?.success(state)
            }
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        bluetoothAdapter = bluetoothManager.adapter

        // Method Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PAIRING_CHANNEL).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            val macAddress = call.argument<String>("macAddress")
            if (macAddress == null) {
                result.error("INVALID_ARGUMENT", "MAC Address is required", null)
                return@setMethodCallHandler
            }

            val device = try {
                bluetoothAdapter?.getRemoteDevice(macAddress)
            } catch (e: Exception) {
                result.error("INVALID_MAC_ADDRESS", "Invalid MAC Address: $macAddress", null)
                return@setMethodCallHandler
            }

            if (device == null) {
                result.error("DEVICE_NOT_FOUND", "Bluetooth device not found for MAC: $macAddress", null)
                return@setMethodCallHandler
            }

            when (call.method) {
                "getPairState" -> {
                    result.success(device.bondState)
                }
                "pair" -> {
                    val success = device.createBond()
                    result.success(success)
                }
                "unPair" -> {
                    try {
                        val method = device.javaClass.getMethod("removeBond")
                        val success = method.invoke(device) as Boolean
                        result.success(success)
                    } catch (e: Exception) {
                        result.error("REFLECTION_ERROR", "Failed to call removeBond: ${e.message}", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Event Channel
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENTS_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    val filter = IntentFilter(BluetoothDevice.ACTION_BOND_STATE_CHANGED)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        registerReceiver(bondStateReceiver, filter, Context.RECEIVER_EXPORTED)
                    } else {
                        registerReceiver(bondStateReceiver, filter)
                    }
                }

                override fun onCancel(arguments: Any?) {
                    try {
                        unregisterReceiver(bondStateReceiver)
                    } catch (e: Exception) {
                        // Ignore if not registered
                    }
                    eventSink = null
                }
            }
        )
    }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';

class BluetoothService extends ChangeNotifier {
  BluetoothConnection? _connection;
  BluetoothDevice? connectedDevice;
  bool isConnected = false;

  // Store data log as timestamped entries
  final List<String> _dataLog = [];
  final StreamController<String> _dataController =
      StreamController<String>.broadcast();

  Stream<String> get dataStream => _dataController.stream;
  List<String> get dataLog => List.unmodifiable(_dataLog);

  // Connect to a Bluetooth device
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      // If connected to a different device, disconnect first
      if (isConnected && connectedDevice?.address != device.address) {
        await disconnect();
      }

      if (_connection != null) {
        // Already connected to this device, do nothing
        return;
      }

      _connection = await BluetoothConnection.toAddress(device.address);
      connectedDevice = device;
      isConnected = true;
      notifyListeners();

      _connection!.input?.listen(_onDataReceived).onDone(() {
        _connection = null;
        isConnected = false;
        // Keep connectedDevice as last tried device to allow reconnect
        notifyListeners();
      });
    } catch (e) {
      _connection = null;
      isConnected = false;
      connectedDevice = null;
      notifyListeners();
      rethrow;
    }
  }

  // Disconnect from current device
  Future<void> disconnect() async {
    await _connection?.close();
    _connection = null;
    isConnected = false;
    // Keep connectedDevice intact for reconnect
    notifyListeners();
  }

  // Called on incoming Bluetooth data
  void _onDataReceived(Uint8List data) {
    final incoming = String.fromCharCodes(data);
    final timestamp = DateFormat('HH:mm:ss').format(DateTime.now());

    // Store with timestamp prefix to preserve original receive time
    final timestampedEntry = '[$timestamp] $incoming';

    _dataLog.add(timestampedEntry);
    _dataController.add(timestampedEntry);
    notifyListeners();
  }

  // Clear data log
  void clearLog() {
    _dataLog.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _dataController.close();
    _connection?.dispose();
    super.dispose();
  }
}

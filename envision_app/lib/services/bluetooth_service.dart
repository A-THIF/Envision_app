import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/material.dart';

class BluetoothService extends ChangeNotifier {
  BluetoothConnection? _connection;
  BluetoothDevice? _connectedDevice;
  bool _isConnected = false;
  bool _isConnecting = false;

  // Stream for incoming data
  final StreamController<String> _dataController = StreamController.broadcast();
  Stream<String> get dataStream => _dataController.stream;

  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  BluetoothDevice? get connectedDevice => _connectedDevice;

  // Connect to device
  Future<void> connectToDevice(BluetoothDevice device) async {
    if (_isConnecting || _isConnected) return;

    _isConnecting = true;
    notifyListeners();

    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      _connectedDevice = device;
      _isConnected = true;
      _isConnecting = false;
      notifyListeners();

      // Listen for incoming data
      _connection!.input
          ?.listen((data) {
            String text = String.fromCharCodes(data).trim();
            _dataController.add(text);
          })
          .onDone(() {
            _isConnected = false;
            _connectedDevice = null;
            notifyListeners();
          });
    } catch (e) {
      _isConnected = false;
      _connectedDevice = null;
      _isConnecting = false;
      notifyListeners();
      print('Cannot connect: $e');
    }
  }

  // Disconnect
  Future<void> disconnect() async {
    await _connection?.close();
    _connection = null;
    _connectedDevice = null;
    _isConnected = false;
    notifyListeners();
  }

  void disposeService() {
    _dataController.close();
    _connection?.dispose();
    _connection = null;
    _connectedDevice = null;
  }
}

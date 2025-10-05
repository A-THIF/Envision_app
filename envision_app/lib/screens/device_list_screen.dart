import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import '../services/bluetooth_service.dart';
import '../widgets/device_tile.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  List<BluetoothDevice> bondedDevices = [];
  bool _isBluetoothReady = false;
  bool _isLoading = false;
  bool _bluetoothRequested = false;

  @override
  void initState() {
    super.initState();
    initBluetooth();
  }

  Future<void> initBluetooth() async {
    // Always reset this so user can trigger enabling bluetooth multiple times
    _bluetoothRequested = false;

    bool isEnabled = (await FlutterBluetoothSerial.instance.isEnabled) ?? false;

    if (!isEnabled && !_bluetoothRequested) {
      _bluetoothRequested = true;

      bool turnedOn =
          (await FlutterBluetoothSerial.instance.requestEnable()) ?? false;
      if (!mounted) return;

      if (!turnedOn) {
        setState(() {
          _isBluetoothReady = false;
        });
        return;
      }
    }

    if (!mounted) return;
    setState(() {
      _isBluetoothReady = true;
    });

    await getPairedDevices();
  }

  Future<void> getPairedDevices() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance
          .getBondedDevices();

      if (!mounted) return;
      setState(() {
        bondedDevices = devices;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get bonded devices: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final btService = Provider.of<BluetoothService>(context);

    if (!_isBluetoothReady) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bluetooth Devices')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Bluetooth is off. Please enable Bluetooth.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Reset the request flag and retry enabling Bluetooth on button press
                  _bluetoothRequested = false;
                  initBluetooth();
                },
                child: const Text('Enable Bluetooth'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Select Bluetooth Device')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : bondedDevices.isEmpty
          ? Center(
              child: Text(
                'No paired Bluetooth devices found.\nPlease pair your device first.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            )
          : ListView.builder(
              itemCount: bondedDevices.length,
              itemBuilder: (context, index) {
                final device = bondedDevices[index];
                bool isConnected =
                    btService.connectedDevice?.address == device.address;
                return DeviceTile(
                  deviceName: device.name ?? 'Unknown Device',
                  deviceAddress: device.address,
                  isConnected: isConnected,
                  onTap: () async {
                    await btService.connectToDevice(device);
                    if (!mounted) return;
                    if (btService.isConnected) {
                      Navigator.pushNamed(context, '/dataDisplay');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cannot connect to the device'),
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}

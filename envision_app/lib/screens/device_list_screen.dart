import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import '../services/bluetooth_service.dart';
import '../widgets/device_tile.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  List<BluetoothDevice> bondedDevices = [];

  @override
  void initState() {
    super.initState();
    getPairedDevices();
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance
        .getBondedDevices();
    setState(() {
      bondedDevices = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    final btService = Provider.of<BluetoothService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Select Bluetooth Device')),
      body: ListView(
        children: bondedDevices.map((device) {
          bool isConnected =
              btService.connectedDevice?.address == device.address;
          return DeviceTile(
            deviceName: device.name ?? 'Unknown Device',
            deviceAddress: device.address,
            isConnected: isConnected,
            onTap: () async {
              await btService.connectToDevice(device);
              if (btService.isConnected) {
                Navigator.pushNamed(context, '/dataDisplay');
              }
            },
          );
        }).toList(),
      ),
    );
  }
}

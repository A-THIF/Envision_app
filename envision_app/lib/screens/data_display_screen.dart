import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/bluetooth_service.dart';

class DataDisplayScreen extends StatelessWidget {
  const DataDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final btService = Provider.of<BluetoothService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Terminal'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              btService.disconnect();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.black12,
            child: Text(
              'Connected Device: ${btService.connectedDevice?.name ?? "None"}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<String>(
              stream: btService.dataStream,
              builder: (context, snapshot) {
                return Center(
                  child: Text(
                    snapshot.data ?? 'No Data Yet',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

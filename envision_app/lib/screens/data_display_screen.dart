import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/bluetooth_service.dart';
import 'package:intl/intl.dart';

class DataDisplayScreen extends StatefulWidget {
  const DataDisplayScreen({super.key});

  @override
  _DataDisplayScreenState createState() => _DataDisplayScreenState();
}

class _DataDisplayScreenState extends State<DataDisplayScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final btService = Provider.of<BluetoothService>(context, listen: false);

    // Scroll to bottom initially once the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });

    // Listen for new data and auto-scroll smoothly to bottom
    btService.dataStream.listen((_) {
      if (mounted && _scrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final btService = Provider.of<BluetoothService>(context);
    final log = btService.dataLog;

    bool isConnected = btService.isConnected;
    String? connectedDeviceName = btService.connectedDevice?.name;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Terminal'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            tooltip: 'Clear log',
            onPressed: btService.clearLog,
          ),
          IconButton(
            icon: Icon(
              isConnected
                  ? Icons.bluetooth_connected
                  : Icons.bluetooth_disabled,
            ),
            tooltip: isConnected ? 'Disconnect' : 'Connect',
            onPressed: () async {
              if (isConnected) {
                await btService.disconnect();
              } else {
                if (btService.connectedDevice != null) {
                  await btService.connectToDevice(btService.connectedDevice!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No previous device to connect')),
                  );
                }
              }
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
              'Connected Device: ${connectedDeviceName ?? "None"}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.black87,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: log.length,
                itemBuilder: (context, index) {
                  final time = DateFormat('HH:mm:ss').format(DateTime.now());
                  final text = '[$time] ${log[index]}';
                  return Text(
                    log[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Courier',
                      color: Colors.greenAccent,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

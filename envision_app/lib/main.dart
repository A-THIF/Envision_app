import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/device_list_screen.dart';
import 'screens/data_display_screen.dart';
import 'services/bluetooth_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => BluetoothService(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Envision Cap',
      theme: ThemeData(primaryColor: Color(0xFF131321)),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/deviceList': (context) => DeviceListScreen(),
        '/dataDisplay': (context) => DataDisplayScreen(),
      },
    );
  }
}

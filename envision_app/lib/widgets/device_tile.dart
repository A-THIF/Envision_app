import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DeviceTile extends StatelessWidget {
  final String deviceName;
  final String deviceAddress;
  final bool isConnected;
  final VoidCallback onTap;

  const DeviceTile({
    super.key,
    required this.deviceName,
    required this.deviceAddress,
    this.isConnected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isConnected ? Colors.green.shade100 : AppColors.tileColor,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isConnected
            ? BorderSide(color: Colors.green, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        leading: Icon(
          Icons.bluetooth,
          color: isConnected ? Colors.green : AppColors.tileTextColor,
          size: 32,
        ),
        title: Text(
          deviceName,
          style: TextStyle(
            color: AppColors.tileTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          deviceAddress,
          style: TextStyle(
            color: AppColors.tileTextColor.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        trailing: isConnected
            ? Icon(Icons.check_circle, color: Colors.green, size: 24)
            : Icon(
                Icons.arrow_forward_ios,
                color: AppColors.tileTextColor,
                size: 18,
              ),
        onTap: onTap,
      ),
    );
  }
}

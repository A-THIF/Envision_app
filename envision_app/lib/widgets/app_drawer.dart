import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors
          .backgroundColor, // Lightened top bar color for drawer background
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.topBarColor),
            child: Text(
              'Envision Menu',
              style: TextStyle(
                color: AppColors.fontColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.bluetooth, color: AppColors.iconColor),
            title: Text(
              'Device List',
              style: TextStyle(color: AppColors.fontColor),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/deviceList');
            },
          ),
          ListTile(
            leading: Icon(Icons.data_usage, color: AppColors.iconColor),
            title: Text(
              'Data Display',
              style: TextStyle(color: AppColors.fontColor),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/dataDisplay');
            },
          ),
        ],
      ),
    );
  }
}

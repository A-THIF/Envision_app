import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({super.key}) : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.topBarColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu, color: AppColors.iconColor),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      centerTitle: true,
      title: Text(
        'Envision App',
        style: TextStyle(
          color: AppColors.fontColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}

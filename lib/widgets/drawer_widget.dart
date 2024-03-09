// drawer.dart

import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final Function(BuildContext, String) onOptionSelected;

  DrawerWidget({
    required this.options,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 17, 19, 23),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 60),
            for (var option in options)
              ListTile(
                title: Text(
                  option['title'],
                  style: TextStyle(
                    color: option['title'] == 'Logout' ? Colors.red : Colors.white,
                  ),
                ),
                leading: Icon(
                  option['icon'],
                  color: option['title'] == 'Logout' ? Colors.red : Colors.white,
                ),
                onTap: () {
                  onOptionSelected(context, option['title']);
                },
              ),
          ],
        ),
      ),
    );
  }
}

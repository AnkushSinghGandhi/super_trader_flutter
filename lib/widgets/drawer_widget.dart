import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final List<String> options;
  final Function(String) onOptionSelected;

  DrawerWidget({required this.options, required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Rahul Sharma'),
          ),
          for (String option in options)
            ListTile(
              title: Text(option),
              onTap: () {
                Navigator.pop(context);
                onOptionSelected(option);
              },
            ),
        ],
      ),
    );
  }
}
// about_page.dart

import 'package:flutter/material.dart';
import '../widgets/drawer_widget.dart';

class AboutPage extends StatelessWidget {
  final List<Map<String, dynamic>> options;

  AboutPage({required this.options});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 17, 19, 23),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'About',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu), // Menu icon for opening the drawer
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer using the context provided by the Builder
            },
          ),
        ),
      ),
      drawer: DrawerWidget(
        options: options,
        onOptionSelected: (context, option) {
          Scaffold.of(context).openDrawer(); // Open the drawer using the context provided by the Builder
        },
      ),
      body: Center(
        child: Text(
          'This is the About Page',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}

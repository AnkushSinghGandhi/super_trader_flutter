import 'package:flutter/material.dart';
import '../widgets/drawer_widget.dart'; // Import the custom drawer widget

class HistoryPage extends StatelessWidget {
  final List<String>? purchaseHistory;

  HistoryPage({this.purchaseHistory});

  List<String> options = [
    'Market',
    'Trade',
    'History',
    'Profile',
    'About',
    'Logout',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 17, 19, 23),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('History', style: TextStyle(fontSize: 18, color: Colors.white)),
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
        onOptionSelected: (option) {
          Scaffold.of(context).openDrawer(); // Open the drawer using the context provided by the Builder
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Purchase History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: purchaseHistory?.length ?? 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(purchaseHistory![index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

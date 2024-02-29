// home_page.dart

import 'package:flutter/material.dart';
import 'drawer.dart';
import 'api.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> options = [
    'Trade',
    'News',
    'Mailbox',
    'Journal',
    'Settings',
    'Economic calendar',
    'Traders Community',
    'User guide',
    'About',
  ];

  List<String> instrumentIdentifiers = [
    'MGL-I', // Add more instrument identifiers as needed
  ];

  Map<String, dynamic> ltpValues = {}; // Map to store LTP values

  @override
  void initState() {
    super.initState();
    fetchLTP(); // Fetch LTP values when the widget initializes
  }

  Future<void> fetchLTP() async {
    for (String identifier in instrumentIdentifiers) {
      final data = await fetchLTPData(identifier);
      setState(() {
        ltpValues[identifier] = data['LastTradePrice'];
      });
    }
  }

  Future<void> showAvailableIdentifiers() async {
    final availableIdentifiers = await getAllInstrumentIdentifiers();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            for (String identifier in availableIdentifiers)
              ListTile(
                title: Text(identifier),
                onTap: () {
                  Navigator.pop(context); // Close the modal
                  addInstrumentIdentifier(identifier);
                },
              ),
          ],
        );
      },
    );
  }

  void addInstrumentIdentifier(String identifier) {
    setState(() {
      if (!instrumentIdentifiers.contains(identifier)) {
        instrumentIdentifiers.add(identifier);
      }
    });
  }

  void removeInstrumentIdentifier(String identifier) {
    setState(() {
      instrumentIdentifiers.remove(identifier);
    });
  }

  void handleOptionSelection(BuildContext context, String option) {
    // ... (Your existing option handling logic)
  }

  Widget buildLTP(BuildContext context, String identifier) {
    return ListTile(
      title: Text(
        identifier,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Last updated: ${DateTime.now()}'),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Last Trade Price: ${ltpValues[identifier] ?? 'N/A'}',
            style: TextStyle(color: Colors.blue),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle),
            color: Colors.red,
            onPressed: () {
              removeInstrumentIdentifier(identifier);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchLTP(); // Refresh LTP values on button press
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showAvailableIdentifiers(); // Show available identifiers
            },
          ),
        ],
      ),
      drawer: DrawerWidget(
        options: options,
        onOptionSelected: (option) {
          Navigator.pop(context);
          handleOptionSelection(context, option);
        },
      ),
      body: ListView.builder(
        itemCount: instrumentIdentifiers.length,
        itemBuilder: (context, index) {
          return buildLTP(context, instrumentIdentifiers[index]);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Quotes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Trade',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/ltp_tile.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          return LtpTile(
            identifier: instrumentIdentifiers[index],
            ltpValue: ltpValues[instrumentIdentifiers[index]],
            onRemove: () => removeInstrumentIdentifier(instrumentIdentifiers[index]),
          );
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

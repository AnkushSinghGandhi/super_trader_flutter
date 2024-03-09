import 'package:flutter/material.dart';
import '../widgets/drawer_widget.dart';
import '../services/api_service.dart';
import '../screens/history_page.dart';
import '../screens/trade_page.dart';
import '../screens/about_page.dart';
import '../screens/profile_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Index of the selected bottom navigation bar item

  List<Map<String, dynamic>> options = [
    {'title': 'Market', 'icon': Icons.bar_chart},
    {'title': 'Trade', 'icon': Icons.show_chart},
    {'title': 'History', 'icon': Icons.history},
    {'title': 'News', 'icon': Icons.info},
    {'title': 'Profile', 'icon': Icons.account_circle_outlined},
    {'title': 'About', 'icon': Icons.info},
    {'title': 'Logout', 'icon': Icons.logout},
  ];

  List<String> instrumentIdentifiers = [
    'MGL-I', // Add more instrument identifiers as needed
  ];

  Map<String, dynamic> ltpValues = {}; // Map to store LTP values

  // Purchase history list
  List<String> purchaseHistory = [];

  @override
  void initState() {
    super.initState();
    fetchLTP(); // Fetch LTP values when the widget initializes
  }

  Future<void> fetchLTP() async {
    for (String identifier in instrumentIdentifiers) {
      final data = {
        "InstrumentIdentifier": "NESTLEIND-I",
        "LastTradePrice": 23039.75
      };
      setState(() {
        ltpValues[identifier] = data['LastTradePrice'];
      });
    }
  }

  Future<void> showAvailableIdentifiers() async {
    final availableIdentifiers = await getAllInstrumentIdentifiers();

    showModalBottomSheet(
      backgroundColor: Color.fromARGB(255, 17, 19, 23), // Set the background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            for (String identifier in availableIdentifiers)
              ListTile(
                title: Center(
                  child: Text(
                    identifier,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
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

void handleOptionSelection(BuildContext context, String option) {
    switch (option) {
      case 'Market':
        setState(() => _selectedIndex = 0);
        break;
      case 'Trade':
        setState(() => _selectedIndex = 1);
        break;
      case 'History':
        setState(() => _selectedIndex = 2);
        break;
      case 'Profile':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(options: options),
          ),
        );
        break;
      case 'About':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AboutPage(options: options),
          ),
        );
        break;
      case 'Logout':
        // Handle logout
        break;
      default:
        print('Invalid option: $option');
    }
  }

  // Function to handle the buy action
  Future<void> buyStock(String instrumentIdentifier, double quantity) async {
    // Get the latest LTP for the instrument identifier
    final ltp = {
      "InstrumentIdentifier": "NESTLEIND-I",
      "LastTradePrice": 23039.75
    };
    if (ltp != null && ltp.containsKey('LastTradePrice')) {
      final lastTradePrice = (ltp['LastTradePrice'] as num).toDouble();

      // Calculate the total cost
      final totalCost = lastTradePrice * quantity;

      // Add the purchase to the history
      final purchaseDetails =
          '$instrumentIdentifier - Quantity: $quantity - Total Cost: $totalCost INR';
      setState(() {
        purchaseHistory.add(purchaseDetails);
      });

      // Show a snackbar with the purchase details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Purchase successful - $purchaseDetails'),
        ),
      );
    } else {
      // Show an error snackbar if LTP data is not available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get the latest stock data.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildLTP(BuildContext context, String identifier) {
    return GestureDetector(
      onTap: () {
        showBottomSheetOptions(context, identifier);
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Color.fromARGB(255, 17, 19, 23),
            ),
            child: ListTile(
              title: Text(
                identifier,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              subtitle: Text(
                'Last updated: ${DateTime.now()}',
                style: TextStyle(fontSize: 11, color: Colors.white),
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 5),
                  Text(
                    '+112.3(10.1%)', // Display absolute value
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${ltpValues[identifier] ?? 'N/A'}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(
            color: Colors.white, // Customize the color
            thickness: 1, // Customize the thickness
          ),
        ],
      ),
    );
  }

  void showBottomSheetOptions(BuildContext context, String identifier) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Center(
            child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 17, 19, 23),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.shopping_cart, color: Colors.white),
                title: Text('Buy', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Open a dialog to input quantity
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      double quantity = 1.0; // Default quantity

                      return AlertDialog(
                        title: Text('Buy $identifier'),
                        content: Column(
                          children: [
                            Text('Enter quantity:'),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                quantity = double.tryParse(value) ?? 1.0;
                              },
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await buyStock(identifier, quantity);
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Buy'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.insert_chart_outlined, color: Colors.white),
                title: Text('Chart', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Handle chart action
                  Navigator.pop(context);
                  // Implement chart action
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.white),
                title: Text('Delete', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Handle delete action
                  Navigator.pop(context);
                  // Implement delete action
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline, color: Colors.white),
                title: Text('Details', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Handle details action
                  Navigator.pop(context);
                  // Implement details action
                },
              ),
            ],
          ),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;
    switch (_selectedIndex) {
      case 0:
        // Market page
        currentPage = Scaffold(
          backgroundColor: Color.fromARGB(255, 17, 19, 23),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            title: Text(
              'Market',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  fetchLTP(); // Refresh LTP values on button press
                },
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  showAvailableIdentifiers(); // Show available identifiers
                },
              ),
            ],
          ),
          drawer: DrawerWidget(
            options: options,
            onOptionSelected: handleOptionSelection,
          ),
          body: ListView.builder(
            itemCount: instrumentIdentifiers.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  buildLTP(context, instrumentIdentifiers[index]),
                  SizedBox(height: 5),
                ],
              );
            },
          ),
        );
        break;
      case 1:
        // Trade page
        currentPage = TradePage();
        break;
      case 2:
        // History page
        currentPage = HistoryPage(purchaseHistory: purchaseHistory);
        break;
      default:
        currentPage = Container(); // Placeholder for other pages
    }

    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Color.fromARGB(255, 17, 19, 23), // Set the background color
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Market',
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
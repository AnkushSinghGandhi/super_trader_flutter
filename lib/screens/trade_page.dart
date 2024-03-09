import 'package:flutter/material.dart';
import '../widgets/drawer_widget.dart';
import '../screens/history_page.dart';
import '../screens/home_page.dart';

class TradePage extends StatefulWidget {
  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  List<Map<String, dynamic>> options = [
    {'title': 'Market', 'icon': Icons.bar_chart},
    {'title': 'Trade', 'icon': Icons.show_chart},
    {'title': 'History', 'icon': Icons.history},
    {'title': 'Profile', 'icon': Icons.account_circle_outlined},
    {'title': 'About', 'icon': Icons.info},
    {'title': 'Logout', 'icon': Icons.logout},
  ];

  void handleOptionSelection(BuildContext context, String option) {
    if (option == 'History') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryPage(purchaseHistory: []), // Navigate to HistoryPage
        ),
      );
    } else if (option == 'Trade') {
      // Do nothing as we're already on the TradePage
    } else {
      print('Invalid option: $option');
    }
  }

  List<String> purchasedStocks = ['MGL-I', 'AAPL']; // Add more as needed
  String selectedStock = '';
  double purchasePrice = 0.0; // Placeholder for actual purchase price
  double currentLTP = 0.0; // Placeholder for actual current LTP

  @override
  void initState() {
    super.initState();
    if (purchasedStocks.isNotEmpty) {
      selectedStock = purchasedStocks[0];
      // Fetch actual purchase price and current LTP based on selectedStock
      // Implement your logic here or use API calls
      fetchStockData(selectedStock);
    }
  }

  Future<void> fetchStockData(String stock) async {
    // Implement your logic to fetch data from the server
    // For example, you might use an API call to get actual purchase price and LTP
    // Set the state with the fetched data
    setState(() {
      purchasePrice = 100.0; // Replace with the actual purchase price
      currentLTP = 110.0; // Replace with the actual current LTP
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 17, 19, 23),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Trade',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu), // Menu icon for opening the drawer
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
      ),
      drawer: DrawerWidget(
        options: options,
        onOptionSelected: handleOptionSelection,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: selectedStock,
              items: purchasedStocks.map((stock) {
                return DropdownMenuItem<String>(
                  value: stock,
                  child: Text(
                    stock,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStock = value!;
                  // Fetch actual purchase price and current LTP based on selectedStock
                  fetchStockData(selectedStock);
                });
              },
              style: TextStyle(fontSize: 18, color: Colors.white),
              dropdownColor: Color.fromARGB(255, 17, 19, 23),
            ),
            SizedBox(height: 20),
            Text(
              'Purchase Price: $purchasePrice', // Display actual purchase price
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              'Current LTP: $currentLTP', // Display actual current LTP
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement buy action
              },
              child: Text('BUY'),
            ),
          ],
        ),
      ),
    );
  }
}

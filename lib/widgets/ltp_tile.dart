import 'package:flutter/material.dart';

class LtpTile extends StatelessWidget {
  final String identifier;
  final double? ltpValue;
  final VoidCallback onRemove;

  LtpTile({required this.identifier, this.ltpValue, required this.onRemove});

  @override
  Widget build(BuildContext context) {
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
            'Last Trade Price: ${ltpValue ?? 'N/A'}',
            style: TextStyle(color: Colors.blue),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle),
            color: Colors.red,
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
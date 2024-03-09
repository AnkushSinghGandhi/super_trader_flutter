import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/history_page.dart';

Map<String, WidgetBuilder> routes(BuildContext context) {
  return {
    '/': (context) => HomePage(),
    '/history': (context) => HistoryPage(),
  };
}
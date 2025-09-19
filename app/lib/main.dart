import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'src/pages/search_page.dart';
import 'src/pages/cart_page.dart';

void main() {
  runZonedGuarded(() {
    runApp(const ProviderScope(child: ShoplyApp()));
  }, (error, stack) {
    // Could send to crash logging here
    // ignore: avoid_print
    print('Unhandled error: $error');
  });
}

class ShoplyApp extends StatelessWidget {
  const ShoplyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoply',
      debugShowCheckedModeBanner: false,
      theme: buildShoplyTheme(),
      routes: {
        '/': (_) => const SearchPage(),
        '/cart': (_) => const CartPage(),
      },
    );
  }
}

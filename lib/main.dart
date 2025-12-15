import 'package:flutter/material.dart';
import 'main_page.dart';

void main() {
  // Firebase di-skip sementara agar bisa jalan di FlutLab
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: 'Sevenground',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

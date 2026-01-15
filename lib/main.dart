import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const HersheyApp());
}

class HersheyApp extends StatelessWidget {
  const HersheyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hershey',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16171D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16171D),
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'images/top-logo.png', 
          height: 60,
        ),
      ),
      body: const Center(
        child: Text(
          'Your side project starts here',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  
  }
}

import 'package:flutter/material.dart';
import 'package:bikerental/pages/home_page.dart';
import 'package:bikerental/pages/about_page.dart'; 

void main() {
  runApp(const BikeRentalApp());
}

class BikeRentalApp extends StatelessWidget {
  const BikeRentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bike Rental Predictor',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      routes: {
        '/about': (context) => const AboutPage(),
      },
    );
  }
}

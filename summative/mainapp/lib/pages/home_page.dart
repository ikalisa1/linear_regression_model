import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'season': TextEditingController(),
    'yr': TextEditingController(),
    'mnth': TextEditingController(),
    'holiday': TextEditingController(),
    'weekday': TextEditingController(),
    'workingday': TextEditingController(),
    'weathersit': TextEditingController(),
    'temp': TextEditingController(),
    'atemp': TextEditingController(),
    'hum': TextEditingController(),
    'windspeed': TextEditingController(),
  };

  void _showPopup(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _predict() async {
    try {
      final inputData =
          controllers.map((key, value) => MapEntry(key, value.text));
      final result = await ApiService.predict(inputData);
      _showPopup("Prediction Result", "Predicted Rentals: $result");
    } catch (e) {
      _showPopup("Error", "An error occurred: \${e.toString()}");
    }
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bike Rental Predictor', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bike_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...controllers.entries.map((entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: entry.value,
                        decoration: InputDecoration(
                          labelText: entry.key,
                          labelStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.0),
                          ),
                          helperText: _getHelperText(entry.key),
                          helperStyle: const TextStyle(color: Colors.green),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required field' : null,
                      ),
                    )),
                const SizedBox(height: 20),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _predict();
                      }
                    },
                    child: const Text('Predict', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getHelperText(String key) {
    switch (key) {
      case 'season':
        return '1: Winter, 2: Spring, 3: Summer, 4: Fall';
      case 'yr':
        return '0: 2011, 1: 2012';
      case 'mnth':
        return '1-12 representing January to December';
      case 'holiday':
        return '0: No holiday, 1: Holiday';
      case 'weekday':
        return '0: Sunday, 6: Saturday';
      case 'workingday':
        return '0: No, 1: Yes';
      case 'weathersit':
        return '1: Clear, 2: Mist, 3: Light rain/snow, 4: Heavy rain/snow';
      case 'temp':
        return 'Normalized temperature in Celsius';
      case 'atemp':
        return 'Normalized feeling temperature';
      case 'hum':
        return 'Humidity level (0-1)';
      case 'windspeed':
        return 'Wind speed normalized';
      default:
        return '';
    }
  }
}

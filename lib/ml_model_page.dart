import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MLModelPage extends StatefulWidget {
  @override
  _MLModelPageState createState() => _MLModelPageState();
}

class _MLModelPageState extends State<MLModelPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the input fields
  TextEditingController pregnanciesController = TextEditingController();
  TextEditingController glucoseController = TextEditingController();
  TextEditingController bloodPressureController = TextEditingController();
  TextEditingController skinThicknessController = TextEditingController();
  TextEditingController insulinController = TextEditingController();
  TextEditingController bmiController = TextEditingController();
  TextEditingController diabetesPedigreeFunctionController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  // To store prediction result (if applicable)
  String predictionResult = "";

  // Function to simulate making a prediction
  Future<void> _makePrediction() async {
    try {
      // Validate the form
      if (_formKey.currentState!.validate()) {
        // Retrieve user input data
        Map<String, dynamic> inputData = {
          'Pregnancies': int.parse(pregnanciesController.text),
          'Glucose': int.parse(glucoseController.text),
          'BloodPressure': int.parse(bloodPressureController.text),
          'SkinThickness': int.parse(skinThicknessController.text),
          'Insulin': int.parse(insulinController.text),
          'BMI': double.parse(bmiController.text),
          "DiabetesPedigreeFunction": double.parse(diabetesPedigreeFunctionController.text),
          'Age': int.parse(ageController.text),
        };

        print(jsonEncode(inputData)); // Optional: Log the data before sending

        final response = await http.post(
          Uri.parse('http://localhost:5000/predict'),  // Replace with your API URL
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(inputData),
        );

        print(response.body);

        if (response.statusCode == 200) {
          Map<String, dynamic> result = jsonDecode(response.body);
          setState(() {
            predictionResult = result['prediction'] ?? 'No Prediction Available'; // Extract prediction from result
          });

          // Handle the user information for saving prediction (optional)

        } else {
          setState(() {
            predictionResult = 'Prediction failed, please try again.';
          });
        }
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        predictionResult = 'Error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ML Model Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(125, 10, 0, 20),
                child: Text(
                  'ML Model',
                  style: TextStyle(fontFamily: 'Barlow', fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              // Input fields for ML model prediction
              TextFormField(
                controller: pregnanciesController,
                decoration: InputDecoration(
                  labelText: 'Pregnancies',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid input';
                  }
                },
              ),
              TextFormField(
                controller: glucoseController,
                decoration: InputDecoration(
                  labelText: 'Glucose (mg/dL)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid input';
                  }
                },
              ),
              TextFormField(
                controller: bloodPressureController,
                decoration: InputDecoration(
                  labelText: 'Blood Pressure (mm of Hg)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid input';
                  }
                },
              ),
              TextFormField(
                controller: skinThicknessController,
                decoration: InputDecoration(
                  labelText: 'Skin Thickness (mm)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid input';
                  }
                },
              ),
              TextFormField(
                controller: insulinController,
                decoration: InputDecoration(
                  labelText: 'Insulin (µU/ml)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid input';
                  }
                },
              ),
              TextFormField(
                controller: bmiController,
                decoration: InputDecoration(
                  labelText: 'BMI (Kg/m^2)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid input';
                  }
                },
              ),
              TextFormField(
                controller: diabetesPedigreeFunctionController,
                decoration: InputDecoration(
                  labelText: 'Diabetes Pedigree Function',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid input';
                  }
                },
              ),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid input';
                  }
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _makePrediction,
                child: Text('Make Prediction'),
              ),
              SizedBox(height: 16.0),
              // Display prediction result if available
              if (predictionResult.isNotEmpty)
                Text(
                  'Prediction Result: $predictionResult',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

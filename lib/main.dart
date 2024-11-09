import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'ml_model_page.dart'; // Import ML model page
import 'chatbot_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load();

  // Initialize Supabase with environment variables
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Wellness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthChecker(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),// Add profile page route
        '/mlmodel': (context) => MLModelPage(),  // Add ML model page route
        '/chatbot': (context) => ChatbotPage(),  // Add this line
      },
    );
  }
}

// AuthChecker widget to determine which page to display
class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    // Check if the user is authenticated
    return session != null ? HomePage() : LoginPage();
  }
}

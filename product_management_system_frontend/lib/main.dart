import 'package:flutter/material.dart';
import 'package:product_management_system_frontend/screens/signup_screen.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart'; // Your ProductProvider class (we'll create this next)
import 'screens/login_screen.dart'; // We'll create this screen next
import 'screens/product screen.dart'; // We'll create this screen next
import 'utils/shared_preference.dart'; // We'll create this utility next

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Product Management System',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => AuthWrapper(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/product': (context) => ProductScreen(), // Add route for signup screen
        },

        // home: AuthWrapper(), // We'll create this widget next
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getToken(), // Function to get token from SharedPreferences
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle the error, you can display a message or navigate to an error screen
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          return ProductScreen(); // User is logged in
        } else {
          return SignupScreen(); // User is not logged in
        }
      },
    );
  }
}

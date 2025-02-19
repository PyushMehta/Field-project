import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/signup_screen.dart';
import 'package:pharmcare/services/notification_service.dart'; // ✅ Correct import

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // ✅ Required for async operations before runApp
  NotificationService.initialize(); // ✅ Initialize Notifications
  final userProvider = UserProvider();
  await userProvider
      .loadUserData(); // ✅ Load saved user data (name & profile picture)

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
            create: (context) => userProvider), // ✅ Use preloaded UserProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PharmCare',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/inventory': (context) => InventoryScreen(),
        '/signup': (context) => SignupScreen(),
      },
    );
  }
}

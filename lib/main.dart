// main.dart
import 'package:customer_viewer/screens/customer_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api/authentication.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Authentication(),
      child: MaterialApp(
        title: 'Customer List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: LoginScreen.idScreen,


        routes: {
          LoginScreen.idScreen: (context) => LoginScreen(),
          CustomerListPage.idScreen: (context) => CustomerListPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

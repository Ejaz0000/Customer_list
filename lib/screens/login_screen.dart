import 'package:customer_viewer/screens/customer_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/authentication.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blueGrey[800]!,
            Colors.blueGrey[600]!,
            Colors.blueGrey,
            Colors.blueGrey[200]!
          ],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome Back",
              style: TextStyle(
                  color: Colors.white, fontSize: 30, fontFamily: "Brand Bold"),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            const Text(
              "Login as admin",
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: "Brand Bold"),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            const Text(
              "Authentication is required to view the customer list",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: "Brand-Regular"),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey[600]!,
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                      offset: Offset(
                        1.0,
                        1.0,
                      ),
                    ),
                  ],
                  color: Colors.blueGrey),
              child: TextField(
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Username",
                  hintStyle: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 14,
                      fontFamily: "Brand-Regular"),
                ),
                style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                    fontFamily: "Brand-Regular"),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey[600]!,
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                      offset: Offset(
                        1.0,
                        1.0,
                      ),
                    ),
                  ],
                  color: Colors.blueGrey),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Password",
                  hintStyle: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 14,
                      fontFamily: "Brand-Regular"),
                ),
                style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                    fontFamily: "Brand-Regular"),
              ),
            ),
            SizedBox(height: 40),
            Container(
              alignment: Alignment.center,
              height: 40,
              width: (MediaQuery.of(context).size.width) * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextButton(
                onPressed: () async {
                  final username = _usernameController.text;
                  final password = _passwordController.text;
                  final authentication =
                      Provider.of<Authentication>(context, listen: false);
                  final success =
                      await authentication.login(username, password);
                  if (success) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, CustomerListPage.idScreen, (route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Login failed. Incorrect Username or Password. ')),
                    );
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.blueGrey[400]!,
                      fontSize: 16,
                      fontFamily: "Brand Bold"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

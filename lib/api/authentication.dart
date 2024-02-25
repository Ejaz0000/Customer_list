import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Authentication extends ChangeNotifier{
  String? _token;

  String? get token => _token;

  set token(String? value) {
    _token = value;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async{
    final url = Uri.parse(
        'https://www.pqstec.com/InvoiceApps/Values/LogIn?UserName=$username&Password=$password&ComId=1');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _token = responseData['Token'];
        notifyListeners();
        return true;
      } else {
        return false;
      }
    }catch (error) {
      return false;
    }

  }


}
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utils/accessory_widgets.dart';
class AuthProvider extends ChangeNotifier{

  bool? _isAuth;
  bool _isRegistered = true;
  bool get isRegistered {
    return _isRegistered;
  }

  bool? get isAuth {
    return _isAuth;
  }

  Future<bool> _authenticate(
      String email, String password, BuildContext context, String route) async {
    bool isSuccessful = true;
    final url = Uri.parse(route);
    try {
      final response = await http.post(url,
          body: json.encode({"email": email, "password": password}),
          headers: {"Content-Type": "application/json"});
      final responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode == 200) {
        _isAuth = true;
        final ref = await SharedPreferences.getInstance();
        ref.setString("access_token", responseData["data"]["accesstoken"]);
        ref.setString("refresh_token", responseData["data"]["refreshtoken"]);

        notifyListeners();
      } else {
        _isAuth = false;
        isSuccessful = false;
        notifyListeners();
        throw HttpException(responseData["message"]);
      }
    } on HttpException catch (e) {
      isSuccessful = false;
      AccessoryWidgets.showSnackBar(e.message, context);
    } catch (e) {
      isSuccessful = false;
      print("$e error occured while logging in");
    }
    return isSuccessful;
  }

  Future<bool> signup(
      String email, String password, BuildContext context) async {
    const url = "http://3.133.142.121:8989/user/signup";
    print("$email $password");
    return await _authenticate(email, password, context, url);
  }

  Future<bool> login(
      String email, String password, BuildContext context) async {
    const url = "http://3.133.142.121:8989/user/login";
    return await _authenticate(email, password, context, url);
  }

}
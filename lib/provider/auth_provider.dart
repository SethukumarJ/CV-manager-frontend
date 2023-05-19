import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import '../utils/accessory_widgets.dart';
class AuthProvider extends ChangeNotifier{

  bool? _isAuth;
  bool _isRegistered = true;
  User? currentUser;

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

  Future<void> fetchCurrentUser() async {
    try {
      final url = Uri.parse("http://3.133.142.121:8989/user/get/");
      final ref = await SharedPreferences.getInstance();
      final accessToken = ref.getString("access_token") ?? "";
      print(accessToken);
      final header = {
        "Authorization": "Bearer $accessToken"
      };
      final response = await http.get(url,headers: header);
      final responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode == 200) {
        _isAuth = true;

        _isRegistered = responseData["data"]["verified"];
        final data = responseData["data"];
        currentUser = User(cv: data["cv"], dob: data["date_of_birth"], phone: data["phone"], firstName: data["first_name"], lastName: data["last_name"],email: data["email"]);
        notifyListeners();
      } else {
        _isAuth = false;
        notifyListeners();
      }
    } on HttpException catch (e) {

      print(e.message);
    }catch (e) {
      print("$e error occured while fetching current user");
    }
  }

  Future<bool> userRegistration(File file, DateTime dob, String phone,
      String firstName, String lastName, BuildContext context) async {
    bool isSuccessful = true;
    final url = Uri.parse("http://3.133.142.121:8989/user/profile");
    try {
      final task = await FirebaseStorage.instance
          .ref("user_cv")
          .child("${DateTime.now()}.pdf")
          .putFile(file);
      final downloadUrl = await task.ref.getDownloadURL();
      final sharedPref = await SharedPreferences.getInstance();
      final accessToken = sharedPref.getString("access_token");

      String dateOfBirth= DateFormat("yyyy-MM-dd").format(dob);
      print(dateOfBirth);
      print(accessToken);
      final response = await http.patch(url,
          body: json.encode({
            "cv": downloadUrl,
            "date_of_birth": dateOfBirth,
            "first_name": firstName,
            "last_name": lastName,
            "phone": phone
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken"
          });
      if (response.statusCode == 200) {
        _isRegistered = true;
        notifyListeners();
      } else {
        _isRegistered = false;
        notifyListeners();
        throw HttpException(json.decode(response.body)["message"]);
      }
    } on HttpException catch (e) {
      isSuccessful = false;
      AccessoryWidgets.showSnackBar(e.message, context);
    } catch (e) {
      isSuccessful = false;
      print("$e error occured while registering user");
    }
    return isSuccessful;
  }

  Future<String> getNewAccessToken() async {
    try {
      final ref = await SharedPreferences.getInstance();
      final refreshToken =  ref.getString("refresh_token");
      Uri url = Uri.parse("https://cundr.lamsta.com/auth/token/refresh/");
      final response = await http.post(url, body: {"refresh": refreshToken});
      final responseData = jsonDecode(response.body);

      if (responseData["code"] == "token_not_valid") {
        _isAuth = false;

        ref.remove("access_token");
        ref.remove("refresh_token");

        notifyListeners();
      } else {
        ref.setString("access_token", responseData["access_token"]);

        return responseData["access_token"];
      }
    } on HttpException catch (e) {
      print(e);
    } catch (e) {
      print("error while getting refresh token $e");
    }
    return "";
  }

  Future<void> signOut()async{
    final ref = await SharedPreferences.getInstance();
    ref.remove("access_token");
    ref.remove("refresh_token");
    _isAuth = false;
    notifyListeners();
  }

}
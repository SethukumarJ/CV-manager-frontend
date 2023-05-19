import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier{

  bool? _isAuth;
  bool _isRegistered = true;
  bool get isRegistered {
    return _isRegistered;
  }

  bool? get isAuth {
    return _isAuth;
  }

  Future<bool> signup(
      String email, String password, BuildContext context) async {
    const url = "http://3.133.142.121:8989/user/signup";
    print("$email $password");
    return true;
  }
}
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

}
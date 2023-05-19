
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trx_frontend/provider/auth_provider.dart';
import 'package:trx_frontend/screen/home_screen.dart';
import 'package:trx_frontend/screen/login_screen.dart';
import 'package:trx_frontend/screen/splash_screen.dart';
import 'package:trx_frontend/screen/user_data_collection_screen.dart';

void main() {
  runApp(const CVApp());
}

class CVApp extends StatelessWidget {
  const CVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) =>AuthProvider(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(


              useMaterial3: true,
            ),
            home: FutureBuilder(
                future: Firebase.initializeApp(),
                builder: (context,snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const SplashScreen();
                  }
                  return const OpeningScreen();
                }
            )
        )

    );
  }
}

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({Key? key}) : super(key: key);

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
  @override

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (ctx, auth, _) {
        bool? isAuth = auth.isAuth;

        if (isAuth == null) {
          return const SplashScreen();
        } else {
          if (isAuth) {
            if (auth.isRegistered) {
              return const HomePage();
            } else {
              return const UserDataCollection();
            }
          } else {
            return const LoginScreen();
          }
        }
      },
    );
  }
}


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:trx_frontend/screen/user_data_collection_screen.dart';

import '../helpers/validators.dart';

import '../provider/auth_provider.dart';
import '../utils/custom_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: mediaQuery.height * .1,
                ),
                SizedBox(
                  height: mediaQuery.height * .3,
                  width: mediaQuery.width * .5,
                  child: Image.asset(
                    "assets/images/signup.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  "Welcome to Buddies.!",
                  style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.bold,
                      fontSize: mediaQuery.width * .06),
                ),
                Text(
                  "Create an account and let's get started.",
                  style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w600,
                      fontSize: mediaQuery.width * .045,
                      color: CustomColors.lightAccent),
                ),
                SizedBox(
                  height: mediaQuery.height * .05,
                ),
                Form(
                    key: _formKey,
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: mediaQuery.width * .05),
                      height: mediaQuery.height * .4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              return AuthValidators.emailValidator(value!);
                            },
                            style: GoogleFonts.nunitoSans(),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                                prefixIcon: Icon(
                                  Ionicons.mail_outline,
                                  color: CustomColors.lightAccent,
                                ),
                                hintText: "Email",
                                hintStyle: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black38),
                                fillColor: Colors.black12,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none)),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            style: GoogleFonts.nunitoSans(),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              return AuthValidators.confirmPasswordValidator(
                                  value!.trim(),
                                  _confirmPasswordController.text.trim());
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 5),
                                prefixIcon: Icon(
                                  Ionicons.lock_closed_outline,
                                  color: CustomColors.lightAccent,
                                ),
                                hintText: "Password",
                                hintStyle: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black38),
                                fillColor: Colors.black12,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none)),
                          ),
                          TextFormField(
                            controller: _confirmPasswordController,
                            style: GoogleFonts.nunitoSans(),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              return AuthValidators.confirmPasswordValidator(
                                  _passwordController.text.trim(), value!.trim());
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 5),
                                prefixIcon: Icon(
                                  Ionicons.lock_closed_outline,
                                  color: CustomColors.lightAccent,
                                ),
                                hintText: "Confirm Password",
                                hintStyle: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black38),
                                fillColor: Colors.black12,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none)),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                bool? isValid = _formKey.currentState?.validate();
                                if (isValid!) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  bool isSuccessful = await authProvider.signup(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                      context);
                                  isLoading = false;
                                  if (!isSuccessful) {
                                    setState(() {});
                                  } else {

                                  }
                                }
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          horizontal: mediaQuery.width * .11,
                                          vertical: mediaQuery.height * .015)),
                                  backgroundColor: MaterialStateProperty.all(
                                      CustomColors.darkAccent)),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                strokeWidth: 1,
                                color: Colors.white,
                              )
                                  : Text(
                                "Create Account",
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: mediaQuery.width * .04),
                              ))
                        ],
                      ),
                    )),
              ],
            )),
      ),
    );
  }

}


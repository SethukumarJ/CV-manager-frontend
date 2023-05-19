
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trx_frontend/screen/pdf_screen.dart';


import '../models/user_model.dart';
import '../provider/auth_provider.dart';
import '../utils/custom_colors.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context);
    User? user = authProvider.currentUser;
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (){
              authProvider.signOut();
            }, icon: Icon(Icons.logout_outlined,color: Colors.white,))
          ],
          title: Text(
            "CV Manager",
            style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w800, color: Colors.white),
          ),
          backgroundColor: CustomColors.lightAccent,
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: mediaQuery.height * .25,
                width: mediaQuery.width*.6,
                child: Image.asset("assets/images/userdetails.jpg",fit: BoxFit.cover,),
              ),
              Text(
                "Name: ${user!.firstName} ${user.lastName}",
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w600, color: Colors.black,fontSize: 20),
              ),
              SizedBox(
                height: mediaQuery.height * .03,
              ),
              Text(
                "Email: ${user.email}",
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w600, color: Colors.black,fontSize: 20),
              ),
              SizedBox(
                height: mediaQuery.height * .03,
              ),
              Text(
                "Phone: ${user.phone}",
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w600, color: Colors.black,fontSize: 20),
              ),
              SizedBox(
                height: mediaQuery.height * .03,
              ),
              Text(
                "Date of birth: ${user.dob}",
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w600, color: Colors.black,fontSize: 20),
              ),
              SizedBox(
                height: mediaQuery.height * .03,
              ),
              SizedBox(
                height: mediaQuery.height * .06,
                width: mediaQuery.width * .4,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.lightAccent),
                  onPressed: ()  {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>  PDFScreen(pdfUrl: user.cv),
                      ),
                    );

                  },
                  child: Text(
                    "View CV",
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../utils/custom_colors.dart';
import 'home_screen.dart';

class UserDataCollection extends StatefulWidget {
  const UserDataCollection({Key? key}) : super(key: key);

  @override
  State<UserDataCollection> createState() => _UserDataCollectionState();
}

class _UserDataCollectionState extends State<UserDataCollection> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  PlatformFile? file;
  bool isLoading = false;
  DateTime? dob;

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _lastNameController.dispose();
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
              SizedBox(
                height: mediaQuery.height * .025,
              ),
              SizedBox(
                height: mediaQuery.height * .22,
                width: mediaQuery.width * .7,
                child: Image.asset(
                  "assets/images/userdetails.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: mediaQuery.height * .03,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: mediaQuery.width * .02,
                    right: mediaQuery.width * .45),
                child: Text("Almost there.!",
                    style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: mediaQuery.width * .06)),
              ),
              Text(
                "Let's add a few details about you to get started.!",
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w600,
                    color: CustomColors.darkAccent),
              ),
              SizedBox(
                height: mediaQuery.height * .03,
              ),

              Form(
                  key: _key,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.width * .05),
                    height: mediaQuery.height * .55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 2) {
                              return "Invalid name";
                            } else {
                              return null;
                            }
                          },
                          style: GoogleFonts.nunitoSans(),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 15),
                              prefixIcon: Icon(
                                Ionicons.person_outline,
                                color: CustomColors.lightAccent,
                              ),
                              hintText: "Name",
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
                          controller: _lastNameController,
                          maxLines: null,
                          validator: (value) {
                            if (value!.isEmpty ) {
                              return "Please Enter a valid last name";
                            } else {
                              return null;
                            }
                          },
                          style: GoogleFonts.nunitoSans(),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 15),
                              prefixIcon: Icon(
                                Ionicons.accessibility_outline,
                                color: CustomColors.lightAccent,
                              ),
                              hintText: "Last Name",
                              hintStyle: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38),
                              fillColor: Colors.black12,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none)),
                        ),
                        SizedBox(
                          height: mediaQuery.height*.09,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  validator: (value){
                                    if(dob!=null){
                                      return null;
                                    }
                                    else if(DateTime.parse(_dateController.text).isAfter(DateTime.now().subtract(const Duration(days: 18*365)))){
                                      return "You must be 18+";
                                    }
                                    else{
                                      return null;
                                    }


                                  },
                                  controller: _dateController,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                      contentPadding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                      prefixIcon: Icon(
                                        Ionicons.calendar_outline,
                                        color: CustomColors.lightAccent,
                                      ),
                                      hintText: "DOB",

                                      hintStyle: GoogleFonts.nunitoSans(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black38),
                                      fillColor: Colors.black12,
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: BorderSide.none)),
                                ),
                              ),
                              IconButton(onPressed: ()async{
                              dob =  await showDatePicker(context: context, initialDate: DateTime(2005,1,1), firstDate: DateTime(1950,1,1), lastDate: DateTime.now().subtract(Duration(days: 18*365)),);
                              if(dob!=null){
                                _dateController.text = DateFormat.yMMMd().format(dob!);
                              }

                              }, icon: Icon(Icons.calendar_month_outlined,color: CustomColors.lightAccent,))

                            ],)
                          ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _phoneController,
                          validator: (value){
                            if(value!.isEmpty || value.length!=10){
                              return "Invalid phone number";
                            }
                            else{
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 15),
                              prefixIcon: Icon(
                                Ionicons.phone_portrait_outline,
                                color: CustomColors.lightAccent,
                              ),
                              hintText: "Phone",

                              hintStyle: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38),
                              fillColor: Colors.black12,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none)),

                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Add your CV",style: GoogleFonts.nunitoSans(color: Colors.black,fontWeight: FontWeight.w600),),
                            SizedBox(width: mediaQuery.width*.05,),
                            ElevatedButton(onPressed: ()async{
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['pdf','doc'],
                              );

                              if (result != null) {
                                 file = result.files.first;


                              } else {
                                // User canceled the file selection
                              }
                            }, child: Text("Upload",style: GoogleFonts.nunitoSans(color: Colors.white,fontWeight: FontWeight.w600),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CustomColors.darkAccent)),)

                          ],),

                        ElevatedButton(
                            onPressed: () async {
                              bool isValid = _key.currentState!.validate();
                              if (isValid) {
                                setState(() {
                                  isLoading = true;
                                });

                                bool isSuccessful = await authProvider.userRegistration(File(file?.path??""), dob!, _phoneController.text, _nameController.text, _lastNameController.text, context);

                                isLoading = false;
                                if (isSuccessful) {
                                  await authProvider.fetchCurrentUser();
                                  nextPage();
                                } else {
                                  setState(() {});
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
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void nextPage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()));
  }
}

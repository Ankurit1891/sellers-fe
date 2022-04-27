// ignore_for_file: library_prefixes

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app_project/mainScreens/home_screen.dart';
import 'package:sellers_app_project/widgets/error_dialog.dart';
import 'package:sellers_app_project/widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';
import '../widgets/custom_text.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String long="";
  String completeAddress="";
  String lat="";


  @override
  void initState()
  {
    super.initState();
    // determinePosition();
  }

  Future<Position?> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {
      await getCurrentLocation();
    }
    return await getCurrentLocation();
  }

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  final geoLocator=Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
  Position? position;
  List<Placemark>? placeMarks;
  String sellerImageUrl=" ";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }


  Future<void> formValidation()async{
    if(imageXFile==null)
    {
        showDialog(context: context,builder: (c)
        {
          return ErrorDialog(
            message: "Please select an Image",
          );
        },
        );
    }
    else
      {
        if(passwordController.text==confirmPasswordController.text)
          {
            if(confirmPasswordController.text.isNotEmpty && emailController.text.isNotEmpty && nameController.text.isNotEmpty & phoneController.text.isNotEmpty && locationController.text.isNotEmpty)
              {
                  showDialog(context: context, builder: (c){
                    return const LoadingDialog(
                      message: "Registering Account",
                    );
                  });
                  String fileName=DateTime.now().microsecondsSinceEpoch.toString();
                  fStorage.Reference reference=fStorage.FirebaseStorage.instance.ref().child("sellers").child(fileName);
                  fStorage.UploadTask uploadTask=reference.putFile(File(imageXFile!.path));
                  fStorage.TaskSnapshot taskSnapshot=await uploadTask.whenComplete((){
                  });
                  await taskSnapshot.ref.getDownloadURL().then((url){
                    sellerImageUrl=url;
                    //save info ti firestore
                    authenticateSellerAndSignUp();
                  });
              }
            else
              {
                showDialog(context: context, builder: (c)
                {
                  return ErrorDialog(
                    message: "Please write the complete required info for the registration",
                  );
                });
              }
            //upload image
          }
        else{
          showDialog(context: context, builder: (c)
          {
            return ErrorDialog(
              message: "Password do not match",
            );
          });
        }
      }
  }

  ///////////////---------get location-------------////////////////////
  getCurrentLocation() async {
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;

    placeMarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);

    Placemark pMark = placeMarks![0];

    completeAddress ='${pMark.subThoroughfare} ${pMark.thoroughfare} ${pMark.subLocality}  ${pMark.locality} , ${pMark.subAdministrativeArea} , ${pMark.administrativeArea}   ${pMark.postalCode} , ${pMark.country}';

        locationController.text=completeAddress;
  }

  void authenticateSellerAndSignUp()async
  {
    User? currentUser;

    await firebaseAuth.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim(),
    ).then((auth){
      currentUser=auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context, builder: (c)
      {
        return ErrorDialog(
          message: error.message.toString(),
        );
      });
    });
    
    
    if(currentUser!=null)
      {
          saveDataTOFirestore( currentUser!).then((value){
          Navigator.pop(context);
          Route newRoute=MaterialPageRoute(builder: (c)=>const HomeScreen());
          Navigator.pushReplacement(context, newRoute);
        });
      }
  }

  Future saveDataTOFirestore(User currentUser)async
  {
    FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).set({
      "sellerUID":currentUser.uid,
      "sellerEmail":currentUser.email,
      "sellerName":nameController.text.trim(),
      "sellerAvatarUrl":sellerImageUrl,
      "phone":phoneController.text.trim(),
      "address":completeAddress.trim(),
      "status":"approved",
      "earnings":0.0,
      "lat":position!.latitude,
      "long":position!.longitude
    });

    sharedPreferences=await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);
  }



  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 10, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  _getImage();
                },
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.15,
                  backgroundColor: Colors.white54,
                  backgroundImage: imageXFile == null
                      ? null
                      : FileImage(File(imageXFile!.path)),
                  child: imageXFile == null
                      ? Icon(
                          Icons.add_photo_alternate,
                          size: MediaQuery.of(context).size.width * 0.15,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      data: Icons.person,
                      controller: nameController,
                      hintText: "Name",
                      isObscure: false,
                    ),
                    CustomTextField(
                      data: Icons.email,
                      controller: emailController,
                      hintText: "Email",
                      isObscure: false,
                    ),
                    CustomTextField(
                      data: Icons.phone,
                      controller: phoneController,
                      hintText: "Phone Number",
                      isObscure: false,
                    ),
                    CustomTextField(
                      data: Icons.lock,
                      controller: passwordController,
                      hintText: "Password",
                      isObscure: true,
                    ),
                    CustomTextField(
                      data: Icons.lock,
                      controller: confirmPasswordController,
                      hintText: "Confirm Password",
                      isObscure: true,
                    ),
                    CustomTextField(
                      data: Icons.my_location,
                      controller: locationController,
                      hintText: "Restaurant Address",
                      isObscure: false,
                      enabled: true,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      width: 400,
                      height: 50,
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        label: const Text(
                          "Get my Current Location",
                          style: TextStyle(color: Colors.black),
                        ),
                        icon: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        onPressed: () {
                              determinePosition();
                              getCurrentLocation();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.purpleAccent,
                  padding: const EdgeInsets.only(
                      left: 50, right: 50, top: 10, bottom: 10),
                ),
                // ignore: avoid_print
                onPressed: () => {
                  formValidation()
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

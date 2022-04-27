// ignore_for_file: unnecessary_import

import 'dart:async';
import 'package:lottie/lottie.dart';
// import 'package:page_transition/page_transition.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sellers_app_project/authentication/auth_screen.dart';
import 'package:sellers_app_project/global/global.dart';
import 'package:sellers_app_project/mainScreens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    // ignore: prefer_const_constructors
    Timer(const Duration(seconds: 4), () async {
      if(firebaseAuth.currentUser!=null) {
        Navigator.of(context).push(CustomPageRoute(child: const HomeScreen()));
      }
      else{
        Navigator.of(context).push(CustomPageRoute(child: const AuthScreen()));
      }
    });
  }
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('images/food-beverage.json',width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.width*0.7),
               // Image.asset("images/splash.jpg"),
              const SizedBox(height: 10,),
              const Padding(padding: EdgeInsets.all(8.0),
              child: Text(
                "Sell Food Online",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontFamily: 'Signtara',
                ),
              ),)
            ],
          ),
        ),
      ),
    );
    // if (firebaseAuth.currentUser != null)
    // {
    //   return AnimatedSplashScreen(
    //     splash: Column(
    //       children: [
    //         Lottie.asset('images/food-beverage.json'),
    //         Container(
    //           padding: const EdgeInsets.all(50),
    //           child: const Text(
    //             "Sell Food Online",
    //             textAlign: TextAlign.center,
    //             style: TextStyle(
    //               color: Colors.black54,
    //               fontSize: 35,
    //               fontFamily: 'Signtara',
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //     backgroundColor: Colors.white,
    //     splashIconSize: (MediaQuery
    //         .of(context)
    //         .size
    //         .width * 0.7) + (MediaQuery
    //         .of(context)
    //         .size
    //         .height * 0.4),
    //     duration: 2000,
    //     splashTransition: SplashTransition.fadeTransition,
    //     pageTransitionType: PageTransitionType.leftToRightWithFade,
    //     animationDuration: const Duration(seconds: 3),
    //     nextScreen: const HomeScreen(),
    //   );
    // }
    // else
    //   {
    //     return AnimatedSplashScreen(
    //       splash: Column(
    //         children: [
    //           Lottie.asset('images/food-beverage.json'),
    //           Container(
    //             padding: const EdgeInsets.all(50),
    //             child: const Text(
    //               "Sell Food Online",
    //               textAlign: TextAlign.center,
    //               style: TextStyle(
    //                 color: Colors.black54,
    //                 fontSize: 35,
    //                 fontFamily: 'Signtara',
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //       backgroundColor: Colors.white,
    //       splashIconSize: (MediaQuery
    //           .of(context)
    //           .size
    //           .width * 0.7) + (MediaQuery
    //           .of(context)
    //           .size
    //           .height * 0.4),
    //       duration: 2000,
    //       splashTransition: SplashTransition.fadeTransition,
    //       pageTransitionType: PageTransitionType.leftToRightWithFade,
    //       animationDuration: const Duration(seconds: 3),
    //       nextScreen: const AuthScreen(),
    //     );
    //   }
  }
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  CustomPageRoute({
    required this.child,
  }) : super(
          transitionDuration: const Duration(seconds: 1),
          // ignore: non_constant_identifier_names
          pageBuilder: (context, animation, SecondaryAnimation) => child,
        );
  @override
  Widget buildTransitions(
          BuildContext context,
          Animation<double> animation,
          // ignore: avoid_renaming_method_parameters
          Animation<double> secondaryAnimation,
          Widget child) =>
      ScaleTransition(
        scale: animation,
        child: child,
      );
}

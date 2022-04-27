import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app_project/splash_screen/splashScreen.dart';

void main() async{
  runApp(const MyApp());
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sellers App',
      theme: ThemeData(
        // useMaterial3: true
        primarySwatch: Colors.blueGrey,
      ),
      home: const MySplashScreen(),
    );
  }
}

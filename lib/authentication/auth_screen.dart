import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app_project/authentication/login.dart';
import 'package:sellers_app_project/authentication/register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.green,
              Colors.yellowAccent
            ])
          ),
        ),
        automaticallyImplyLeading: false,
        title: const Text('Suck My Food',
        style: TextStyle(
          fontSize: 40,
          //color: Colors.white,
          fontFamily: 'Lobster',
        ),),
        centerTitle: true,
        bottom: const TabBar(
            tabs: [
          Tab(
            icon: Icon(Icons.lock,color: Colors.white,),
            text: "Login",
          ),
              Tab(
                icon: Icon(Icons.person,color: Colors.white,),
                text: "Register",
              ),
        ],
        indicatorColor: Colors.white38,
        indicatorWeight: 6 ,),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin:Alignment.topRight,
            end:Alignment.bottomLeft,
              colors: [
                Colors.yellowAccent ,
                Colors.orange,
              ],
          )
        ),
        child: const TabBarView(
          children: [
            LoginScreen(),
            RegisterScreen(),
          ],
        ),
      ),
    ),
    );
  }
}

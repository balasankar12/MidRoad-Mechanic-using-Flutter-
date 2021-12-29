import 'package:midroadmechanic/adminpage/admin.dart';
import 'package:midroadmechanic/loginpage/adminlogin.dart';
import 'package:midroadmechanic/homepage.dart';
import 'package:midroadmechanic/loginpage/usersignup.dart';
import 'package:midroadmechanic/loginpage/userlogin.dart';
import 'package:midroadmechanic/loginpage/mechlogin.dart';
import 'package:midroadmechanic/userpage/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:midroadmechanic/mechpage/mechanic.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MID-ROAD MECHANIC',
      initialRoute: HomePage.id,
      routes: {
        HomePage.id:(context)=>const HomePage(),
        UserLogin.id:(context)=>const UserLogin(),
        UserSignUp.id:(context)=>const UserSignUp(),
        MechLogin.id:(context)=>const MechLogin(),
        AdminLogin.id:(context)=>const AdminLogin(),
        UserPage.id:(context)=>const UserPage(),
        MechanicPage.id:(context)=>const MechanicPage(),
        AdminPage.id:(context)=>const AdminPage(),
      },
    );
  }
}
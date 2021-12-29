import 'package:flutter/material.dart';
import 'package:midroadmechanic/loginpage/userlogin.dart';
import 'package:midroadmechanic/loginpage/mechlogin.dart';
import 'package:midroadmechanic/loginpage/adminlogin.dart';


class HomePage extends StatefulWidget {
  static const String id = 'homepage';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        title: Text('MIDROAD MECH'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/image/bgimage.png',
                  height: 350,
                  width: 350,
                ),
                SizedBox(
                  height:20.0,
                ),
                SizedBox(
                  height: 80,
                  width: 350,
                  child: (ElevatedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, UserLogin.id);
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.blue,onPrimary: Colors.white),
                    child: const Text('CUSTOMER',
                        style:TextStyle(
                          fontSize: 30,
                        )
                    ),
                  )),
                ),
                SizedBox(
                  height:20.0,
                ),
                SizedBox(
                  height: 80,
                  width: 350,
                  child: (ElevatedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, MechLogin.id);
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.blue,onPrimary: Colors.white),
                    child: const Text('MECHANIC',
                        style:TextStyle(
                          fontSize: 30,
                        )
                    ),
                  )),
                ),
               const SizedBox(
                  height:20.0,
                ),
                SizedBox(
                  height: 80,
                  width: 350,
                  child: (ElevatedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, AdminLogin.id);
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.blue,onPrimary: Colors.white),
                    child: const Text('ADMIN',
                        style:TextStyle(
                          fontSize: 30,
                        )
                    ),
                  )),
                )
              ]
            )
          ),
        ),
      ),
    );
  }
}

import 'usersignup.dart';
import 'package:midroadmechanic/userpage/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserLogin extends StatefulWidget {
  static const String id = 'userlogin';
  const UserLogin({Key? key}) : super(key: key);

  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  TextEditingController _mailcontroller = TextEditingController();
  TextEditingController _passcontroller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  bool _showPassword = false;
  String email='';
  String password='';

  var firestoreInstance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          centerTitle: true,
          title: Text('USER LOGIN'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
                child:Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/image/cust.png',
                        height: 230,
                        width: 220,
                      ),
                      const SizedBox(
                        height:20.0,
                      ),
                      TextField(
                        controller: _mailcontroller,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value){
                          email = value;
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            hintText: 'Mail',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.black),
                            )
                        ),
                      ),
                      const SizedBox(
                        height:20.0,
                      ),
                      TextField(
                        controller: _passcontroller,
                        obscureText:!this._showPassword,
                        onChanged: (value){
                          password = value;
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Password',
                            suffixIcon: IconButton(
                                icon:Icon(Icons.remove_red_eye,
                                color:this._showPassword?Colors.blue:Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                this._showPassword = !this._showPassword;
                              });
                            },
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.black),
                            )
                        ),
                      ),
                      const SizedBox(
                        height: 1.0,
                      ),

                      // TextButton(
                      //   onPressed: () {},
                      //   child: const Align(alignment: Alignment(-1.1,1.0),
                      //     child:Text('Forget Password?',
                      //         style: TextStyle(
                      //           color: Colors.blue,
                      //         ),
                      //         textAlign: TextAlign.left),),
                      // ),
                      const SizedBox(
                        height: 10.5,
                      ),

                      SizedBox(
                        height:60,
                        width:350,
                        child:(
                            ElevatedButton(
                              onPressed: () async{
                                setState((){
                                  showSpinner =true;
                                });
                                try{
                                  UserCredential user = await _auth.signInWithEmailAndPassword(
                                      email: email, password: password);
                                  var userdet = await FirebaseFirestore.instance.collection('user').doc(email).get();
                                  if (user != null && userdet.exists) {
                                     Navigator.pushNamed(context, UserPage.id);
                                  }
                                  else if(user != null){
                                    accountdeleted();
                                  }
                                  else{
                                    invalidlogin();
                                  }
                                  setState(() {
                                    showSpinner = false;
                                  });
                                }
                                catch(e){

                                  showDialog(context: context, builder: (BuildContext context) =>(AlertDialog(
                                    title: const Text("ERROR!"),
                                    content:  Text(e.toString()),
                                    actions: [
                                      new FlatButton(
                                        child: const Text("Ok"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ))
                                  );
                                }
                                _mailcontroller.clear();
                                _passcontroller.clear();
                              },
                              style: ElevatedButton.styleFrom(primary: Colors.blue,onPrimary: Colors.white),
                              child: const Text('SIGN IN',
                                  style:TextStyle(
                                    fontSize: 30,
                                  )
                              ),
                            )
                        ),
                      ),



                      const SizedBox(
                        height: 1.0,
                      ),

                      Row(
                        children: [
                          const Text("Don't have any Account?",),
                          TextButton(
                            onPressed: (){
                              Navigator.pushNamed(context, UserSignUp.id);
                            },
                            child:const Text('Sign up',
                                textAlign: TextAlign.left),),
                        ],
                      ),
                    ],
                  ),
                )
            ),
          ),
        )
    );
  }
  invalidlogin(){
    showDialog(context: context, builder: (BuildContext context) =>(AlertDialog(
      title: const Text("ALERT!"),
      content: const Text('Invalid UserName or Password'),
      actions: [
        new FlatButton(
          child: const Text("Ok"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
      backgroundColor: Colors.transparent,
    ))
    );
  }
  accountdeleted(){
    showDialog(context: context, builder: (BuildContext context) =>(AlertDialog(
      title: const Text("ALERT!"),
      content: const Text('Your Account has been Deleted by Admin'),
      actions: [
        new FlatButton(
          child: const Text("Ok"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
      backgroundColor: Colors.transparent,
    ))
    );
  }
}

class Firestore {
  static var instance;
}

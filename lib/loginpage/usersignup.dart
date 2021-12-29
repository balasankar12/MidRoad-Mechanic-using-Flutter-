import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'userlogin.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({Key? key}) : super(key: key);
  static const String id= 'usersignup';
  @override
  _UserSignUpState createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner=false;
  bool _showPassword = false;
  String name='';
  String email='';
  String number='';
  String password='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child:Center(
            child: SingleChildScrollView(
                child:Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      const SizedBox(
                        height:50.0,
                      ),
                      Text("SIGNUP",
                        style:TextStyle(
                          fontWeight:FontWeight.w900,
                          fontSize: 50,
                          foreground: Paint()
                            ..style = PaintingStyle.fill
                            ..color = Colors.blueAccent,
                        ),),
                      const SizedBox(
                        height:20.0,
                      ),
                      TextField(
                        keyboardType: TextInputType.name,
                        onChanged: (value){
                          name = value;
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'User Name',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.black),
                            )
                        ),
                      ),
                      const SizedBox(
                        height:20.0,
                      ),
                      TextField(
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
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          number = value;
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            hintText: 'Number',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.black),
                            )
                        ),
                      ),

                      const SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        obscureText: !this._showPassword,
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
                        height: 20.0,
                      ),

                      SizedBox(
                        height:60,
                        width:350,
                        child:(
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  final newUser = await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
                                  FirebaseFirestore.instance.collection('user').doc(email).set({'mail':email,'name':name,'number':number,'password':password});
                                  showDialog(context: context, builder: (BuildContext context) =>(AlertDialog(
                                    title: const Text("SUCCESS"),
                                    content:  Text("SIGN UP SUCCESSFULLY"),
                                    actions: [
                                      new FlatButton(
                                        child: const Text("Ok"),
                                        onPressed: () => Navigator.pushNamed(context, UserLogin.id),
                                      ),
                                    ],
                                  ))
                                  );
                                  setState((){
                                    showSpinner=false;
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
                              },
                              child: const Text('SIGN UP',
                                  style:TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  )
                              ),
                            )
                        ),
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),

                      Row(
                        children: [
                          const Text("Already have any Account?",),
                          TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child:const Text('Sign in',
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
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'mechlogin.dart';
import 'package:image_picker/image_picker.dart';


class MechSignUp extends StatefulWidget {
  static const String id= 'mechsignup';
  final double latitude;
  final double longitude;
  final String address;
  MechSignUp({required this.address, required this.latitude, required this.longitude});
  @override
  _MechSignUpState createState() => _MechSignUpState();
}

class _MechSignUpState extends State<MechSignUp> {
  final _auth = FirebaseAuth.instance;
  bool _showPassword = false;
  bool showSpinner=false;
  String name='';
  String email='';
  String number='';
  String password='';
  String available='';
  String service='';
  String id='';
  File? _postImageFile;
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
                            hintText: 'Number',
                            prefixIcon: Icon(Icons.phone),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.black),
                            )
                        ),
                      ),
                      const SizedBox(
                        height:20.0,
                      ),
                      TextField(
                        keyboardType: TextInputType.text,
                        onChanged: (value){
                          available = value;
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.timer),
                            hintText: 'Available',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.black),
                            )
                        ),
                      ),

                      const SizedBox(
                        height:20.0,
                      ),

                      TextField(
                        keyboardType: TextInputType.text,
                        onChanged: (value){
                          service = value;
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.home_repair_service),
                            hintText: 'Service',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.black),
                            )
                        ),
                      ),

                      const SizedBox(
                        height:20.0,
                      ),
                      TextField(
                        obscureText: !_showPassword,
                        onChanged: (value){
                          password = value;
                        },
                        decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock),
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

                      Row(
                        children:[
                          const SizedBox(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.location_pin
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Text(
                                widget.address
                            ),
                          ),
                        ]
                        ),

                      const SizedBox(
                        height: 20.0,
                      ),
                      ListTile(
                        title: Text("Tap to add a proof",
                            style:TextStyle(
                              color: Colors.blueAccent,
                            )),
                        leading: Icon(Icons.add_photo_alternate),
                        onTap: _getImageAndCrop,
                      ),
                      _postImageFile != null ? Image.file(_postImageFile!, fit: BoxFit.fill,) : Container(),
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
                                  String postImageURL;
                                  if(_postImageFile != null) {
                                    final newUser = await _auth.createUserWithEmailAndPassword(
                                        email: email, password: password);
                                    String userid=newUser.user!.uid;
                                    Geoflutterfire geo = Geoflutterfire();
                                    GeoFirePoint location=geo.point(latitude: widget.latitude, longitude: widget.longitude);
                                    postImageURL = (await uploadPostImages(mail: email, postImageFile: _postImageFile as File))!.toString();
                                    FirebaseFirestore.instance.collection('mechanic').doc(email).set({'userid':userid,'mail':email,'name':name,'number':number,'available':available,'service':service,'location':location.data,'address':widget.address,'password':password,'proof':postImageURL,'status':"pending"});
                                  }
                                  showDialog(context: context, builder: (BuildContext context) =>(AlertDialog(
                                    title: const Text("Success"),
                                    content:  Text('SignedIn Successfully'),
                                    actions: [
                                      new FlatButton(
                                        child: const Text("Ok"),
                                        onPressed: () => Navigator.pushNamed(context, MechLogin.id),
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
                              Navigator.pushNamed(context, MechLogin.id);
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
  Future<void> _getImageAndCrop() async {

    try {
      final imageFileFromGallery = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(imageFileFromGallery == null) return;
      final img = File(imageFileFromGallery.path);
      setState(() {
        _postImageFile = img;
      });
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  static Future<String?> uploadPostImages({required String mail, required File postImageFile}) async {
    try {
      String fileName = 'mec_proof/$mail/proof';
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = reference.putFile(postImageFile);
      TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() => print('upload completed'));
      String postImageURL = await storageTaskSnapshot.ref.getDownloadURL();
      return postImageURL;
    }catch(e) {
      return null;
    }
  }

}


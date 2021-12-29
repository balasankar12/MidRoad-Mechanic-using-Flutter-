import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:image_picker/image_picker.dart';

import 'mechanic.dart';

class verify extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String address;
  final String name;
  final String email;
  final String number;
  final String password;
  final String available;
  final String service;
  final String id;
  final String postImageFile;
  verify({required this.address, required this.latitude, required this.longitude, required this.email, required this.service, required this.name,required this.password ,required this.number, required this.postImageFile, required this.available,required this.id });

  @override
  _verifyState createState() => _verifyState();
}

class _verifyState extends State<verify> {
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
                      Text("UPDATE",
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
                      TextFormField(
                        initialValue: widget.name,
                        keyboardType: TextInputType.name,
                        onChanged: (value){
                          name = value;
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.black),
                            )
                        ),
                      ),
                      const SizedBox(
                        height:20.0,
                      ),
                      TextFormField(
                        initialValue: widget.email,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value){
                          email = value;
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.black),
                            )
                        ),
                      ),

                      const SizedBox(
                        height:20.0,
                      ),
                      TextFormField(
                        initialValue: widget.number,
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          number = value;
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.black),
                            )
                        ),
                      ),
                      const SizedBox(
                        height:20.0,
                      ),
                      TextFormField(
                        initialValue: widget.available,
                        keyboardType: TextInputType.text,
                        onChanged: (value){
                          available = value;
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.timer),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.black),
                            )
                        ),
                      ),

                      const SizedBox(
                        height:20.0,
                      ),

                      TextFormField(
                        initialValue: widget.service,
                        keyboardType: TextInputType.text,
                        onChanged: (value){
                          service = value;
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.home_repair_service),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.black),
                            )
                        ),
                      ),

                      const SizedBox(
                        height:20.0,
                      ),
                      TextFormField(
                        initialValue: widget.password,
                        obscureText: !_showPassword,
                        onChanged: (value){
                          password = value;
                        },
                        decoration: InputDecoration(
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
                        title: Text("Tap to update a proof",
                            style:TextStyle(
                              color: Colors.blueAccent,
                            )),
                        leading: Icon(Icons.add_photo_alternate),
                        onTap: _getImageAndCrop,
                      ),
                      _postImageFile != null ? Image.file((_postImageFile)!, fit: BoxFit.fill) : Image.network(widget.postImageFile, fit: BoxFit.fill,),
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
                                  String postImageURL='';
                                  if(_postImageFile != null) {
                                    postImageURL = (await uploadPostImages(mail: widget.email, postImageFile: _postImageFile as File)).toString();
                                  }
                                  Geoflutterfire geo = Geoflutterfire();
                                  GeoFirePoint location=geo.point(latitude: widget.latitude, longitude: widget.longitude);
                                  FirebaseFirestore.instance.collection('mechanic').doc(widget.email).set({'userid':widget.id,'mail':email!=''?email:widget.email,'name':name!=''?name:widget.name,'number':number!=''?number:widget.number,'available':available!=''?available:widget.available,'service':service!=''?service:widget.service,'location':location.data,'address':widget.address,'password':password!=''?password:widget.password,'proof':postImageURL!=''?postImageURL:widget.postImageFile,'status':"pending"});
                                  showDialog(context: context, builder: (BuildContext context) =>(AlertDialog(
                                    title: const Text("Success"),
                                    content:  Text('Updated Successfully'),
                                    actions: [
                                      new FlatButton(
                                        child: const Text("Ok"),
                                        onPressed: () => Navigator.pushNamed(context, MechanicPage.id),
                                      ),
                                    ],
                                  ))
                                  );
                                  setState((){
                                    showSpinner=false;
                                  });
                                }
                                catch(e){
                                  print(e);
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
                              child: const Text('UPDATE',
                                  style:TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  )
                              ),
                            )
                        ),
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

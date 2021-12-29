import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:midroadmechanic/loginpage/mechlogin.dart';
import 'package:midroadmechanic/mechpage/verification.dart';

class MechanicPage extends StatefulWidget {
  const MechanicPage({Key? key}) : super(key: key);
  static const String id='mechanicpage';
  @override
  _MechanicPageState createState() => _MechanicPageState();
}

class _MechanicPageState extends State<MechanicPage> {
  static final User? user = FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser = FirebaseUser();
  final _selectedItemColor = Colors.grey;
  final _unselectedItemColor = Colors.white;


  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        loggedInUser = user as FirebaseUser;
      }
    } catch (e) {
      print(e);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, MechLogin.id);
              }),
        ],
        title: Text('MIDROAD MECH'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection("mechanic").doc(user!.email).get(),
        builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot){
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return Center(
                child: SingleChildScrollView(
                  child:Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/image/mechanic.png',
                          height: 130,
                          width: 120,
                        ),
                        const SizedBox(
                          height:20.0,
                        ),
                        TextFormField(
                          initialValue: data['name'],
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person,size: 20,),
                              enabledBorder: InputBorder.none
                          ),
                          style: TextStyle(fontSize: 20,color: Colors.blueAccent),
                        ),
                        const SizedBox(
                          height:5.0,
                        ),
                        TextFormField(
                          initialValue: data['mail'],
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.mail,size: 20,),
                              enabledBorder: InputBorder.none
                          ),
                          style: TextStyle(fontSize: 20,color: Colors.blueAccent),
                        ),

                        const SizedBox(
                          height:5.0,
                        ),
                        TextFormField(
                          initialValue: data['number'],
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.phone,size: 20,),
                              enabledBorder: InputBorder.none
                          ),
                          style: TextStyle(fontSize: 20,color: Colors.blueAccent),
                        ),
                        const SizedBox(
                          height:5.0,
                        ),
                        TextFormField(
                          initialValue: data['available'],
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.timer,size: 20,),
                              enabledBorder: InputBorder.none
                          ),
                          style: TextStyle(fontSize: 20,color: Colors.blueAccent),
                        ),
                        const SizedBox(
                          height:5.0,
                        ),
                        TextFormField(
                          initialValue: data['service'],
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.home_repair_service,size: 20),
                              enabledBorder: InputBorder.none
                          ),
                          style: TextStyle(fontSize: 20,color: Colors.blueAccent),
                        ),
                        const SizedBox(
                          height:5.0,
                        ),
                        TextFormField(
                          initialValue: data['address'],
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.location_pin,size: 20,),
                              enabledBorder: InputBorder.none
                          ),
                          style: TextStyle(fontSize: 20,color: Colors.blueAccent),
                        ),
                        const SizedBox(
                          height:5.0,
                        ),
                        TextFormField(
                          initialValue: data['status'],
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.pending,size: 20,),
                              enabledBorder: InputBorder.none
                          ),
                          style: TextStyle(fontSize: 20,color: Colors.blueAccent),
                        ),

                        const SizedBox(
                          height: 5.0,
                        ),
                        SizedBox(
                          height:60,
                          width:350,
                          child:(
                              ElevatedButton(
                                onPressed: () async{
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=> verify(address: data['address'],latitude: data['location']['geopoint'].latitude,longitude: data['location']['geopoint'].longitude,id: data['userid'],name: data['name'],email: data['mail'],number: data['number'],available: data['available'],service: data['service'],postImageFile: data['proof'],password: data['password'],) ));
                                },
                                style: ElevatedButton.styleFrom(primary: Colors.blue,onPrimary: Colors.white),
                                child: const Text('UPDATE',
                                    style:TextStyle(
                                      fontSize: 30,
                                    )
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            );
          }

          return Text("loading");
        },
      ),
    );
  }
}

class FirebaseUser {
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import '../constants/colors.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);
  static const String id = 'adminpage';
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser = FirebaseUser();
  int _currentIndex = 0;
  final _selectedItemColor = Colors.grey;
  final _unselectedItemColor = Colors.white;
  final List<Widget> _children = [
    StreamBuilder<QuerySnapshot>(
      // <2> Pass `Stream<QuerySnapshot>` to stream
        stream: FirebaseFirestore.instance.collection("user").snapshots(),
        builder: (context,snapshot) {
          if (!snapshot.hasData ) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
              children: (snapshot.data)!.docs.map((document) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    color: Colors.black12,
                  ),
                  width: double.infinity,
                  height: 120,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                            width: 70,
                            height: 70,
                            margin: EdgeInsets.only(right: 15),
                            child: Image(image: AssetImage('assets/image/cust.png'))),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              document['name'],
                              style: TextStyle(
                                  color: primary, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.mail,
                                  color: secondary,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(document['mail'],
                                    style: TextStyle(
                                        color: primary, fontSize: 13, letterSpacing: .3)),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.call,
                                  color: secondary,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(document['number'],
                                    style: TextStyle(
                                        color: primary, fontSize: 13, letterSpacing: .3)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );})
                  .toList());
        }
    ),
    StreamBuilder<QuerySnapshot>(
      // <2> Pass `Stream<QuerySnapshot>` to stream
        stream: FirebaseFirestore.instance.collection("mechanic").where('status',isEqualTo: 'approved').snapshots(),
        builder: (context,snapshot) {
          if (!snapshot.hasData || snapshot.connectionState==ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
              children: (snapshot.data)!.docs.map((document) {
                return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                      color: Colors.black12,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: [
                              Center(
                                child: Container(
                                    width: 120,
                                    height: 180,
                                    margin: EdgeInsets.only(right: 10),
                                    child: Image(image: AssetImage('assets/image/mechanic.png'))),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      document['name'],
                                      style: TextStyle(
                                          color: primary, fontWeight: FontWeight.bold, fontSize: 24),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.mail,
                                          color: secondary,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(document['mail'],
                                            style: TextStyle(
                                                color: primary, fontSize: 13, letterSpacing: .3)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.call,
                                          color: secondary,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(document['number'],
                                            style: TextStyle(
                                                color: primary, fontSize: 13, letterSpacing: .3)),
                                      ],
                                    ),

                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.timer,
                                          color: secondary,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(document['available'],
                                            style: TextStyle(
                                                color: primary, fontSize: 13, letterSpacing: .3)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.home_repair_service,
                                          color: secondary,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(document['service'],
                                            style: TextStyle(
                                                color: primary, fontSize: 13, letterSpacing: .3)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_pin,
                                          color: secondary,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Text(document['address'],
                                              style: TextStyle(
                                                  color: primary, fontSize: 13, letterSpacing: .3)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.pending,
                                          color: secondary,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(document['status'],
                                            style: TextStyle(
                                                color: Colors.green, fontSize: 13, letterSpacing: .3)),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.add_a_photo,
                                          color: secondary,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        TextButton(
                                          onPressed: (){
                                            showDialog(context: context, builder: (BuildContext context) =>(AlertDialog(
                                              content: PinchZoom(
                                                child: Image.network(document['proof'],height: 500,),
                                                resetDuration: const Duration(milliseconds: 100),
                                                maxScale: 2.5,
                                              ),
                                              backgroundColor: Colors.transparent,
                                            ))
                                            );
                                          },
                                          child:const Text('Click to view Proof',style: TextStyle(
                                              color: Colors.blueAccent, fontSize: 13, letterSpacing: .3)),),
                                      ],
                                    ),
                                    SizedBox(
                                      height:40,
                                      width:150,
                                      child:(
                                          ElevatedButton(
                                            onPressed: () async {
                                              try {
                                                FirebaseFirestore.instance.collection('mechanic').doc(document['mail']).delete();
                                                showDialog(context: context, builder: (BuildContext context) =>(AlertDialog(
                                                  title: const Text("ALERT!"),
                                                  content:  Text("Rejected Mechanic"),
                                                  actions: [
                                                    new FlatButton(
                                                      child: const Text("Ok"),
                                                      onPressed: () => Navigator.pop(context),
                                                    ),
                                                  ],
                                                ))
                                                );
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
                                            child: const Text('REJECT',
                                                style:TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                )
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:MaterialStateProperty.all(Colors.redAccent),
                                            ),
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                );})
                  .toList());
        }
    ),
    StreamBuilder<QuerySnapshot>(
      // <2> Pass `Stream<QuerySnapshot>` to stream
        stream: FirebaseFirestore.instance.collection("mechanic").where('status',isEqualTo: 'pending').snapshots(),
        builder: (context,snapshot) {
          if (!snapshot.hasData || snapshot.connectionState==ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
              children: (snapshot.data)!.docs.map((document) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    color: Colors.black12,
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: [
                            Center(
                              child: Container(
                                  width: 120,
                                  height: 180,
                                  margin: EdgeInsets.only(right: 10),
                                  child: Image(image: AssetImage('assets/image/mechanic.png'))),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    document['name'],
                                    style: TextStyle(
                                        color: primary, fontWeight: FontWeight.bold, fontSize: 24),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.mail,
                                        color: secondary,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(document['mail'],
                                          style: TextStyle(
                                              color: primary, fontSize: 13, letterSpacing: .3)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.call,
                                        color: secondary,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(document['number'],
                                          style: TextStyle(
                                              color: primary, fontSize: 13, letterSpacing: .3)),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.timer,
                                        color: secondary,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(document['available'],
                                          style: TextStyle(
                                              color: primary, fontSize: 13, letterSpacing: .3)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.home_repair_service,
                                        color: secondary,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(document['service'],
                                          style: TextStyle(
                                              color: primary, fontSize: 13, letterSpacing: .3)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_pin,
                                        color: secondary,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(document['address'],
                                            style: TextStyle(
                                                color: primary, fontSize: 13, letterSpacing: .3)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.pending,
                                        color: secondary,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(document['status'],
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 13, letterSpacing: .3)),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.add_a_photo,
                                        color: secondary,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      TextButton(
                                        onPressed: (){
                                          showDialog(context: context, builder: (BuildContext context) =>(AlertDialog(
                                            content: PinchZoom(
                                              child: Image.network(document['proof'],height: 500,),
                                              resetDuration: Duration(milliseconds: 100),
                                              maxScale: 2.5,
                                            ),
                                            backgroundColor: Colors.transparent,
                                          ))
                                          );
                                        },
                                        child:Text('Click to view Proof',style: TextStyle(
                                            color: Colors.blueAccent, fontSize: 13, letterSpacing: .3)),),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        height:40,
                                        width:90,
                                        child:(
                                            ElevatedButton(
                                              onPressed: () async {
                                                try {
                                                  FirebaseFirestore.instance.collection('mechanic').doc(document['mail']).update({'status':'approved'});
                                                  showDialog(context: context, builder: (BuildContext context) =>(AlertDialog(
                                                    title: const Text("ALERT!"),
                                                    content:  Text("Approved Mechanic $document[name]"),
                                                    actions: [
                                                      new FlatButton(
                                                        child: const Text("Ok"),
                                                        onPressed: () => Navigator.pop(context),
                                                      ),
                                                    ],
                                                  ))
                                                  );
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
                                              child: Text('APPROVE',
                                                  style:TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  )
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:MaterialStateProperty.all(Colors.green),
                                              ),
                                            )
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        height:40,
                                        width:80,
                                        child:(
                                            ElevatedButton(
                                              onPressed: () async {
                                                try {
                                                  FirebaseFirestore.instance.collection('mechanic').doc(document['mail']).delete();
                                                  showDialog(context: context, builder: (BuildContext context) =>(AlertDialog(
                                                    title: const Text("ALERT!"),
                                                    content:  Text("Rejected Mechanic "),
                                                    actions: [
                                                      new FlatButton(
                                                        child: const Text("Ok"),
                                                        onPressed: () => Navigator.pop(context),
                                                      ),
                                                    ],
                                                  ))
                                                  );
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
                                              child: Text('REJECT',
                                                  style:TextStyle(
                                                    color: Colors.white,
                                                    fontSize:   10,
                                                  )
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:MaterialStateProperty.all(Colors.green),
                                              ),
                                            )
                                        ),
                                      ),],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )

                    ],
                  ),
                );})
                  .toList());
        }
    ),
    // Text(
    //   "FEEDBACK",
    // ),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Color _getItemColor(int index) =>
      _currentIndex == index ? _selectedItemColor : _unselectedItemColor;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('MIDROAD MECH'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(child: _children[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlueAccent,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'USER DETAILS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'MECH DETAILS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'MECH APPROVEL',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.search),
          //   label: 'FEEDBACK',
          // ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        onTap: onTabTapped,
      ),
    );
  }
}


class FirebaseUser {
}

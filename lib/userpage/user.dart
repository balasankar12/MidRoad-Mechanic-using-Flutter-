import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:midroadmechanic/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPage extends StatefulWidget {
  static const String id = 'userpage';
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Position currentPosition;
  late Position? initPos = getPosition();

  String userEmail='';
  static User? user = FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;
  // FirebaseUser loggedInUser = FirebaseUser();
  int _currentIndex = 1;
  final _selectedItemColor = Colors.grey;
  final _unselectedItemColor = Colors.white;
  bool showSpinner=false;
  bool _showPassword = false;
  String username='';
  String useremail='';
  String usernumber='';
  String uservehicle='';
  String userproblem='';

  Future<Position> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getPosition() {
    getUserLocation().then((value) {
      print('Map Co-ordinates');
      print(value);
      setState(() {
        initPos = value;
      });
      initPos = value;
    });
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    getPosition();
  }


  // void getCurrentUser() async {
  //   try {
  //     final user = await _auth.currentUser!;
  //     if (user != null) {
  //       loggedInUser = user as FirebaseUser;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }




  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Color _getItemColor(int index) =>
      _currentIndex == index ? _selectedItemColor : _unselectedItemColor;

  @override
  void initState() {
    try{
      locatePosition();
    }
    catch (e){
      showDialog(context: context, builder: (BuildContext context) =>(AlertDialog(
        title: const Text("ERROR!"),
        content:  Text("Turn ON the Location......."),
        actions: [
          new FlatButton(
            child: const Text("Ok"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ))
      );
    }
    // getuserdetails();
    super.initState();
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
                  Navigator.pop(context);
                }),
          ],
          title: Text('MID-ROAD MECH'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: bottomtabs(),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.lightBlueAccent,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'FIND MECH',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'YOU',
              ),
            ],
            currentIndex: _currentIndex,
            selectedItemColor: Colors.white,
            onTap: onTabTapped,
          ),
    );
  }
  bottomtabs(){
    var res;
    if(_currentIndex==0){
      final geo = Geoflutterfire();
      GeoFirePoint center = geo.point(latitude: currentPosition.latitude, longitude: currentPosition.longitude);
      final _firestore = FirebaseFirestore.instance;
      var collectionReference = _firestore.collection('mechanic').where('status',isEqualTo: 'approved');
      double radius = 4;
      String field = 'location';

      Stream<List<DocumentSnapshot>> postsStream = geo.collection(collectionRef: collectionReference)
          .within(center: center, radius: radius, field: field,strictMode: true);
      res=StreamBuilder<List<DocumentSnapshot>>(
        // <2> Pass `Stream<QuerySnapshot>` to stream
          stream: postsStream,
          builder: (context,snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
                children: (snapshot.data)!.map((document) {
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
                        Center(
                          child: Container(
                              width: 120,
                              height: 170,
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
                                  Expanded(
                                    child: Text(document['mail'],
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
                                height:40,
                                width:150,
                                child:(
                                    ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          launchWhatsApp(number : document['number']);
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
                                      child: const Text('Connect',
                                          style:TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          )
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:MaterialStateProperty.all(Colors.blueAccent),
                                      ),
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );})
                    .toList());
          }
      );
      return res;
    }
    else if(_currentIndex==1){
      res=FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection("user").doc(user!.email).get(),
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
                          'assets/image/cust.png',
                          height: 230,
                          width: 220,
                        ),
                        const SizedBox(
                          height:20.0,
                        ),
                        TextFormField(
                          initialValue: data['name'],
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
                          initialValue: data['mail'],
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
                          initialValue: data['number'],
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color:Colors.black),
                              )
                          ),
                        ),

                        const SizedBox(
                          height: 20.0,
                        ),

                      ],
                    ),
                  ),
                )
            );
          }
          return CircularProgressIndicator();
        }
      );
      return res;
    }
    return res;
  }
  void launchWhatsApp({@required number}) async {

    String url = "whatsapp://send?phone=91$number";

    await canLaunch(url) ? launch(url) : print("cant open whatsapp");
  }
  //
  // Future<void> getuserdetails() async {
  //   var snap = FirebaseFirestore.instance
  //         .collection('user')
  //         .doc(user!.email)
  //         .get() ;
  //   username=snap['name'].toString();
  //   useremail=snap['mail'];
  //   usernumber=snap['number'];
  //   print(username);
  //   }
   }

// class FirebaseUser {
// }

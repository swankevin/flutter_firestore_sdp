import 'package:auth_realtimedb/view/account_screen.dart';
import 'package:auth_realtimedb/view/add_screen.dart';
import 'package:auth_realtimedb/view/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  //final List<MenuItem> items;
  //final ValueChanged<int> onTabSelected;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase fb = FirebaseDatabase.instance;
  TextEditingController satu = TextEditingController();
  TextEditingController dua = TextEditingController();
  var array;
  var item;
  var k;

  @override
  Widget build(BuildContext context) {
    //int selectedIndex = 0;
    final ref = fb.ref().child('items');

    const TextStyle optionStyle =
        TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AddScreen(),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          scale: 1.5,
          'assets/images/intalogi.png',
          fit: BoxFit.cover,
        ),
      ),
      body: FirebaseAnimatedList(
        query: ref,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {
          var val = snapshot.value.toString();
          item = val.replaceAll(RegExp("{|}|text1: |text2: "), "");
          item.trim();

          array = item.split(',');
          return GestureDetector(
            onTap: () {
              setState(() {
                k = snapshot.key;
              });

              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: TextField(
                      controller: satu,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Name',
                      ),
                    ),
                  ),
                  content: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: TextField(
                      controller: dua,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Value',
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      color: Color.fromARGB(255, 0, 22, 145),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        await update();
                        Navigator.of(ctx).pop();
                      },
                      color: Color.fromARGB(255, 0, 22, 145),
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Color.fromARGB(255, 218, 185, 144),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 255, 0, 0),
                    ),
                    onPressed: () {
                      ref.child(snapshot.key!).remove();
                    },
                  ),
                  title: Text(
                    array[0],
                    // 'dd',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    array[1],
                    // 'dd',

                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      endDrawer: Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
                child: ListView(
              children: <Widget>[
                _drawerHeader(),
                _drawerItem(
                    icon: Icons.accessible, text: 'Menu1', onTap: () {}),
                _drawerItem(
                    icon: Icons.access_alarm, text: 'Menu2', onTap: () {}),
                _drawerItem(icon: Icons.abc, text: 'Menu3', onTap: () {}),
              ],
            )),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                children: <Widget>[
                  const Divider(),
                  _drawerItem(
                      icon: Icons.power_settings_new,
                      text: 'Logout',
                      onTap: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          print('Succesfully signed out');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (SignInScreen())));
                        });
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[],
        ),
        shape: CircularNotchedRectangle(),
        color: Colors.blueGrey,
      ),
    );
  }

  Widget _drawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: Colors.amber),
      // currentAccountPicture: ClipOval(
      //   child: Image(
      //       image: AssetImage('assets/images/photo1.png'), fit: BoxFit.cover),
      // ),
      // otherAccountsPictures: [
      //   ClipOval(
      //     child: Image(
      //         image: AssetImage('assets/images/photo2.jpg'), fit: BoxFit.cover),
      //   ),
      //   ClipOval(
      //     child: Image(
      //         image: AssetImage('assets/images/photo3.png'), fit: BoxFit.cover),
      //   )
      // ],
      accountName: Text('${_auth.currentUser?.uid}'),
      accountEmail: Text('${_auth.currentUser?.email}'),
    );
  }

  Widget _drawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  update() async {
    DatabaseReference ref1 = FirebaseDatabase.instance.ref("items/$k");

    await ref1.update({
      "text1": satu.text,
      "text2": dua.text,
    });
    satu.clear();
    dua.clear();
  }
}

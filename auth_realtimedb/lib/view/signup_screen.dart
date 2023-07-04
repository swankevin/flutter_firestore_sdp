import 'package:auth_realtimedb/util/color.dart';
import 'package:auth_realtimedb/util/reusables.dart';
import 'package:auth_realtimedb/view/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  hexStringtoColor("FFEA4F"),
                  hexStringtoColor("FFB749"),
                  hexStringtoColor("FF9B4D"),
                  hexStringtoColor("FF4040"),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    reusableTextField("Enter Username", Icons.person_outline,
                        false, _usernameController),
                    const SizedBox(height: 20),
                    reusableTextField("Enter E-mail Address",
                        Icons.mail_outline, false, _emailController),
                    const SizedBox(height: 20),
                    reusableTextField("Enter Password", Icons.lock_outline,
                        true, _passwordController),
                    const SizedBox(height: 20),
                    signButton(context, false, () {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text)
                          .then((value) {
                        print(
                            'New account ${_emailController.text} has been created.');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      }).onError((error, stackTrace) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error ${error.toString()}')));
                        print('Error ${error.toString()}');
                      });
                    }),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              title: const Text(''), // You can add title here
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor:
                  hexStringtoColor("FFD84D"), //You can make this transparent
              elevation: 0.0, //No shadow
            ),
          ),
        ],
      ),
    );
  }
}

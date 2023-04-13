import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignUpScreen({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  double? deviceHeight, deviceWidth;

  TextEditingController tfcPass = TextEditingController();
  TextEditingController tfcEmail = TextEditingController();
  TextEditingController cnfmPassController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();

  @override
  void dispose() {
    tfcEmail.dispose();
    tfcPass.dispose();
    cnfmPassController.dispose();
    fNameController.dispose();
    lNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.red[200],
      body: SafeArea(
        child: Container(
          // decoration: BoxDecoration(border:),
          height: deviceHeight! * 0.80,
          padding: const EdgeInsets.all(20),
          child: loginCard(),
        ),
      ),
    );
  }

  Widget loginCard() {
    return SingleChildScrollView(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'SignUp',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: fNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'First name...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: lNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Last name...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: tfcEmail,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Email...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tfcPass,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  labelText: 'Password...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: cnfmPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  labelText: 'Confirm Password...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              signBtn(),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("I am a member.",
                      style: TextStyle(color: Colors.black)),
                  TextButton(
                    onPressed: widget.showLoginPage,
                    // Navigator.pushNamed(context, 'signUp');
                    child: const Text(
                      "Login now",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget signBtn() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black),
          ),
          backgroundColor: Colors.white),
      onPressed: signUp,
      child: const Text(
        "SignUp",
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
      // ScaffoldMessenger.of(context).showSnackBar(snackBarr);
    );
  }

  SnackBar snackBar(String text) {
    return SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Add your code here to undo the action
        },
      ),
    );
  }

  Future signUp() async {
    if (passConfirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: tfcEmail.text,
        password: tfcPass.text,
      );

      userDetails(
        fNameController.text.trim(),
        lNameController.text.trim(),
        tfcEmail.text.trim(),
      );
    }
  }

  bool passConfirmed() {
    final snackBarr = snackBar("enter correct pass");
    if (tfcPass.text.trim() == cnfmPassController.text.trim()) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBarr);
      return false;
    }
  }

  Future userDetails(String fName, String lName, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'fName': fName,
      'lName': lName,
      'email': email,
    });
  }
}

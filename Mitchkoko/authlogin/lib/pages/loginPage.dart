import 'package:authlogin/pages/forgetpasspage.dart';
import 'package:authlogin/pages/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showSignUpPage;
  const LoginPage({super.key, required this.showSignUpPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double? deviceHeight, deviceWidth;

  TextEditingController tfcUserName = TextEditingController();
  TextEditingController tfcPass = TextEditingController();

  Future Signin() async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    final snackBarr = snackBar();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: tfcUserName.text.trim(),
        password: tfcPass.text.trim(),
      )
          .then((userCredential) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
    Navigator.of(context).pop();

      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarr);
    }
    Navigator.of(context).pop();
  }

  // Future signIn() async {
  //   final snackBarr = snackBar();
  //   UserCredential userCredential =
  //       await FirebaseAuth.instance.signInWithEmailAndPassword(
  //     email: tfcUserName.text.trim(),
  //     password: tfcPass.text.trim(),
  //   );

  //   if (userCredential != null) {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => HomePage()));
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(snackBarr);
  //   }
  // }

  @override
  void dispose() {
    tfcUserName.dispose();
    tfcPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Container(
          // decoration: BoxDecoration(border:),
          height: deviceHeight! * 0.70,
          padding: EdgeInsets.all(20),
          child: loginCard(),
        ),
      ),
    );
  }

  Widget loginCard() {
    return SingleChildScrollView(
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: tfcUserName,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Username...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: tfcPass,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  labelText: 'Password...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 14,
              ),
              loginBtn(),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgetPassPagState()));
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?",
                      style: TextStyle(color: Colors.black)),
                  TextButton(
                    onPressed: widget.showSignUpPage,
                    // Navigator.pushNamed(context, 'signUp');

                    child: const Text(
                      "Register now",
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

  Widget loginBtn() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.black),
          ),
          backgroundColor: Colors.white),
      child: const Text(
        "Login",
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
      onPressed: Signin,
      // ScaffoldMessenger.of(context).showSnackBar(snackBarr);
    );
  }

  SnackBar snackBar() {
    return SnackBar(
      content: const Text('Incorrect Id and Password'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Add your code here to undo the action
        },
      ),
    );
  }
}

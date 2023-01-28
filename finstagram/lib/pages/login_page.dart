import 'dart:io';
import 'package:finstagram/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double? deviceHeight, deviceWidth;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  String? email, password;

  FirebaseService? firebaseService;

  @override
  void initState() {
    super.initState();
    firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: deviceWidth! * 0.05,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                titleWidget(),
                loginForm(),
                loginBtn(),
                signupPageLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleWidget() {
    return const Text(
      "Finstagram",
      style: TextStyle(
        color: Colors.black,
        fontSize: 30,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget loginForm() {
    return Container(
      height: deviceHeight! * 0.20,
      child: Form(
        key: loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            emailTxtField(),
            passTxtField(),
          ],
        ),
      ),
    );
  }

  Widget emailTxtField() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "Email..."),
      onSaved: (value) {
        setState(() {
          email = value;
        });
      },
      validator: (value) {
        bool result = value!.contains(RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"));
        return result ? null : "Please enter valid Email";
      },
    );
  }

  Widget passTxtField() {
    return TextFormField(
        obscureText: true,
        decoration: const InputDecoration(hintText: "Password..."),
        onSaved: (value) {
          setState(() {
            password = value;
          });
        },
        validator: (value) =>
            value!.length > 6 ? null : "Enter min 6 charcter");
  }

  Widget loginBtn() {
    return MaterialButton(
      onPressed: userLogin,
      minWidth: deviceWidth! * 0.60,
      height: deviceHeight! * 0.06,
      color: Colors.red,
      child: const Text(
        "Login",
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget signupPageLink() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'signup'),
      child: const Text(
        "Don't have an account?",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 15,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  void userLogin() async {
    if (loginFormKey.currentState!.validate()) {
      loginFormKey.currentState!.save();
      bool result = await firebaseService!
          .userLogin(email: email!, password: password!);
      if (result) Navigator.popAndPushNamed(context, 'home');
    }
  }
}

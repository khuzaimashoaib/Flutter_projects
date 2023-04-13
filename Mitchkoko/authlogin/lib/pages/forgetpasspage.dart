import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassPagState extends StatefulWidget {
  const ForgetPassPagState({super.key});

  @override
  State<ForgetPassPagState> createState() => _ForgetPassPagStateState();
}

class _ForgetPassPagStateState extends State<ForgetPassPagState> {
  TextEditingController passResetCnt = TextEditingController();

  @override
  void dispose() {
    passResetCnt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter your email, we will send you pass reset link"),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: passResetCnt,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  labelText: 'Email...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black),
                  ),
                  backgroundColor: Colors.white),
              child: const Text(
                "Reset Pass",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              onPressed: passReset,
            )
          ],
        ),
      ),
    );
  }

  Future passReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: passResetCnt.text.trim(),
      );
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("pass Reset link was sent! check your inbox"),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("incorrect email"),
            );
          });
    }
  }
}

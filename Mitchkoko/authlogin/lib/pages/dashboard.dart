import 'package:authlogin/pages/loginPage.dart';
import 'package:authlogin/reading%20data/get_user_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  List<String> docsIDs = [];

  Future getDocIDs() async {
    // List<String> docsIDs = [];

    await FirebaseFirestore.instance.collection('users').get().then(
          (value) => value.docs.forEach(
            (element) {
              // print(element.reference);
              docsIDs.add(element.reference.id);
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          user.email!,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.logout),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            // Text("Signed in : " + user.email!),

            Expanded(
              child: FutureBuilder(
                future: getDocIDs(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: docsIDs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: ListTile(
                          title: GetUserName(documentIDs: docsIDs[index]),
                          tileColor: Colors.blue[200],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

//   Future<void> signOut() async {
//   await FirebaseAuth.instance.signOut();
//   Navigator.pushAndRemoveUntil(
//     context,
//     MaterialPageRoute(builder: (context) =>  LoginPage()),
//     (Route<dynamic> route) => false,
//   );
// }
}

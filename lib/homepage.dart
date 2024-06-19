import 'package:authentication/auth/categories/Note/view.dart';
import 'package:authentication/auth/categories/edit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<QueryDocumentSnapshot> data = [];
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('addcategory');
        },
        backgroundColor: Colors.purple,
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (() async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
                await FirebaseAuth.instance.signOut();
                // ignore: use_build_context_synchronously
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
              }),
              icon: const Icon(Icons.exit_to_app))
        ],
        title: const Text("Home Page"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.purple),
            )
          : ListView(
              children: [
                GridView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Viewnote(categoryid: data[i].id)));
                      },
                      onLongPress: () {
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.question,
                            animType: AnimType.rightSlide,
                            title: "What Do you wanna Do?",
                            desc: "Choose the process you wanna do",
                            btnCancelOnPress: () async {
                              await FirebaseFirestore.instance
                                  .collection("categories")
                                  .doc(data[i].id)
                                  .delete();
                              Navigator.of(context)
                                  .pushReplacementNamed("homepage");
                            },
                            btnCancelText: "Delete",
                            btnOkText: "Edit",
                            btnOkColor: Colors.purple,
                            btnOkOnPress: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditCategory(
                                      docid: data[i].id,
                                      oldname: data[i]['name'])));
                            }).show();
                      },
                      child: Card(
                          child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/abc.png', // Use Image.asset for assets
                              height: 100, // Adjusted height
                              width: 100, // Adjusted width
                            ),
                            Text("${data[i]['name']}"),
                          ],
                        ),
                      )),
                    );
                  },
                  shrinkWrap:
                      true, // Added to make the GridView size based on its contents
                  physics:
                      NeverScrollableScrollPhysics(), // Disable GridView scrolling inside a ListView
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10, // Adjusted spacing
                    crossAxisSpacing: 10, // Added cross-axis spacing
                  ),

                  // Add more Card widgets for additional items in the grid
                ),
              ],
            ),
    );
  }
}

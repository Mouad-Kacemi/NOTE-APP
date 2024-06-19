import 'package:authentication/auth/categories/Note/add.dart';
import 'package:authentication/auth/categories/Note/edit.dart';
import 'package:authentication/auth/categories/edit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Viewnote extends StatefulWidget {
  final String categoryid;
  const Viewnote({super.key, required this.categoryid});

  @override
  State<Viewnote> createState() => _ViewnoteState();
}

class _ViewnoteState extends State<Viewnote> {
  bool isLoading = true;
  List<QueryDocumentSnapshot> data = [];
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryid)
        .collection("note")
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
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddNote(docid: widget.categoryid),
          ));
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
        title: const Text("Notes"),
      ),
      body: WillPopScope(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(color: Colors.purple),
              )
            : ListView(
                children: [
                  GridView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onLongPress: () {
                          AwesomeDialog(
                              context: context,
                              dialogType: DialogType.question,
                              animType: AnimType.rightSlide,
                              title: "Delete a Note",
                              desc: "Are you sure from doing this process?",
                              btnOkOnPress: () async {
                                await FirebaseFirestore.instance
                                    .collection("categories")
                                    .doc(widget.categoryid)
                                    .collection("note")
                                    .doc(data[i].id)
                                    .delete();
                                if (data[i]['url' != "none"])
                                  FirebaseStorage
                                      .instance.refFromURL(data[i]['url']).delete();
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      Viewnote(categoryid: widget.categoryid),
                                ));
                              }).show();
                        },
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditNote(
                                notedocid: data[i].id,
                                categorydocid: widget.categoryid,
                                value: data[i]['note']),
                          ));
                        },
                        child: Card(
                            child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text("${data[i]['note']}"),
                              SizedBox(
                                height: 10,
                              ),
                              if (data[i]['url'] != 'none')
                                Image.network(
                                  data[i]['url'],
                                  height: 80,
                                )
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
        onWillPop: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("homepage", (route) => false);
          return Future.value(false);
        },
      ),
    );
  }
}

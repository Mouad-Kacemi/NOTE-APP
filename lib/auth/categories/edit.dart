

import 'package:authentication/components/buttonauth.dart';
import 'package:authentication/components/customform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  final String docid;
  final String oldname;
  const EditCategory({super.key, required this.docid, required this.oldname});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  bool isLoading = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  Future<void> editCategory(BuildContext context) async {
    try {
      isLoading = true;
      setState(() {});
      // Call the user's CollectionReference to add a new user
      await categories
          .doc(widget.docid)
          .set({"name": name.text}, SetOptions(merge: true));
      // Set = add()
      // Set = update() if and only if merge = true
      // Set =! update() if and only if merge = false

      Navigator.of(context)
          .pushNamedAndRemoveUntil("homepage", (route) => false);
    } catch (error) {
      isLoading = false;
      setState(() {});
      // If an error occurs, print the error
      print("Failed to add user: $error");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState

    name.text = widget.oldname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Category")),
      body: Form(
        key: formState,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : Column(children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: ContainerTextFormAdd(
                    hinttext: "Enter Name",
                    mycontroller: name,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be Empty";
                      }
                    },
                  ),
                ),
                ButtonAuth(
                  title: "Save",
                  onPressed: () {
                    editCategory(context);
                  },
                )
              ]),
      ),
    );
  }
}

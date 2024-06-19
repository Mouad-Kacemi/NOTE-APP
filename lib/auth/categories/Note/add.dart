import 'dart:io';

import 'package:path/path.dart';
import 'package:authentication/auth/categories/Note/view.dart';
import 'package:authentication/components/buttonauth.dart';
import 'package:authentication/components/customform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({super.key, required this.docid});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  File? file;
  String? url;

  getImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.

// Capture a photo.
    final XFile? photocamera =
        await picker.pickImage(source: ImageSource.gallery);
    if (photocamera != null) {
      file = File(photocamera!.path);
      var imaagename = basename(photocamera!.path);
      var refStorage = FirebaseStorage.instance.ref("images/$imaagename");
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
    }
    setState(() {});
  }

  bool isLoading = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  final TextEditingController note = TextEditingController();

  Future<void> addNote(BuildContext context) async {
    try {
      CollectionReference collerctionnote = FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.docid)
          .collection("note");
      isLoading = true;
      setState(() {});
      // Call the user's CollectionReference to add a new user
      DocumentReference response =
          await collerctionnote.add({"note": note.text, "url": url ?? "none"});

      // If adding user is successful, navigate to homepage
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Viewnote(categoryid: widget.docid),
        ),
      );
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
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Note")),
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
                    hinttext: "Write your Note here",
                    mycontroller: note,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be Empty";
                      }
                    },
                  ),
                ),
                ButtonAuthupload(
                  title: "Upload Image",
                  isSelected: url == null ? false : true,
                  onPressed: () async {
                    await getImage();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ButtonAuth(
                  title: "Add",
                  onPressed: () {
                    addNote(context);
                  },
                )
              ]),
      ),
    );
  }
}

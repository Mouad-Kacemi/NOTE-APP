

import 'package:authentication/auth/categories/Note/view.dart';
import 'package:authentication/components/buttonauth.dart';
import 'package:authentication/components/customform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  final String notedocid;
  final String value;
  final String categorydocid;

  const EditNote({
    Key? key,
    required this.notedocid,
    required this.categorydocid,
    required this.value,
  }) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  bool isLoading = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  final TextEditingController note = TextEditingController();

  Future<void> editNote(BuildContext context) async {
    CollectionReference collerctionnote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categorydocid)
        .collection("note");

    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        await collerctionnote.doc(widget.notedocid).update({"note": note.text});

        // If updating the note is successful, navigate to the view note page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Viewnote(categoryid: widget.categorydocid),
          ),
        );
      } catch (error) {
        isLoading = false;
        setState(() {});
        // If an error occurs, print the error
        print("Failed to update note: $error");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    note.text = widget.value;
    super.initState();
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
      appBar: AppBar(title: Text("Edit")),
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
                ButtonAuth(
                  title: "Save",
                  onPressed: () {
                    editNote(context);
                  },
                )
              ]),
      ),
    );
  }
}




import 'package:path/path.dart';
import 'package:authentication/components/buttonauth.dart';
import 'package:authentication/components/customform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
   
  bool isLoading = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  Future<void> addUser(BuildContext context) async {
    try {
      isLoading = true;
      setState(() {
        
      });
      // Call the user's CollectionReference to add a new user
      DocumentReference response = await categories.add(
          {"name": name.text, "id": FirebaseAuth.instance.currentUser!.uid});

      // If adding user is successful, navigate to homepage
      Navigator.of(context)
          .pushNamedAndRemoveUntil("homepage", (route) => false);
    } catch (error) {
      isLoading = false;
      setState(() {
        
      });
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Category")),
      body: Form(
        key: formState,
        child:isLoading? Center(child: CircularProgressIndicator(color: Colors.purple,),) : Column(children: [
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
            title: "Add",
            onPressed: () {
              addUser(context);
            },
          )
        ]),
      ),
    );
  }
}

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FilterFirestore extends StatefulWidget {
  const FilterFirestore({super.key});

  @override
  State<FilterFirestore> createState() => _FilterFirestoreState();
}

class _FilterFirestoreState extends State<FilterFirestore> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Picker')),
      body: Container(
        child: Column(children: [
          MaterialButton(
            onPressed: () async {
              await getImage();
            },
            child: Text('Take a Picture!'),
          ),
          if (url != null) Image.network(url!)
        ]),
      ),
    );
  }
}








































// class FilterFirestore extends StatefulWidget {
//   const FilterFirestore({super.key});

//   @override
//   State<FilterFirestore> createState() => _FilterFirestoreState();
// }

// class _FilterFirestoreState extends State<FilterFirestore> {
//   List<QueryDocumentSnapshot> data = [];

//   final Stream<QuerySnapshot> _userstream =
//       FirebaseFirestore.instance.collection("users").snapshots();

//   @override
//   void initState() {
//     // TODO: implement initState

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Filter')),
//       body: Container(
//           child: StreamBuilder(
//         stream: _userstream,
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error');
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Text('Loading ...');
//           }
//           return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: ((context, index) {
//                 return InkWell(
//                   onTap: () {
//                     DocumentReference documentReference = FirebaseFirestore
//                         .instance
//                         .collection('users')
//                         .doc(snapshot.data!.docs[index].id);
//                     FirebaseFirestore.instance
//                         .runTransaction((transaction) async {
//                       DocumentSnapshot snapshot =
//                           await transaction.get(documentReference);
//                       if (snapshot.exists) {
//                         var snapshotData = snapshot.data();
//                         if (snapshotData is Map<String, dynamic>) {
//                           int money = snapshotData['money'] + 100;
//                           transaction
//                               .update(documentReference, {"money": money});
//                         }
//                       }
//                     });
//                   },
//                   child: Card(
//                     child: ListTile(
//                       trailing: Text(
//                         '${snapshot.data!.docs[index]['money']}\$',
//                         style: TextStyle(
//                             color: Colors.red,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18),
//                       ),
//                       subtitle: Text("${snapshot.data!.docs[index]['age']}"),
//                       title: Text(
//                         "${snapshot.data!.docs[index]['username']}",
//                         style: TextStyle(fontSize: 30),
//                       ),
//                     ),
//                   ),
//                 );
//               }));
//         },
//       )),
//     );
//   }
// }
  // floatingActionButton: FloatingActionButton(
  //         child: Icon(Icons.add),
  //         onPressed: () {
  //           CollectionReference users =
  //               FirebaseFirestore.instance.collection('users');
  //           DocumentReference doc1 =
  //               FirebaseFirestore.instance.collection("users").doc("1");
  //           DocumentReference doc2 =
  //               FirebaseFirestore.instance.collection("users").doc("2");
  //           WriteBatch batch = FirebaseFirestore.instance.batch();
  //           batch
  //               .set(doc1, {"username": "Daniel", "money": 20000, "age": "19"});
  //           batch.set(doc2, {"username": "Lyna", "money": 50, "age": "19"});
  //           batch.commit();
  //         }),
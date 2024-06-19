import 'package:authentication/components/buttonauth.dart';
import 'package:authentication/components/logoauth.dart';
import 'package:authentication/components/textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _LoginState();
}

class _LoginState extends State<SignUp> {
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  final TextEditingController _controllerPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const LogoAuth(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("SignUp",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("SignUp To Continue using The App",
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                  const Text(
                    "Username",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  ContainerTextForm(
                      hinttext: "Enter Your Username",
                      mycontroller: _controllerUsername),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  ContainerTextForm(
                    hinttext: "Enter Your Email",
                    mycontroller: _controllerEmail,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  ContainerTextForm(
                      hinttext: "Enter Your Password",
                      mycontroller: _controllerPassword),
                  Container(
                    margin:
                        const EdgeInsets.only(top: 10, bottom: 20, right: 10),
                    alignment: Alignment.topRight,
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(fontSize: 13, color: Colors.purple),
                    ),
                  ),
                ],
              ),
            ),
            ButtonAuth(
              title: "SignUp",
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: _controllerEmail.text,
                    password: _controllerPassword.text,
                  );
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                  Navigator.of(context).pushReplacementNamed("login");
                } on FirebaseAuthException catch (e) {
                  print("Firebase Auth Exception: $e");
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  print("Error during sign-up: $e");
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("login");
              },
              child: const Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: "Have An Account ? "),
                  TextSpan(
                      text: "Login",
                      style: TextStyle(
                          color: Colors.purple, fontWeight: FontWeight.bold))
                ])),
              ),
            )
          ],
        ),
      ),
    );
  }
}

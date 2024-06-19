import 'dart:typed_data';

import 'package:authentication/components/buttonauth.dart';
import 'package:authentication/components/logoauth.dart';
import 'package:authentication/components/textformfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
            clientId:
                "458254541238-2ctrctu5rr7r1el7a6hv6tr7ddbpfsn3.apps.googleusercontent.com")
        .signIn();
    if (googleUser == null) {
      return;
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.purple),
            )
          : Container(
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
                        const Text("Login",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        const Text("Login To Continue using The App",
                            style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 20),
                        const Text(
                          "Email",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        ContainerTextForm(
                            hinttext: "Enter Your Password",
                            mycontroller: _controllerPassword),
                        InkWell(
                          onTap: () async {
                            if (_controllerEmail.text == "") {
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      animType: AnimType.rightSlide,
                                      title: "Warning",
                                      desc:
                                          "Please Fill The Email Box To continue...")
                                  .show();
                              return;
                            }
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                      email: _controllerEmail.text);
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.success,
                                      animType: AnimType.rightSlide,
                                      title: "Check Your Email!",
                                      desc:
                                          "We have sent a link to your email where you can change your password !")
                                  .show();
                            } catch (e) {
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: "Error",
                                      desc:
                                          "The EMAIL that you have entered is not correct please use a correct one or sign up !")
                                  .show();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 10, bottom: 20, right: 10),
                            alignment: Alignment.topRight,
                            child: const Text(
                              "Forgot Password?",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.purple),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ButtonAuth(
                    title: "Login",
                    onPressed: () async {
                      if (formState.currentState!.validate()) {
                        try {
                          setState(() {
                            isLoading = true;
                          });

                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _controllerEmail.text,
                                  password: _controllerPassword.text);

                          if (credential.user!.emailVerified) {
                            Navigator.of(context).pushNamed("homepage");
                          } else {
                            AwesomeDialog(
                                context: _scaffoldKey.currentState!.context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: "Verify Your Email !",
                                desc:
                                    "Please check your email and follow the link of verification in order to activate your account")
                              ..show();
                          }
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            isLoading = false;
                          });

                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                            AwesomeDialog(
                                context: _scaffoldKey.currentState!.context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: "Error",
                                desc: "No user found for that email.")
                              ..show();
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                            AwesomeDialog(
                                context: _scaffoldKey.currentState!.context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: "Error",
                                desc: "Wrong password provided for that user.")
                              ..show();
                          } else {
                            print('FirebaseAuthException: ${e.message}');
                            AwesomeDialog(
                                context: _scaffoldKey.currentState!.context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: "Error",
                                desc:
                                    "An error occurred during authentication. Please try again later.")
                              ..show();
                          }
                        }
                      } else {
                        print('Not Valid');
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    height: 45,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.white,
                    textColor: Colors.white,
                    onPressed: () {
                      signInWithGoogle();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Login With Google  ",
                          style: TextStyle(color: Colors.black),
                        ),
                        Image.asset(
                          "assets/images/google.png",
                          width: 35,
                          height: 35,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("signup");
                    },
                    child: const Center(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: "Don't Have An Account ? "),
                        TextSpan(
                            text: "SignUp",
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold))
                      ])),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

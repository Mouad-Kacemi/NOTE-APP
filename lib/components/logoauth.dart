import 'package:flutter/material.dart';

class LogoAuth extends StatelessWidget {
  const LogoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(5),
                    child: const Image(
                      image: AssetImage("assets/images/jiji.png"),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(70)),
                  ),
                );
  }
}
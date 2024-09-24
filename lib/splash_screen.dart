import 'package:cat_app/hompage.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MySplash extends StatefulWidget {
  const MySplash({super.key});

  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset("assets/images/logo.jpg",),
      backgroundColor: Colors.white,
      title:  Text("Cat Breed Identifier",textAlign: TextAlign.center,style: GoogleFonts.laila(fontSize: 50,fontWeight: FontWeight.bold,color: Colors.pink),),
      loadingText: Text("From Shiv_17_3d",style: GoogleFonts.langar(fontSize: 16,color: Colors.pink),),
      loaderColor: Colors.red,
      futureNavigator:Future.delayed(const Duration(seconds: 8),() => const MyHomePage()),
      //backgroundImage: const AssetImage("assets/images/back.jpg"),
      logoWidth: 180,


    );
  }
}

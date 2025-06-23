import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Admin_SignUP.dart';
import 'User_SignUp.dart';

class RolesScreen extends StatefulWidget {
  const RolesScreen({super.key});

  @override
  State<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 70,),
          Center(child: Text("Role Selection",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),)),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>UserSignUpScreen()));
            },
            child: Container(
              height: 90,
              width: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: [const Color.fromARGB(255, 168, 226, 252),const Color.fromARGB(255, 151, 207, 252)])
              ),
              child: Center(child: Text("Student",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminSignUpScreen()));
            },
            child: Container(
              height: 90,
              width: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: [const Color.fromARGB(255, 228, 211, 255),const Color.fromARGB(255, 207, 170, 253)])
              ),
              child: Center(child: Text("Admin",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),),
            ),
          ),
          Spacer(),
          Container(
            width: double.infinity,
            height: 250,
            child: ClipRRect(
              child: SvgPicture.network("https://res.cloudinary.com/dgxs9qaml/image/upload/v1750318883/Water_drop-rafiki_eeovkg.svg",fit: BoxFit.cover,),
            ),
          ),

        ],
      ),
    );
  }
}
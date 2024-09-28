import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/constants/strings/home.dart';
import '../../domain/utils/functions.dart';
import '../../domain/utils/responcive.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FullScreenImage extends StatelessWidget {
  final String id;
  final String imageUrl;
  const FullScreenImage({super.key, required this.id, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // Extract the ID and URL from the route parameters

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
              height: ScreenSizes(context).screenHeight(),
              child: Image.asset(
                backgroundImg,
                fit: BoxFit.cover,
              )),
          Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: ScreenSizes(context).screenHeightFraction(percent: 8),
                    width: ScreenSizes(context).screenWidth(),
                    child: Row(
                      children: [
                       const SizedBox(
                          width: 30,
                        ),
                        InkWell(
                            onTap: () {
                             
                              if (context.canPop()) {
                                context.pop();
                              } else {
                        
                              }
                    
                            },
                            child:const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                  Text(cleanAndCapitalize(id),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        letterSpacing: 10,
                        fontSize: context.isPhone ? 20 : 50,
                      )),
                  SizedBox(
                    height: ScreenSizes(context).screenHeightFraction(percent: 5),
                    width: ScreenSizes(context).screenWidth(),
                  ),
                ],
              ),
              Center(
                child: SizedBox( height: ScreenSizes(context).screenHeightFraction(percent: 70), child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(imageUrl, fit: BoxFit.contain))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

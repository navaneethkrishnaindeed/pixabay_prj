import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

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
  const FullScreenImage({required this.id, required this.imageUrl});

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
                    height: ScreenSizes(context).screenHeightFraction(percent: 5),
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
                                // context.go('/home');
                              }
                              // GoRouter.of(context).pop();
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                  Text(cleanAndCapitalize(id),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: context.isPhone ? 20 : 50,
                      )),
                  SizedBox(
                    height: ScreenSizes(context).screenHeightFraction(percent: 5),
                    width: ScreenSizes(context).screenWidth(),
                  ),
                ],
              ),
              Center(
                child: SizedBox(width: ScreenSizes(context).screenWidth(), height: ScreenSizes(context).screenHeightFraction(percent: 70), child: Image.network(imageUrl, fit: BoxFit.contain)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

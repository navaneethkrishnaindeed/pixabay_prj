import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


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
  const FullScreenImage({required this.id,required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // Extract the ID and URL from the route parameters

    return Scaffold(
      appBar: AppBar(title: Text("imageName")),
      body: Center(
        child: Image.network(imageUrl, fit: BoxFit.contain),
      ),
    );
  }
}

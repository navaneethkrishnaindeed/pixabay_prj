import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:pixabay_prj/presentation/home/home.dart';

import '../domain/constants/debug_status.dart';
import '../domain/routes/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pixabay App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: Home(),
      routerConfig: AppRouter.appRouter,
      // routerDelegate:AppRouter.appRouter.routerDelegate ,
      // routeInformationParser: AppRouter.appRouter.routeInformationParser,
      debugShowCheckedModeBanner: DebugStatus.IS_DEBUG,
      
      
    );
  }
}


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/instance_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:pixabay_prj/domain/dependency_injection/injectable.dart';
import 'package:pixabay_prj/presentation/home/widgets/webview.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../application/home/home_controller.dart';
import '../../domain/api/dio_client.dart';
// import '../../domain/api/endPoints.dart';
import '../../domain/api/endpoints.dart';
import '../../domain/routes/route_names.dart';
import '../../infrastructure/image_search_repo.dart/i_repo.dart';
import 'widgets/mobileview.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

/*

 PLease note that because this is a simple page i am redirecting
 all layouts to the HomeWebView where the responcive is checked 
 to avoid code redundancy 

 in case of complex layouts wil shall use diffrent Widgets 

*/
      body: ScreenTypeLayout.builder(
        mobile: (_) => const HomeWebView(),
        tablet: (_) => const HomeWebView(),
        desktop: (_) => const HomeWebView(),
      ),
    );
  }
}

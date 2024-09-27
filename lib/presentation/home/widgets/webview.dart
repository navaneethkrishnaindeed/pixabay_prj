import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:popup_banner/popup_banner.dart';

import '../../../application/home/home_controller.dart';
import '../../../domain/utils/responcive.dart';

class HomeWebView extends StatefulWidget {
  const HomeWebView({super.key});

  @override
  State<HomeWebView> createState() => _HomeWebViewState();
}

class _HomeWebViewState extends State<HomeWebView> {
  HomePageController homePageController = Get.put(HomePageController());

  @override
  void initState() {
    homePageController.getPixabayPcs(searchKey: "");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: ScreenSizes(context).screenHeightFraction(percent: 5),
          width: ScreenSizes(context).screenWidth(),
        ),
        Container(
            width: ScreenSizes(context).screenWidthFraction(percent: 60),
            child: TextFormField(
              controller: homePageController.searchController,
              onChanged: (value) {
                homePageController.getPixabayPcs(searchKey: value);
              },
              decoration: InputDecoration(
                  hintText: "Search For Pixabay pictures",
                  prefixIcon: SizedBox(width: ScreenSizes(context).screenWidthFraction(percent: 5), child: const Icon(Icons.search)),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  )),
            )),
        Obx(() {
          // log("hhh ${homePageController.imageList.value}");
          if (homePageController.isLoading.value) {
            return const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (homePageController.imageList.value!.isEmpty) {
            return const Expanded(
              child: Center(
                child: Text(" No Results found "),
              ),
            );
          } else {
            log("len ${homePageController.imageList.value!.length}");
            return Expanded(
              child: GridView.builder(
                // shrinkWrap: true,
                itemCount: homePageController.imageList.value!.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 330),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                       context.go('/image/${homePageController.imageList.value![index].webformatURL.split('/').last}', extra: {
                        'url': homePageController.imageList.value![index].webformatURL,
                        'id': homePageController.imageList.value![index].webformatURL.split('/').last,
                      }
               
                          );
                    },
                    child: Container(
                      margin: EdgeInsets.all(ScreenSizes(context).screenWidthFraction(percent: 1)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            homePageController.imageList.value![index].webformatURL,
                            fit: BoxFit.cover,
                          )),
                    ),
                  );
                },
              ),
            );
          }
        })
      ],
    );
  }
}

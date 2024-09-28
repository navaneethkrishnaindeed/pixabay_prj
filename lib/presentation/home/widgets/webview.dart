import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
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

ScrollController scrollController = ScrollController();

class _HomeWebViewState extends State<HomeWebView> {
  HomePageController homePageController = Get.put(HomePageController());
  int cri = 0;
  final GlobalKey gridKey = GlobalKey(); // Key for the GridView

  double scrollOffset = 0; // To store the current scroll offset

  @override
  void initState() {
    homePageController.getPixabayPcs(searchKey: "");
    // scrollController.addListener(_onScroll);

    super.initState();
  }

  void _onScroll() async {
    if (homePageController.isLoading.value) return;
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      homePageController.pageNum.value++;
      log("Loading more: ${homePageController.pageNum.value}");

      // Save the current scroll position
      final currentScrollPosition = scrollController.position.pixels;

      await homePageController.loadMorePixabayPcs(searchKey: homePageController.searchController.text, page: homePageController.pageNum.value);

      // After loading, jump back to the previous position
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(currentScrollPosition);
      });
    }
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
          // scrollController.jumpTo(scrollOffset);

          // log("hhh ${homePageController.imageList.value}");
          if (homePageController.isLoading.value) {
            return const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (homePageController.imageList.value!.isEmpty) {
            return const Expanded(
              child: Center(
                child: Text(" No Results found "),
              ),
            );
          } else {
            log("len ${homePageController.imageList.value!.length}");

            return Expanded(
              child: GridView.builder(
                key: gridKey,
                itemCount: homePageController.imageList.value!.length + 1,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 330),
                controller: scrollController..addListener(() async => _onScroll()),
                itemBuilder: (context, index) {
                  if (index == homePageController.imageList.value!.length) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return GestureDetector(
                      onTap: () {
                        context.go('/image/${homePageController.imageList.value![index].pageURL.split('/')[4]}', extra: {
                          'url': homePageController.imageList.value![index].webformatURL,
                          'name': homePageController.imageList.value![index].pageURL.split('/')[ homePageController.imageList.value![index].pageURL.split('/').length-2],
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(ScreenSizes(context).screenWidthFraction(percent: 1)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            homePageController.imageList.value![index].webformatURL,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          }
        })
      ],
    );
  }
}

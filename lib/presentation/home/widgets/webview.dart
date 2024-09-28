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
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:popup_banner/popup_banner.dart';

import '../../../application/home/home_controller.dart';
import '../../../domain/constants/strings/home.dart';
import '../../../domain/utils/functions.dart';
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
    homePageController.getPixabayPcs(searchKey:homePageController.searchController.text);
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
    return Stack(
      children: [
        SizedBox(
            height: ScreenSizes(context).screenHeight(),
            child: Image.asset(
              backgroundImg,
              fit: BoxFit.cover,
            )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: ScreenSizes(context).screenHeightFraction(percent: 5),
              width: ScreenSizes(context).screenWidth(),
            ),
            Text(
              "PIXABAY",
              style: GoogleFonts.inter(fontSize: context.isPhone || context.isPortrait ? 50 : 110, fontWeight: FontWeight.w700, letterSpacing: context.isPhone || context.isPortrait ? 15 : 40, color: Colors.white),
            ),
            SizedBox(
              height: ScreenSizes(context).screenHeightFraction(percent: 5),
              width: ScreenSizes(context).screenWidth(),
            ),
            SizedBox(
                width: ScreenSizes(context).screenWidthFraction(percent: context.isPhone || context.isPortrait ? 90 : 60),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  controller: homePageController.searchController,
                  onChanged: (value) {
                    homePageController.getPixabayPcs(searchKey: value);
                  },
                  decoration: InputDecoration(
                      hintText: "Search For Pixabay pictures",
                      labelStyle: const TextStyle(color: Colors.white),
                      hintStyle: const TextStyle(color: Colors.white),
                      prefixIcon: SizedBox(
                          width: ScreenSizes(context).screenWidthFraction(percent: 5),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                          )),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      )),
                )),
            SizedBox(
              height: ScreenSizes(context).screenHeightFraction(percent: 5),
              width: ScreenSizes(context).screenWidth(),
            ),
            Obx(() {
              // scrollController.jumpTo(scrollOffset);

              // log("hhh ${homePageController.imageList.value}");
              if (homePageController.isLoading.value) {
                return Expanded(
                  child: Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                );
              } else if (homePageController.imageList.value!.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Text(" No Results found ", style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                );
              } else {
                log("len ${homePageController.imageList.value!.length}");

                return Expanded(
                  child: GridView.builder(
                    key: gridKey,
                    itemCount: homePageController.imageList.value!.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 330,mainAxisSpacing: 60),
                    controller: scrollController..addListener(() async => _onScroll()),
                    itemBuilder: (context, index) {
                      if (index == homePageController.imageList.value!.length) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return GestureDetector(
                          onTap: () {
                            context.go('/image/${homePageController.imageList.value![index].pageURL.split('/')[4]}', extra: {
                              'url': homePageController.imageList.value![index].webformatURL,
                              'name': homePageController.imageList.value![index].pageURL.split('/')[homePageController.imageList.value![index].pageURL.split('/').length - 2],
                            });
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.all(ScreenSizes(context).screenWidthFraction(percent: 01)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(errImagePath);
                                      },
                                      homePageController.imageList.value![index].webformatURL,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                // height: ScreenSizes(context).screenHeightFraction(percent: 1),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Row(
                                      children: [
                                        const Icon(Icons.thumb_up_alt_rounded, color: Colors.green),
                                        const SizedBox(width: 5),
                                        Text(formatNumber(homePageController.imageList.value![index].likes.toDouble()), style: const TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        const Icon(Icons.visibility, color: Colors.white),
                                        const SizedBox(width: 5),
                                        Text(formatNumber(homePageController.imageList.value![index].views.toDouble()), style: const TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    },
                  ),
                );
              }
            })
          ],
        ),
      ],
    );
  }
}

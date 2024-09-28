import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/dependency_injection/injectable.dart';
import '../../domain/models/search_result_model/search_result_model.dart';
import '../../infrastructure/image_search_repo.dart/i_repo.dart';

class HomePageController extends GetxController with StateMixin {
  RxBool isLoading = false.obs;
  RxInt pageNum = 1.obs;
  RxInt currentIndex = 0.obs;
  Rxn<List<SearchResultModel>> imageList = Rxn<List<SearchResultModel>>();
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getPixabayPcs({required String searchKey, int page = 1}) async {
    imageList.value = [];
    isLoading.value = true;
    ISearchRepo repo = getIt<ISearchRepo>();
    try {
      imageList.value = await repo.searchImageDataFromApi(nameOfTheImagetoSearch: searchKey, page: page);
    } catch (e) {
      log("hhh $e");
      imageList.value = [];
    }

    await Future.delayed(Durations.extralong4);
    await Future.delayed(Durations.extralong4);
    isLoading.value = false;
  }

  Future<void> loadMorePixabayPcs({required String searchKey, int page = 1}) async {
    isLoading.value = true;
    ISearchRepo repo = getIt<ISearchRepo>();
    List<SearchResultModel> data = [];
    try {
      data = await repo.searchImageDataFromApi(nameOfTheImagetoSearch: searchKey, page: page);
      imageList.value!.addAll(data);
    } catch (e) {
      log("hhh $e");
      imageList.value = [];
    }

    await Future.delayed(Durations.long4);
    isLoading.value = false;
  }
}

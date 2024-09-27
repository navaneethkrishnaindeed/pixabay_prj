import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/api/dio_client.dart';
import '../../domain/api/endpoints.dart';
import '../../domain/api/exceptions.dart';
import '../../domain/dependency_injection/injectable.dart';
import '../../domain/models/search_result_model/search_result_model.dart';
import '../../infrastructure/image_search_repo.dart/i_repo.dart';

class HomePageController extends GetxController with StateMixin {
  RxBool isLoading = false.obs;
  Rxn<List<SearchResultModel>> imageList = Rxn<List<SearchResultModel>>();
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getPixabayPcs({required String searchKey}) async {
    isLoading.value = true;
    ISearchRepo repo = getIt<ISearchRepo>();
    try {
      imageList.value = await searchImageDataFromApi(nameOfTheImagetoSearch: searchKey);
    } catch (e) {
      log("hhh $e");
      imageList.value = [];
    }

    // print("jh------------");
    // log(imageList.value!.first.largeImageURL);
    isLoading.value = false;
  }
}

searchImageDataFromApi({required String nameOfTheImagetoSearch}) async {
  DioClient dio = DioClient(Dio());

  try {
    final response = await dio.request(endPoint: EndPoint.search, queryParams: {"q": nameOfTheImagetoSearch, "image_type": "photo"});

    if (response.statusCode == 200 || response.statusCode == 201) {
      final datas = (response.data['hits'] as List).map((e) {
        return SearchResultModel.fromJson(e);
      }).toList();

      print("hello ${datas[1]}");
      return datas;
    } else {
      throw InternalServerException();
    }
  } catch (e) {
    throw AppException();
  }
}

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pixabay_prj/domain/api/endpoints.dart';
import 'package:pixabay_prj/domain/models/search_result_model/search_result_model.dart';

import '../../domain/api/dio_client.dart';
import '../../domain/api/exceptions.dart';

abstract class ISearchRepo {
  searchImageDataFromApi({required String nameOfTheImagetoSearch, required int page});
}

@LazySingleton(as: ISearchRepo)
class SearchImpl implements ISearchRepo {
  @override
  searchImageDataFromApi({required String nameOfTheImagetoSearch,required int page}) async {
    DioClient dio = DioClient(Dio());

    try {
      final response = await dio.request(endPoint: EndPoint.search, queryParams: {"q": nameOfTheImagetoSearch, "image_type": "photo","page":page,"per_page":40});

      if (response.statusCode == 200 || response.statusCode == 201) {
        
        final datas = (response.data['hits'] as List).map((e) {
          return SearchResultModel.fromJson(e);
        }).toList();

        print(datas[1]);
        return datas;
      } else {
        throw InternalServerException();
      }
    } catch (e) {
       throw AppException();
    }
  }
}

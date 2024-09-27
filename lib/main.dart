import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'domain/api/dio_client.dart';
import 'domain/api/endpoints.dart';
import 'domain/dependency_injection/injectable.dart';
import 'presentation/app.dart';

Future<void> main() async {
  
 await configureInjection();
  runApp(const MyApp());
}

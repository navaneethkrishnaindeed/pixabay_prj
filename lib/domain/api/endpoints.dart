import 'api_key.dart';
import 'base_url.dart';

enum RequestType { get, post, put, patch, delete }

enum EndPoint {
  search,
 
}

// ignore: non_constant_identifier_names
final BASE_URL = API_BaseURL.getBaseURL();

extension URLExtension on EndPoint {
  String get url {
    switch (this) {
      case EndPoint.search:
        return "$BASE_URL/?key=${ApiKey.key}";
     

      default:
        throw Exception(["Endpoint not defined"]);
    }
  }
}

extension RequestMode on EndPoint {
  RequestType get requestType {
    RequestType requestType = RequestType.get;

    switch (this) {
      case EndPoint.search:
        requestType = RequestType.get;
        break;
    
    }
    return requestType;
  }
}

extension Token on EndPoint {
  bool get shouldAddToken {
    var shouldAdd = true;
    switch (this) {
      case EndPoint.search:
        shouldAdd = false;
        break;
        
      default:
        break;
    }

    return shouldAdd;
  }
}

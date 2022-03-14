import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:multi_network_api/models/unsplash_multi_model.dart';
import 'log_service.dart';

class NetworkDio {
  static bool isTester = true;

  static Dio dio = Dio(BaseOptions(baseUrl: getServer(), headers: getHeaders()));

  static String SERVER_DEVELOPMENT = "api.unsplash.com";
  static String SERVER_PRODUCTION = "api.unsplash.com/photos??page=1&per_page=3";

  static Map<String, String> getHeaders() {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Client-ID sLy7DxJOs-rkxl2TqpgNrZz89z70WV-ecUyq9VGnncg',
      'Accept-Version': 'v1',
    };
    return headers;
  }

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  /// /* Http Requests */

  static Future<String?> GET(String api, Map<String, dynamic> params) async {
    Response response = await dio.get(api, queryParameters: params);
    if (response.statusCode == 200) {
      return jsonEncode(response.data);
    }
    return null;
  }

  static Future<String?> POST(String api, Map<String, dynamic> params) async {
    Response response = await dio.post(api, data: params);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonEncode(response.data);
    }
    return null;
  }

  static Future<String?> PUT(String api, Map<String, dynamic> params) async {
    Response response = await dio.put(api, data: params);// http or https
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonEncode(response.data);
    }
    return null;
  }

  static Future<String?> PATCH(String api, Map<String, dynamic> params) async {
    Response response = await dio.patch(api, data: params);// http or https
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonEncode(response.data);
    }
    return null;
  }

  static Future<String?> DELETE(String api, Map<String, dynamic> params) async {
    Response response = await dio.delete(api, data: params);// http or https
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonEncode(response.data);
    }
    return null;
  }

  // static Future<String?> MULTIPART(String api, String filePath, Map<String,String> params) async{
  //   var uri = Uri.https(getServer(), api);
  //   var request = MultipartRequest("Post",uri);
  //
  //   request.headers.addAll(getHeaders());
  //   request.fields.addAll(params);
  //   request.files.add(await MultipartFile.fromPath("picture", filePath));
  //   var response = await request.send();
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) return response.reasonPhrase;
  //   return null;
  // }

  /// /* Http Apis */

  static String API_LIST = "/photos";
  static String API_SEARCH = "/search/photos";
  static String API_ONE = "/photos"; //{id}
  static String API_CREATE = "/api/v1/create";
  static String API_UPDATE = "/api/v1/update/"; //{id}
  static String API_DELETE = "/api/v1/delete/"; //{id}

  /// /* Http Params */

  static Map<String, dynamic> paramsSearch(String search,int number) {
    Map<String, dynamic> params = {
      'query': search,'page': number, 'per_page': 15};
    return params;
  }

  static Map<String, dynamic> paramsGetUnsplashPage(int number) {
    Map<String, dynamic> params = {'page': number, 'per_page': 15};
    return params;
  }

  // static Map<String, String> paramsCreate(Post post) {
  //   Map<String, String> params = {};
  //   params.addAll({
  //     'title': post.title!,
  //     'body': post.body!,
  //     'userId': post.userId.toString(),
  //   });
  //   return params;
  // }



  /// /* Http parsing */

  static List<Unsplash> parseUnSplashList(String response) {
    var data = unsplashFromJson(response);
    return data;
  }

  static List<Unsplash> parseUnSplashListSearch(String response) {
    var data = unsplashFromJson(jsonEncode(jsonDecode(response)['results']));
    return data;
  }

}
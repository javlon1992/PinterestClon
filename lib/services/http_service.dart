import 'dart:convert';
import 'package:http/http.dart';
import 'package:multi_network_api/models/unsplash_multi_model.dart';
import 'log_service.dart';

class Network {
  static bool isTester = true;

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

  static Future<String?> GET(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await get(uri, headers: getHeaders());
    Log.d(response.body);
    if (response.statusCode == 200) return response.body;

    return null;
  }

  static Future<String?> POST(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api); // http or https
    var response = await post(uri, headers: getHeaders(), body: jsonEncode(params));
    Log.d(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) return response.body;
    return null;
  }

  static Future<String?> PUT(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api); // http or https
    var response = await put(uri, headers: getHeaders(), body: jsonEncode(params));
    Log.d(response.body);

    if (response.statusCode == 200) return response.body;
    return null;
  }

  static Future<String?> PATCH(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api); // http or https
    var response = await patch(uri, headers: getHeaders(), body: jsonEncode(params));
    Log.d(response.body);
    if (response.statusCode == 200) return response.body;

    return null;
  }

  static Future<String?> DEL(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await delete(uri, headers: getHeaders());
    Log.d(response.body);
    if (response.statusCode == 200) return response.body;

    return null;
  }

  static Future<String?> MULTIPART(String api, String filePath, Map<String,String> params) async{
    var uri = Uri.https(getServer(), api);
    var request = MultipartRequest("Post",uri);

    request.headers.addAll(getHeaders());
    request.fields.addAll(params);
    request.files.add(await MultipartFile.fromPath("picture", filePath));
    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) return response.reasonPhrase;
    return null;
  }

  /// /* Http Apis */

  static String API_LIST = "/photos";
  static String API_SEARCH = "/search/photos";
  static String API_ONE = "/photos"; //{id}
  static String API_CREATE = "/api/v1/create";
  static String API_UPDATE = "/api/v1/update/"; //{id}
  static String API_DELETE = "/api/v1/delete/"; //{id}

  /// /* Http Params */

  static Map<String, String> paramsSearch(String search,int number) {
    Map<String, String> params = {
      'query': search,'page': number.toString(), 'per_page': "15"};
    return params;
  }

  static Map<String, String> paramsGetUnsplashPage(int number) {
    Map<String, String> params = {'page': number.toString(), 'per_page': "15"};
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

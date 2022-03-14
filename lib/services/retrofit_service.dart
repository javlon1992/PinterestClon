
import 'package:retrofit/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:multi_network_api/models/unsplash_multi_model.dart';
import 'package:retrofit/http.dart';

part 'retrofit_service.g.dart';  ///  flutter pub run build_runner build


const String SERVER_DEVELOPMENT = "api.unsplash.com";
const String SERVER_PRODUCTION = "api.unsplash.com/photos??page=1&per_page=20";

/// #CLIENT
@RestApi(baseUrl: SERVER_DEVELOPMENT)
abstract class RetroFitNetwork {
  factory RetroFitNetwork(Dio dio, {String baseUrl}) = _RetroFitNetwork; ///  flutter pub run build_runner build

  static const Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Client-ID sLy7DxJOs-rkxl2TqpgNrZz89z70WV-ecUyq9VGnncg',
    'Accept-Version': 'v1',
  };

  /// #GET
  @GET("/photos")
  Future<List<Unsplash>> getUnsplash(Map<String, dynamic> params);

  /// #GET
  @GET("/search/photos")
  Future<Unsplash> getUnsplashSearch(@Queries() Map<String,dynamic> params);

  /// #POST
  @POST("/api/v1/notes")
  @http.Headers(headers)
  Future<Unsplash> createUnsplash(@Body() Unsplash unsplash);

  /// #PUT using @Path
  @PUT("/api/v1/notes/{id}")
  @http.Headers(headers)
  Future<Unsplash> updateUnsplash(@Path() String id, @Body() Unsplash unsplash);

  /// #DELETE
  @DELETE("/api/v1/notes/{id}")
  @http.Headers(headers)
  Future<void> deleteUnsplash(@Path("id") int id);
}

class NetworkRetrofit{

  /// /* Http Params */

  static Map<String, dynamic> paramsSearch(String search,int number) {
    Map<String, dynamic> params = {
      'query': search,'page': number, 'per_page': 15};
    return params;
  }

  static Map<String, dynamic> paramsGetUnsplash(int number) {
    Map<String, dynamic> params = {'page': number, 'per_page': 15};
    return params;
  }

}
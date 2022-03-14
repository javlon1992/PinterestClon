// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retrofit_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _RetroFitNetwork implements RetroFitNetwork {
  _RetroFitNetwork(this._dio, {this.baseUrl}) {
    baseUrl ??= 'api.unsplash.com';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<Unsplash>> getUnsplash(params) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<Unsplash>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/photos',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => Unsplash.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<Unsplash> getUnsplashSearch(params) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(params);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<Unsplash>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/search/photos',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Unsplash.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Unsplash> createUnsplash(unsplash) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json; charset=UTF-8',
      r'Authorization': 'Client-ID sLy7DxJOs-rkxl2TqpgNrZz89z70WV-ecUyq9VGnncg',
      r'Accept-Version': 'v1'
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(unsplash.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<Unsplash>(Options(
                method: 'POST',
                headers: _headers,
                extra: _extra,
                contentType: 'application/json; charset=UTF-8')
            .compose(_dio.options, '/api/v1/notes',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Unsplash.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Unsplash> updateUnsplash(id, unsplash) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json; charset=UTF-8',
      r'Authorization': 'Client-ID sLy7DxJOs-rkxl2TqpgNrZz89z70WV-ecUyq9VGnncg',
      r'Accept-Version': 'v1'
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(unsplash.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<Unsplash>(Options(
                method: 'PUT',
                headers: _headers,
                extra: _extra,
                contentType: 'application/json; charset=UTF-8')
            .compose(_dio.options, '/api/v1/notes/${id}',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Unsplash.fromJson(_result.data!);
    return value;
  }

  @override
  Future<void> deleteUnsplash(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/json; charset=UTF-8',
      r'Authorization': 'Client-ID sLy7DxJOs-rkxl2TqpgNrZz89z70WV-ecUyq9VGnncg',
      r'Accept-Version': 'v1'
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    await _dio.fetch<void>(_setStreamType<void>(Options(
            method: 'DELETE',
            headers: _headers,
            extra: _extra,
            contentType: 'application/json; charset=UTF-8')
        .compose(_dio.options, '/api/v1/notes/${id}',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    return null;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}

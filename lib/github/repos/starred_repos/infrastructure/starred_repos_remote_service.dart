import 'package:dio/dio.dart';
import 'package:repo_viewer/core/infrastructure/github_headers_cache.dart';
import 'package:repo_viewer/core/infrastructure/network_exception.dart';
import 'package:repo_viewer/github/core/infrastructure/github_headers.dart';
import 'package:repo_viewer/github/core/infrastructure/github_repo_dto.dart';
import 'package:repo_viewer/github/core/infrastructure/pagination_config.dart';
import 'package:repo_viewer/github/core/infrastructure/remote_response.dart';
import 'package:repo_viewer/core/infrastructure/dio_extension.dart';

class StarredReposRemoteService {
  final Dio _dio;
  final GithubHeadersCache _headersCache;

  StarredReposRemoteService(
    this._dio,
    this._headersCache,
  );

  Future<RemoteResponse<List<GithubRepoDTO>>> getStarredRepoDTO(
      int page) async {
    // const token = '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';
    // const acceptHeader = 'application/vnd.github.v3.html+json';
    final requestUri = Uri.https(
      'api.github.com',
      '/user/starred',
      {
        'page': '$page',
        'per_page': PaginationConfig.itemsPerPage.toString(),
      },
    );

    final savedHeaders = await _headersCache.getHeaders(requestUri);

    try {
      final response = await _dio.getUri(
        requestUri,
        options: Options(
          headers: {
            'If-None-Match': savedHeaders?.eTag ?? '',
          },
        ),
      );

      if (response.statusCode == 304) {
        return RemoteResponse.notModified(
            maxPage: savedHeaders?.paginationLink?.maxPage ?? 0);
      } else if (response.statusCode == 200) {
        final headers = GithubHeaders.parse(response);
        await _headersCache.saveHeaders(
          requestUri,
          headers,
        );

        final data = (response.data as List<dynamic>)
            .map((e) => GithubRepoDTO.fromJson(e as Map<String, dynamic>))
            .toList();

        return RemoteResponse.withNewData(
          data,
          maxPage: headers.paginationLink?.maxPage ?? 1,
        );
      } else {
        throw RestApiException(response.statusCode);
      }
    } on DioError catch (e) {
      if (e.isNoConnectionError) {
        return RemoteResponse.noConnection(
            maxPage: savedHeaders?.paginationLink?.maxPage ?? 0);
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }
}

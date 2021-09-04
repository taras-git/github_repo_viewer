import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'github_headers.freezed.dart';
part 'github_headers.g.dart';

@freezed
class GithubHeaders with _$GithubHeaders {
  const GithubHeaders._();
  const factory GithubHeaders({
    String? eTag,
    PaginationLink? paginationLink,
  }) = _GithubHeaders;

  factory GithubHeaders.parse(Response response) {
    final link = response.headers.map['Link']?[0];
    return GithubHeaders(
      eTag: response.headers.map['ETag']?[0],
      paginationLink: link == null
          ? null
          : PaginationLink.parse(
              link.split(','),
              requestUrl: response.requestOptions.uri.toString(),
            ),
    );
  }
  factory GithubHeaders.fromJson(Map<String, dynamic> json) =>
      _$GithubHeadersFromJson(json);
}

@freezed
class PaginationLink with _$PaginationLink {
  const PaginationLink._();
  const factory PaginationLink({
    required int maxPage,
  }) = _PaginationLink;

  factory PaginationLink.parse(
    List<String> values, {
    required String requestUrl,
  }) {
    return PaginationLink(
      maxPage: _extractMaxPage(
        values.firstWhere(
          (e) => e.contains('rel="last"'),
          orElse: () => requestUrl,
        ),
      ),
    );
  }

  static int _extractMaxPage(String link) {
    final regexp = RegExp(
        r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)');
    final uriLink = regexp.stringMatch(link);
    return int.parse(Uri.parse(uriLink!).queryParameters['page']!);
  }

  factory PaginationLink.fromJson(Map<String, dynamic> json) =>
      _$PaginationLinkFromJson(json);
}

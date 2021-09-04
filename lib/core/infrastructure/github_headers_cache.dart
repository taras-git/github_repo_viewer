import 'package:repo_viewer/core/infrastructure/sembast_database.dart';
import 'package:repo_viewer/github/core/infrastructure/github_headers.dart';
import 'package:sembast/sembast.dart';

class GithubHeadersCache {
  final SembastDatabase _sembastDb;
  final _store = stringMapStoreFactory.store('headers');

  GithubHeadersCache(this._sembastDb);

  Future<void> saveHeaders(Uri uri, GithubHeaders githubHeaders) async {
    await _store.record(uri.toString()).put(
          _sembastDb.dbInstance,
          githubHeaders.toJson(),
        );
  }

  Future<GithubHeaders?> getHeaders(Uri uri) async {
    final headers =
        await _store.record(uri.toString()).get(_sembastDb.dbInstance);
    return headers == null ? null : GithubHeaders.fromJson(headers);
  }

  Future<void> deleteHeaders(Uri uri) async {
    await _store.record(uri.toString()).delete(_sembastDb.dbInstance);
  }
}

import 'package:repo_viewer/core/infrastructure/sembast_database.dart';
import 'package:repo_viewer/github/core/infrastructure/github_repo_dto.dart';
import 'package:repo_viewer/github/core/infrastructure/pagination_config.dart';
import 'package:sembast/sembast.dart';
import 'package:collection/collection.dart';

class StarredReposLocalService {
  final SembastDatabase _db;
  final _store = intMapStoreFactory.store('starredRepos');

  StarredReposLocalService(this._db);

  Future<void> upsertPage(List<GithubRepoDTO> dtos, int page) async {
    final sembastPage = page - 1;

    await _store
        .records(dtos.mapIndexed(
            (index, _) => index + sembastPage * PaginationConfig.itemsPerPage))
        .put(
          _db.dbInstance,
          dtos.map((dto) => dto.toJson()).toList(),
        );
  }

  Future<List<GithubRepoDTO>> getPage(int page) async {
    final sembastPage = page - 1;

    final records = await _store.find(
      _db.dbInstance,
      finder: Finder(
        limit: PaginationConfig.itemsPerPage,
        offset: PaginationConfig.itemsPerPage * sembastPage,
      ),
    );
    return records
        .map(
          (e) => GithubRepoDTO.fromJson(e.value),
        )
        .toList();
  }

  Future<int> getLocalPageCount() async {
    final repoCount =
        (await _store.count(_db.dbInstance) / PaginationConfig.itemsPerPage)
            .ceil();
    return repoCount;
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/core/domain/fresh.dart';
import 'package:repo_viewer/github/core/domain/github_failure.dart';
import 'package:repo_viewer/github/core/domain/github_repo.dart';
import 'package:repo_viewer/github/core/infrastructure/pagination_config.dart';
import 'package:repo_viewer/github/repos/starred_repos/infrastructure/starred_repos_repository.dart';
part 'starred_repos_notifier.freezed.dart';

@freezed
class StarredReposState with _$StarredReposState {
  const StarredReposState._();
  const factory StarredReposState.initial(
    Fresh<List<GithubRepo>> repos,
  ) = _Initial;

  const factory StarredReposState.loadInProgress(
    Fresh<List<GithubRepo>> repos,
    int itemsPerPage,
  ) = _LoadInProgress;

  const factory StarredReposState.loadSuccess(
    Fresh<List<GithubRepo>> repos, {
    required bool isNexPageAvailable,
  }) = _LoadSuccess;

  const factory StarredReposState.loadFailure(
    Fresh<List<GithubRepo>> repos,
    GithubFailure githubFailure,
  ) = _LoadFailure;
}

class StarredReposNotifier extends StateNotifier<StarredReposState> {
  final StarredReposRepository _starredReposRepository;

  StarredReposNotifier(this._starredReposRepository)
      : super(StarredReposState.initial(Fresh.yes([])));

  int _page = 1;

  Future<void> getNextStarredReposPage() async {
    // state = StarredReposState.loadFailure(
    //   state.repos,
    //   GithubFailure.api(404),
    // );
    state = StarredReposState.loadInProgress(
      state.repos,
      PaginationConfig.itemsPerPage,
    );
    final failureOrRepos =
        await _starredReposRepository.getStarredReposPage(_page);
    state = failureOrRepos.fold(
      (l) => StarredReposState.loadFailure(state.repos, l),
      (r) {
        _page++;
        return StarredReposState.loadSuccess(
          r.copyWith(
            entity: [
              ...state.repos.entity,
              ...r.entity,
            ],
          ),
          isNexPageAvailable: r.isNextPageAvailable ?? false,
        );
      },
    );
  }
}

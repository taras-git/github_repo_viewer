import 'package:repo_viewer/search/infrastructure/search_history_repository.dart';
import 'package:riverpod/riverpod.dart';

class SearchHistoryNotifier extends StateNotifier<AsyncValue<List<String>>> {
  final SearchHistoryRepository _repository;

  SearchHistoryNotifier(this._repository) : super(const AsyncValue.loading());

  void watchSearchTerms({String? filter}) {
    _repository.watchSearchTerms(filter: filter).listen(
      (data) {
        state = AsyncValue.data(data);
      },
      onError: (Object e) {
        state = AsyncValue.error(e);
      },
    );
  }

  Future<void> addSearchTerm(String term) => _repository.addSearchTerm(term);

  Future<void> deleteSearchTerm(String term) =>
      _repository.deleteSearchTerm(term);

  Future<void> putSearchTermFirst(String term) =>
      _repository.putSearchTermFirst(term);
}

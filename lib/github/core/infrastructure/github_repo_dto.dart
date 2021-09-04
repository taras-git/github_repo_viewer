import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repo_viewer/github/core/domain/github_repo.dart';
import 'package:repo_viewer/github/core/infrastructure/user_dto.dart';
part 'github_repo_dto.freezed.dart';
part 'github_repo_dto.g.dart';

String _descFromJson(Object? json) {
  return (json as String?) ?? "";
}

@freezed
class GithubRepoDTO with _$GithubRepoDTO {
  const GithubRepoDTO._();
  const factory GithubRepoDTO({
    required UserDTO owner,
    required String name,
    @JsonKey(fromJson: _descFromJson) required String description,
    @JsonKey(name: 'stargazers_count') required int stargazersCount,
  }) = _GithubRepoDTO;

  factory GithubRepoDTO.fromJson(Map<String, dynamic> json) =>
      _$GithubRepoDTOFromJson(json);

  factory GithubRepoDTO.fromDomain(GithubRepo githubRepo) {
    return GithubRepoDTO(
      owner: UserDTO.fromDomain(githubRepo.owner),
      name: githubRepo.name,
      description: githubRepo.description,
      stargazersCount: githubRepo.stargazersCount,
    );
  }

  GithubRepo toDomain() {
    return GithubRepo(
      owner: owner.toDomain(),
      name: name,
      description: description,
      stargazersCount: stargazersCount,
    );
  }
}

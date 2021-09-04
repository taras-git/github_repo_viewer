import 'package:auto_route/auto_route.dart';
import 'package:repo_viewer/auth/presentation/authorization_page.dart';
import 'package:repo_viewer/auth/presentation/sign_in_page.dart';
import 'package:repo_viewer/github/repos/starred_repos/presentation/starrted_repos.dart';
import 'package:repo_viewer/splash/presentation/splash_page.dart';

@MaterialAutoRouter(
  routes: [
    MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: SignInPage, path: '/sign-in'),
    MaterialRoute(page: StarredReposPage, path: '/starred'),
    MaterialRoute(page: AuthorizationPage, path: '/auth'),
  ],
  replaceInRouteName: 'Page,Route',
)
class $AppRouter {}

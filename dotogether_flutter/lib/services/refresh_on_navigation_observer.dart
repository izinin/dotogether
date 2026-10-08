import 'package:flutter/widgets.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../client.dart';
import 'app_state.dart';

/// Reloads server data (projects and contacts) whenever the user navigates
/// to a page, including when returning to a previous page, so each screen
/// shows up-to-date data.
class RefreshOnNavigationObserver extends NavigatorObserver {
  RefreshOnNavigationObserver(this._appState);

  final AppState _appState;

  void _refresh() {
    if (!client.auth.isAuthenticated) return;
    Future.microtask(() {
      _appState.refreshProjects();
      _appState.fetchContacts();
    });
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _refresh();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _refresh();

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _refresh();
}

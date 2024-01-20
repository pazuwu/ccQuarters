import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RouteInfo {
  String path;
  Object? extra;

  RouteInfo({
    required this.path,
    this.extra,
  });
}

class HistoryStack {
  final List<RouteInfo> _stack = [];

  HistoryStack(String startPath) {
    _stack.add(RouteInfo(path: startPath));
  }

  void _push(String path, {Object? extra}) {
    var routeInfo = RouteInfo(
      path: path,
      extra: extra,
    );

    _stack.add(routeInfo);
  }

  RouteInfo _pop() {
    if (_stack.length == 1) return _stack.first;

    return _stack.removeLast();
  }

  RouteInfo _peek() {
    return _stack.last;
  }

  int get size => _stack.length;
}

extension HistoryNavigatorContextExtensions on BuildContext {
  void go(String path, {Object? extra}) {
    read<HistoryStack>()._push(path, extra: extra);
    GoRouter.of(this).go(path, extra: extra);
  }

  void goBack() {
    var historyStack = read<HistoryStack>();

    if (historyStack.size == 1) {
      _buildDialogWithQuestionIfUserWantsToLeaveApp(this)
          .then((userWantsToLeaveApp) {
        if (userWantsToLeaveApp ?? false) {
          _closeApp();
        }
      });
    }

    historyStack._pop();
    var currentRoute = historyStack._peek();
    GoRouter.of(this).go(currentRoute.path, extra: currentRoute.extra);
  }

  void refresh() {
    GoRouter.of(this).refresh();
  }

  void _closeApp() {
    SystemNavigator.pop();
  }

  Future<bool?> _buildDialogWithQuestionIfUserWantsToLeaveApp(
      BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => BackButtonListener(
        onBackButtonPressed: () async {
          Navigator.of(context).pop(false);
          return true;
        },
        child: AlertDialog(
          title: const Text("Czy na pewno chcesz wyjść z aplikacji?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Nie"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Tak"),
            ),
          ],
        ),
      ),
    );
  }
}

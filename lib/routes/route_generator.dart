import 'package:flutter/material.dart';
import 'package:hive_db_task_todo/pages/add_task_page.dart';
import 'package:hive_db_task_todo/pages/history_page.dart';
import 'package:page_transition/page_transition.dart';
import '../models/task_model.dart';
import '../pages/home_page.dart';
import '../pages/task_info_page.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings) {

    final args = settings.arguments;

    switch (settings.name) {
      case '/': 
        return PageTransition(child: const HomePage(), type: PageTransitionType.fade);

      case '/addTask': 
        return PageTransition(child: const AddTaskPage(), type: PageTransitionType.fade);

      case '/history':
        return PageTransition(child: const HistoryPage(), type: PageTransitionType.fade);

      case '/taskInfo':
        if (args is Task) {
          return PageTransition(child: TaskInfoPage(task: args), type: PageTransitionType.bottomToTop);
        } else {
          return _errorRoute();
        }

      default: 
        return _errorRoute();
    }

  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text('Oops.. Something went wrong.'),
        ),
      );
    });
  }

}
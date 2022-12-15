import 'package:flutter/material.dart';
import 'package:hive_db_task_todo/models/task_model.dart';
import 'package:hive_db_task_todo/widgets/todo_item_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../routes/locator.dart';
import '../routes/navigation_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _navigationService = locator<NavigationService>();
  late List<Task> _tasks;
  final _listKey = GlobalKey<AnimatedListState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setTasks();
  }

  Future<void> setTasks() async {
    setState(() => _isLoading = true);
    _tasks = Hive.box<Task>("tasks").values.toList().cast<Task>();
    _tasks.retainWhere((task) => task.isCompleted);
    setState(() => _isLoading = false);
  }

  void onDelete(int position) async {
    final task = _tasks[position];
    task.delete();
    _tasks.removeAt(position);
    _listKey.currentState!.removeItem(
      position, 
      (context, animation) => TodoItemWidget(
          task: task,
          isEditable: false,
          onUpdate: () {}, 
          onTap: () {},
      ),
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).backgroundColor,
    appBar: buildAppBar(),
    body: Center(
      child: _isLoading 
      ? const CircularProgressIndicator()
      : _tasks.isEmpty
        ? const Text('No tasks.')
        : buildAnimatedTaskList(_tasks),
    ),
  );

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).backgroundColor,
      foregroundColor: Theme.of(context).primaryColor,
      elevation: 0.0,
      title: Text(
        'History',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      centerTitle: true,
    );
  }

  Widget buildAnimatedTaskList(final tasks) => ListView.builder(
    key: _listKey,
    itemCount: tasks.length,
    itemBuilder: (context, index) => TodoItemWidget(
      task: tasks[index], 
      isEditable: true,
      onUpdate: () => () {},
      onTap: () => _navigationService.navigateTo('/taskInfo', arguments: tasks[index]),
    ),
  );
}
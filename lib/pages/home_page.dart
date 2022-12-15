import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:hive_db_task_todo/models/task_model.dart';
import 'package:hive_db_task_todo/routes/locator.dart';
import 'package:hive_db_task_todo/routes/navigation_service.dart';
import 'package:hive_db_task_todo/widgets/todo_item_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:week_of_year/week_of_year.dart';
import '../theme/theme_manager.dart';
import '../widgets/circle_tab_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _navigationService = locator<NavigationService>();
  late List<Task> _tasks;
  bool _isLoading = false;
  bool _isDark = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _isDark = context.read<ThemeManager>().themeMode == ThemeMode.dark;
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    setTodoList(0);
    _tabController.addListener(() {
      setTodoList(_tabController.index);
    });
  }

  bool isToday(Task task) {
    return formatDate(task.inputDate, [dd, '-', MM, '-', yyyy]) == formatDate(DateTime.now(), [dd, '-', MM, '-', yyyy]);
  }

  bool isThisWeek(Task task) {
    return task.inputDate.weekOfYear == DateTime.now().weekOfYear;
  }

  bool isThisMonth(Task task) {
    return formatDate(task.inputDate, [MM, '-', yyyy]) == formatDate(DateTime.now(), [MM, '-', yyyy]);
  }

  void setTodoList(int index) async {
    setState(() => _isLoading = true);
    _tasks = Hive.box<Task>("tasks").values.toList().cast<Task>();

    switch (index) {
      case 0: _tasks.retainWhere((task) => isToday(task)); break;
      case 1: _tasks.retainWhere((task) => isThisWeek(task)); break;
      case 2: _tasks.retainWhere((task) => isThisMonth(task)); break;
    }

    _tasks.sort((a, b) { 
      if (b.isCompleted) {
        return 1;
      } else {
        return -1;
      } 
    });
    debugPrint(_tasks.toString());
    setState(() => _isLoading = false);
  }

  void onChecked(int position) {
    final task = _tasks[position];
    task.isCompleted = !task.isCompleted;
    if (task.isCompleted) {
      task.completedDate = DateTime.now();
    } else {
      task.completedDate = null;
    }
    task.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildContent(_tabController),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).backgroundColor,
      foregroundColor: Theme.of(context).primaryColor,
      elevation: 0.0,
      title: Text(
        'Home',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () { 
            context.read<ThemeManager>().toggleTheme(_isDark);
            if (context.read<ThemeManager>().themeMode == ThemeMode.dark) {
              context.read<ThemeManager>().toggleTheme(false);
              _isDark = false;
            } else {
              context.read<ThemeManager>().toggleTheme(true);
              _isDark = true;
            }
          },
          icon: _isDark ? const Icon(Icons.light_mode_rounded) : const Icon(Icons.dark_mode_rounded)
        ),
      ],
    );
  }

  Widget buildContent(TabController tabController) => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hey Usama,', style: Theme.of(context).textTheme.subtitle1),
        const SizedBox(height: 5),
        Text("Let's be productive today!", style: Theme.of(context).textTheme.bodyText1!.copyWith(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w400
        )),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey),
        const SizedBox(height: 5),
        TabBar(
          controller: tabController,
          labelColor: Theme.of(context).primaryColor,
          labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
          indicator: CircleTabIndicator(color: Theme.of(context).primaryColor, radius: 3),
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Week'),
            Tab(text: 'Month'),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SizedBox(
            width: double.maxFinite,
            height: 281,
            child: TabBarView(
              controller: tabController,
              children: [
                buildTodoList(_tasks),
                buildTodoList(_tasks),
                buildTodoList(_tasks),
              ]
            ),
          ),
        ),
      ],
    ),
  );

  Widget buildTodoList(final List<Task> tasks) {
    return _isLoading ? const Center(child: CircularProgressIndicator())
    : tasks.isNotEmpty ?
      ValueListenableBuilder(
        valueListenable: Hive.box<Task>('tasks').listenable(),
        builder: (context, box, _) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: tasks.length,
            itemBuilder: (context, index) => TodoItemWidget(
              task: tasks[index],
              isEditable: true, 
              onUpdate: () => onChecked(index),
              onTap: () => _navigationService.navigateTo('/taskInfo', arguments: tasks[index]),
            )
          );
        }
      )
    : Text(
      "No tasks.",
      style: Theme.of(context).textTheme.bodyText1!.copyWith(
        color: Colors.grey,
        fontSize: 14,
        fontWeight: FontWeight.w400
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  void addTodoItem(BuildContext context) async {
    final task = Task(
      title: titleController.text,
      description: descriptionController.text,
      inputDate: DateTime.now()
    );

    Box<Task> tasksBox = Hive.box<Task>('tasks');
    tasksBox.add(task);

    titleController.text = '';
    descriptionController.text = '';

    Fluttertoast.showToast(
        msg: 'Task added.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Theme.of(context).primaryColor,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).backgroundColor,
    appBar: buildAppBar(),
    floatingActionButton: FloatingActionButton(
      onPressed: () => addTodoItem(context),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      child: const Icon(Icons.done_rounded),
    ),
    body: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          buildTextField(
            controller: titleController, 
            hint: 'Title',
            hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: Colors.grey,
            ),
            textStyle: Theme.of(context).textTheme.subtitle1!
          ),
          buildTextField(
            controller: descriptionController, 
            hint: 'Description',
            hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
            textStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w400
            )
          ),
        ]
      ),
    ),
  );

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).backgroundColor,
      foregroundColor: Theme.of(context).primaryColor,
      elevation: 0.0,
      title: Text(
        'Add Task',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      centerTitle: true,
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    String hint = '',
    int minLines = 1,
    int maxLines = 3,
    required TextStyle hintStyle,
    required TextStyle textStyle
  }) {
    return TextField(
      controller: controller,
      style: textStyle,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        hintStyle: hintStyle
      ),
    );
  }
}
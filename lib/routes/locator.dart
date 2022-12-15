import 'package:get_it/get_it.dart';
import 'package:hive_db_task_todo/routes/navigation_service.dart';

GetIt locator = GetIt.instance;

void setup() {
  locator.registerSingleton(() => NavigationService());
}
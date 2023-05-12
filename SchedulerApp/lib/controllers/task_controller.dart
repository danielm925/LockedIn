import 'package:get/get.dart';
import '../models/task.dart';
import '../db/db_helper.dart';

class TaskController extends GetxController{

  @override
  void onReady(){
    getTasks();
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async{
    return await DBHelper.insert(task);
  }

  void getTasks() async{
    List<Map<String, dynamic>> events = await DBHelper.query();
    taskList.assignAll(events.map((data) => Task.fromJson(data)).toList());
  }

  void delete(Task task){
    DBHelper.delete(task);
    getTasks();
  }

  void markTaskCompleted(int id) async{
    await DBHelper.update(id);
    getTasks();
  }
}
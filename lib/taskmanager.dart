import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taskmanagerapp/Model/taskmodel.dart';

import 'componenets/reusable.dart';

class TaskManager {
  List<taskmodel> tasks = [];
  final http.Client client;

  TaskManager( {required this.client});

  Future<taskmodel> createTask(taskmodel task) async {
    final response = await client.post(
      Uri.parse('$baseurl/todos/add'),
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 201) {
      return taskmodel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }

  Future<taskmodel> readTask(int id) async {
    final response = await client.get(Uri.parse('$baseurl/todos/user/${id}'));

    if (response.statusCode == 200) {
      return taskmodel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load task');
    }
  }

  Future<List<taskmodel>> readAllTasks() async {
    final response = await client.get(Uri.parse('$baseurl/todos'));

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      return List<taskmodel>.from(l.map((model) => taskmodel.fromJson(model)));
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<taskmodel> updateTask(taskmodel task) async {
    final response = await client.put(
      Uri.parse('$baseurl/todos/${id}'),
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return taskmodel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update task');
    }
  }

  Future<bool> deleteTask(int id) async {
    final response = await client.delete(Uri.parse('$baseurl/todos/${id}'));

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  void addTask(taskmodel task) {
    tasks.add(task);
  }

  void removeTask(taskmodel task) {
    tasks.remove(task);
  }

  void toggleTaskCompletion(taskmodel task) {
    task.completed = !task.completed!;
  }

  void clearAllTasks() {
    tasks.clear();
  }

  void validateTask(taskmodel task) {
    if (task.todo!.isEmpty) {
      throw Exception('Invalid task title');
    }
  }

}
class InvalidTaskException implements Exception {
  final String message;

  InvalidTaskException(this.message);

  @override
  String toString() => 'InvalidTaskException: $message';
}

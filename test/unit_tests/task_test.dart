
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:taskmanagerapp/Model/taskmodel.dart';
import 'package:taskmanagerapp/componenets/reusable.dart';
import 'package:taskmanagerapp/taskmanager.dart'; // Adjust import according to your project structure
import 'task_test.mocks.dart' as generated_mocks;

// Mock class generated by Mockito
@GenerateMocks([http.Client])
void main() {
  group('Task Manager Tests', () {
    late generated_mocks.MockClient client;
    TaskManager taskManager;

    setUp(() {
      client = generated_mocks.MockClient();
      taskManager = TaskManager(client: client);
    });
    taskManager = TaskManager(client: client);
    test('Create Task - Success', () async {
      final task = taskmodel(id: 1, todo: 'New Task', userId: 1,completed: true);

      when(client.post(Uri.parse('$baseurl/todos/add'), body: anyNamed('body')))
        .thenAnswer((_) async => http.Response('{"id": 1, "todo": "New Task", "userId": "1","completed":"true"}', 201));

      final createdTask = await taskManager.createTask(task);

      expect(createdTask, isNotNull);
      expect(createdTask.id, equals(1));
      expect(createdTask.todo, equals('New Task'));
    });

    test('Read Task - Success', () async {
      final taskId = 1;

      when(client.get(Uri.parse('$baseurl/todos/user/${id}')))
        .thenAnswer((_) async => http.Response('{"id": 1, "todo": "New Task", "userId": "1","completed":"true"}', 200));

      final task = await taskManager.readTask(taskId);

      expect(task, isNotNull);
      expect(task.id, equals(1));
      expect(task.todo, equals('Existing Task'));
    });

    test('Update Task - Success', () async {
      final task = taskmodel(id: 1, todo: 'Updated Task', completed: true,userId: 1);

      when(client.put(Uri.parse('$baseurl/todos/${task.id}'), body: anyNamed('body')))
        .thenAnswer((_) async => http.Response('{"id": 1, "todo": "Updated Task", "completed": "true", "userId":"1"}', 200));

      final updatedTask = await taskManager.updateTask(task);

      expect(updatedTask, isNotNull);
      expect(updatedTask.todo, equals('Updated Task'));
    });

    test('Delete Task - Success', () async {
      final taskId = 1;

      when(client.delete(Uri.parse('$baseurl/todos/$taskId')))
        .thenAnswer((_) async => http.Response('', 204));

      final success = await taskManager.deleteTask(taskId);

      expect(success, isTrue);
    });

    test('Input Validation - Invalid Task Title', () {
      final task = taskmodel(id: 1, todo: '', completed: true,userId: 1);

      expect(() => taskManager.validateTask(task), throwsA(isA<InvalidTaskException>()));
    });

    test('State Management - Task List Update', () {
      final task = taskmodel(id: 1, todo: '', completed: true,userId: 1);

      taskManager.addTask(task);

      expect(taskManager.tasks.contains(task), isTrue);

      taskManager.removeTask(task);

      expect(taskManager.tasks.contains(task), isFalse);
    });

  });
}



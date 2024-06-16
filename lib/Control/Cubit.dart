
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskmanagerapp/Control/States.dart';
import 'package:http/http.dart' as http;
import 'package:taskmanagerapp/View/addtask.dart';
import '../Model/taskmodel.dart';
import '../Model/usermodel.dart';
import '../componenets/reusable.dart';

class Appcubit extends Cubit<Appstates>{
  Appcubit() :super(initstate());
  static Appcubit get(context) =>BlocProvider.of(context);


  bool isPassword=true;
  IconData suffixIcon =Icons.visibility_off_outlined;
  bool iscomplete=false;
  int selectedlistindex = 0;
  Color selectedlistcolor = Colors.greenAccent;

  void changePasswordIcon()
  {
    isPassword= !isPassword;
    suffixIcon= isPassword? Icons.visibility_off_outlined:Icons.visibility_outlined ;
    emit(ChangePasswordIconState());
  }

  void settaskcomplete(val) {
    iscomplete = val;
    emit(setcompletestate());
  }
  void changenlistindex(int index) {
    selectedlistindex = index;
    selectedlistcolor = Colors.greenAccent;
  }

  Future<void> loginuser({
    required String? username,
    required String password,

  }) async {
   emit(loginloadstate());

    Uri url = Uri.parse("$baseurl/auth/login");
    await http.post(url, headers: {
      "Accept": "application/json",
    }, body: {
      "username": username,
      "password": password,

    }).then((value) async {
      if (value.statusCode == 200) {

        currentuser = usermodel.fromJson(jsonDecode(value.body));

        emit(loginsuccessstate());
      } else {

        emit(loginerrorstate());
      }
    }).catchError((error) {
      print(error.toString());
      emit(loginerrorstate());
    });
  }

  List<taskmodel> tasks=[];
  int totalpages=1;
  Future<void> gettasksbyuserid({required int id})async{
    tasks=[];
    emit(gettaskloadstate());
    if(isinternet){
      Uri url = Uri.parse("$baseurl/todos/user/${id}");
      await http.get(url)
          .then((value){
        var result=jsonDecode(value.body);
        double res =  result["total"]/6;
        totalpages=res.ceil();
        print(totalpages);
        result["todos"].forEach((element) async {


          tasks.add(taskmodel.fromJson(element));


        });

        emit(gettasksuccessstate());
      })
          .catchError((error){
        emit(gettaskerrorstate());
      });
    }else{
      await getdatafromdbforuser(userId: id);
    }

  }
  Future<void> gettasks()async{
    Uri url = Uri.parse("$baseurl/todos");
    await http.get(url)
        .then((value){
      var result=jsonDecode(value.body);
      double res =  result["total"]/6;
      totalpages=res.ceil();

      result["todos"].forEach((element) async {

        taskmodel model=taskmodel.fromJson(element);
        await insertdata(taskid: model.id!, todo: model.todo!, completed: model.completed!, userId: model.userId!);

      });


    })
        .catchError((error){

    });
  }

  Future<void> getlimittasks({required int limit,required int skip})async{
    tasks=[];
    emit(gettaskloadstate());
    if(isinternet){

      Uri url = Uri.parse("$baseurl/todos?limit=${limit}&skip=${skip}");
      await http.get(url)
          .then((value){
        var result=jsonDecode(value.body);
        result["todos"].forEach((element) async {
          tasks.add(taskmodel.fromJson(element));
        });

        emit(gettasksuccessstate());
      })
          .catchError((error){
        emit(gettaskerrorstate());
      });
    }
    else{

      await getdatafromdb(limit: limit, skip: skip);
    }
  }

  Future<void> addnewtask({
    required String? task,
    required String complete,
    required String id,

  }) async {
    emit(addloadstate());

    Uri url = Uri.parse("$baseurl/todos/add");
    await http.post(url, headers: {
      "Accept": "application/json",
    }, body: {
      "todo": task,
      "completed": complete,
      "userId":id,

    }).then((value) async {
      print(jsonDecode(value.body));
      print("success");

      emit(addsuccessstate());


    }).catchError((error) {
      print(error.toString());
      emit(adderrorstate());
    });
  }

  Future<void> updatetask({
    required String? task,
    required String complete,
    required String id,

  }) async {
    emit(updateloadstate());

    Uri url = Uri.parse("$baseurl/todos/${id}");
    await http.put(url, headers: {
      "Accept": "application/json",
    }, body: {
      "todo": task,
      "completed": complete,


    }).then((value) async {

      emit(updatesuccessstate(message: 'update'));


    }).catchError((error) {
      print(error.toString());
      emit(updateerrorstate(message: 'update'));
    });
  }

  Future<void> deletetask({

    required String id,

  }) async {
    emit(updateloadstate());

    Uri url = Uri.parse("$baseurl/todos/${id}");
    await http.delete(url).then((value) async {

      emit(updatesuccessstate(message: 'delete'));


    }).catchError((error) {
      print(error.toString());
      emit(updateerrorstate(message: 'delete'));
    });
  }
  late Database database;
  Future<Database?> newdata() async {
    emit(creatdbloadstate());
    database=  await openDatabase(
        'tasks.db',
        version: 1,
        onCreate: (database,version){
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY,taskid INTEGER PRIMARY KEY,todo TEXT,completed BOOLEAN,userId INTEGER)')
              .then((value) {
            emit(creatdbsucstate());
            print('success create db');


          })
              .catchError((error){
            emit(creatdberrstate());
            print(error.toString());
          });

        },
        onOpen: (database){
          emit(creatdbsucstate());
        }

    );
    return database;
  }

  Future insertdata({required int taskid,required String todo,required bool completed,required int userId})
  async {
    await newdata();
    emit(insertdbloadstate());
    List<Map<String, dynamic>> result = await database.rawQuery('''
    SELECT COUNT(*) as count FROM tasks
  ''');
    int rowCount = result[0]['count'];
    if(rowCount==0){
      await database.rawInsert( 'INSERT INTO tasks(taskid,todo,completed,userId) VALUES("$taskid","$todo","$completed","$userId")')
          .then((value) {
        emit(insertdbsucstate());
        print('success insert');})
          .catchError((error){
        emit(insertdberrstate());
        print(error.toString());
      });
    }else {
      List<Map<String, dynamic>> result2 = await database.rawQuery(
    'SELECT * FROM tasks WHERE taskid = $taskid'
);
      if (result2.isEmpty) {
        await database.rawInsert(
            'INSERT INTO tasks(taskid,todo,completed,userId) VALUES("$taskid","$todo","$completed","$userId")')
            .then((value) {
          emit(insertdbsucstate());
          print('success insert');
        })
            .catchError((error) {
          emit(insertdberrstate());
          print(error.toString());
        });
      }
    }


  }

  Future getdatafromdb({required int limit,required int skip })async{
    tasks=[];
    await newdata();
    emit(gettaskloadstate());

    List<Map> numberrows= await database.rawQuery('SELECT * FROM tasks');

    double res =numberrows.length /6;
    totalpages=res.ceil();

    await database.rawQuery('SELECT * FROM tasks LIMIT ${limit} OFFSET ${skip} ')
    .then((value){

      value.forEach((element){

        tasks.add(taskmodel(id: int.parse(element["taskid"].toString()), completed:bool.parse(element["completed"].toString()), todo: element["todo"].toString(), userId: int.parse(element["userId"].toString())));
        print(element["id"] as int);
      });

      emit(gettasksuccessstate());
    })
    .catchError((error){
      emit(gettaskerrorstate());
    });



  }

  Future getdatafromdbforuser({required int userId})async{
    tasks=[];
    await newdata();

   emit(gettaskloadstate());



    await database.rawQuery('SELECT * FROM tasks WHERE taskid=$userId ')
        .then((value){

      value.forEach((element){

        tasks.add(taskmodel(id: int.parse(element["taskid"].toString()), completed:bool.parse(element["completed"].toString()), todo: element["todo"].toString(), userId: int.parse(element["userId"].toString())));

      });

      emit(gettasksuccessstate());
    })
        .catchError((error){
      emit(gettaskerrorstate());
    });



  }


}
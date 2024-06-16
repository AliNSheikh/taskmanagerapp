import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagerapp/Control/Cubit.dart';
import 'package:taskmanagerapp/Control/States.dart';
import 'package:taskmanagerapp/View/home.dart';
import 'package:taskmanagerapp/componenets/reusable.dart';

import 'View/login.dart';
import 'componenets/cash.dart';

Future<void> main() async {

  var widget;
  WidgetsFlutterBinding.ensureInitialized();
  await cashhelper.init();
  await checkinternet();

   id=await cashhelper.getid(key: 'id');
  if(await id ==null){
    widget=loginscreen();

  }else{
    widget=homescreen();
  }
  runApp( MyApp(startwidget: widget,));
}

class MyApp extends StatelessWidget {
  final Widget startwidget;

  MyApp({required this.startwidget,});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getwidth(context);
    getheight(context);
    return BlocProvider(
      create: (BuildContext context) =>Appcubit(),
      child: BlocConsumer<Appcubit,Appstates>(
        listener: (context,state){},
        builder:(context,state){
          return  MaterialApp(

            debugShowCheckedModeBanner: false,
            home:startwidget,
          );
        } ,

      ),
    );
  }
}


import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagerapp/Control/Cubit.dart';
import 'package:taskmanagerapp/Control/States.dart';
import 'package:taskmanagerapp/View/addtask.dart';
import 'package:taskmanagerapp/View/login.dart';
import 'package:taskmanagerapp/componenets/cash.dart';
import 'package:taskmanagerapp/componenets/reusable.dart';

import 'home.dart';

class mytasks extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>Appcubit()..gettasksbyuserid(id: id!),
      child: BlocConsumer<Appcubit,Appstates>(
        listener: (context,state){},
        builder: (context,state){
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(onPressed: () { navigateAndFinish(context, homescreen()); }, icon: Icon(Icons.arrow_back),),

          title: Text("My tasks"),

            ),

            body: ConditionalBuilder(
                condition:state is! gettaskloadstate,
                builder: (context) =>  SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Appcubit.get(context).tasks.length==0? Container(
                                height: height!*0.3,
                                child: Center(child: Text('NO Tasks')))
                                :GridView.count(
                              crossAxisCount:2,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.1,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children:List.generate(
                               Appcubit.get(context).tasks.length,
                                    (index) => homeBuilder(context,Appcubit.get(context).tasks[index]),
                              ),
                  
                            ),
                          ],
                        ),
                      ),
                  
                  
                  
                  
                  
                    ],
                  ),
                ),
                fallback: (context) =>  Center(child:CircularProgressIndicator())//loadhome(context),
            ),
          );
        },
      ),
    );
  }
}

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagerapp/Control/Cubit.dart';
import 'package:taskmanagerapp/Control/States.dart';
import 'package:taskmanagerapp/View/addtask.dart';
import 'package:taskmanagerapp/View/login.dart';
import 'package:taskmanagerapp/componenets/cash.dart';
import 'package:taskmanagerapp/componenets/reusable.dart';

import 'mytasks.dart';

class homescreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>Appcubit()..gettasks()..getlimittasks(limit: 6, skip: 0),
      child: BlocConsumer<Appcubit,Appstates>(
        listener: (context,state){},
        builder: (context,state){
          return Scaffold(
            appBar: AppBar(
              title: Text("Home"),
              actions: [
                buildsmallButton(context: context, name: "Logout",onTap: () async {
                  await cashhelper.removedata(key: "id");
                  await cashhelper.removedata(key: "token");
                  navigateAndFinish(context, loginscreen());

                })
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                navigateTo(context, addtask());
              },
              child: Icon(
                Icons.add
              ),

            ),
            body: ConditionalBuilder(
                condition:state is! gettaskloadstate,
                builder: (context) =>  Column(
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
                              Appcubit.get(context).tasks.length>6 ? 6 :Appcubit.get(context).tasks.length,
                                  (index) => homeBuilder(context,Appcubit.get(context).tasks[index]),
                            ),

                          ),
                        ],
                      ),
                    ),
                   SizedBox(height: height!*0.04,),
                    buildButton(context: context, name: "My Tasks",onTap: (){navigateTo(context, mytasks());}),
                    SizedBox(height: height!*0.04,),
                    Container(
                      height: height!*0.05,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: Appcubit.get(context).totalpages,
                          itemBuilder: (context, index)  {
                            return buildlistpagination(number: index+1,limit: 6,skip: index*6, cubit: Appcubit.get(context));
                          }),
                    )

                  ],
                ),
                fallback: (context) =>  Center(child:CircularProgressIndicator())//loadhome(context),
            ),
          );
        },
      ),
    );
  }
}

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagerapp/Control/Cubit.dart';
import 'package:taskmanagerapp/Control/States.dart';
import 'package:taskmanagerapp/Model/taskmodel.dart';
import 'package:taskmanagerapp/componenets/reusable.dart';

import 'home.dart';

class edittask extends StatelessWidget {
  taskmodel model;
  edittask({required this.model});
  var todo = TextEditingController();
  bool completed=false;
  var formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    todo.text=model.todo!;
     completed = model.completed!;

    return BlocConsumer<Appcubit,Appstates>(
      listener: (context,state){
        if(state is updatesuccessstate){
          showresult(context, Colors.green, "success ${state.message}");
        }
        if(state is updateerrorstate){
          showresult(context, Colors.red, "error ${state.message}");
        }
      },
      builder: (context,state){
        return  Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: () { navigateAndFinish(context, homescreen()); }, icon: Icon(Icons.arrow_back),

            ),
            title: Text("Edit Task"),
          ),
          body: Container(
            width: width,
            height: height,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: double.infinity,
                        height: 100,
                        child: TextFormField(
                          enabled: model.userId==id! ? true :false,
                          validator: (value){
                            if(value!.isEmpty){
                              return "To do can Not be null";
                            }else{
                              return null;
                            }
                          },
                          controller: todo,
                          textAlignVertical: TextAlignVertical.top,
                          maxLines: 15,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.description_outlined,
                            ),
                            hintText: "Enter a Description of To Do",
                            label: Text('Description'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Completed",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Radio(
                              value: true,
                              groupValue: completed,
                              onChanged: (val) {
                                completed = val!;
                                model.userId==id! ? Appcubit.get(context).settaskcomplete(val) : null;
                                //print(val);
                              }),
                          Text(
                            "Yes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Radio(
                              value: false,
                              groupValue: completed,
                              onChanged: (val) {
                                completed = val!;
                                model.userId==id! ? Appcubit.get(context).settaskcomplete(val) : null;

                              }),
                          Text(
                            "No",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                     model.userId==id!
                         ? Row(
                        children: [
                          Expanded(
                            child: ConditionalBuilder(
                              condition: state is! updateloadstate,
                              builder: (BuildContext context) {  return  buildsmallButton(
                                  context: context,
                                  name: "Update",buttoncolor:Colors.greenAccent,Textcolor:Colors.white,onTap: (){
                                if(formkey.currentState!.validate()){
                                  Appcubit.get(context).updatetask(task: todo.text, complete:completed.toString(), id: model.id.toString());
                                }
                            
                              });},
                              fallback: (BuildContext context) {return Center(child: CircularProgressIndicator(),);  },
                            
                            ),
                          ),
                          Expanded(
                            child: ConditionalBuilder(
                              condition: state is! updateloadstate,
                              builder: (BuildContext context) {  return  buildsmallButton(
                                  context: context,
                                  name: "delete",buttoncolor:Colors.redAccent,Textcolor:Colors.white,onTap: (){
                                if(formkey.currentState!.validate()){
                                  Appcubit.get(context).deletetask( id: id!.toString());
                                }
                            
                              });},
                              fallback: (BuildContext context) {return Center(child: CircularProgressIndicator(),);  },
                            
                            ),
                          ),
                        ],
                      )
                      :Row(
                       children: [
                         buildsmallButton(
                             context: context,
                             name: "Update",buttoncolor:Colors.grey,Textcolor:Colors.white,onTap: (){
                         }),
                         buildsmallButton(
                             context: context,
                             name: "delete",buttoncolor:Colors.grey,Textcolor:Colors.white,onTap: (){
                         }),


                       ],
                     )
                      ,

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },

    );
  }
}

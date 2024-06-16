import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagerapp/Control/Cubit.dart';
import 'package:taskmanagerapp/Control/States.dart';
import 'package:taskmanagerapp/componenets/reusable.dart';

import 'home.dart';

class addtask extends StatelessWidget {
  var todo = TextEditingController();
  bool completed = false;
  var formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Appcubit,Appstates>(
      listener: (context,state){
        if(state is addsuccessstate){
          showresult(context, Colors.green, "success");
        }
        if(state is adderrorstate){
          showresult(context, Colors.red, "error");
        }
      },
      builder: (context,state){
        return  Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: () { navigateAndFinish(context, homescreen()); }, icon: Icon(Icons.arrow_back),

            ),
            title: Text("Add Task"),
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
                                Appcubit.get(context).settaskcomplete(val);
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
                                Appcubit.get(context).settaskcomplete(val);

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
                      ConditionalBuilder(
                        condition: state is! addloadstate,
                        builder: (BuildContext context) {  return  buildButton(
                            context: context,
                            name: "Save",onTap: (){
                              if(formkey.currentState!.validate()){
                                Appcubit.get(context).addnewtask(task: todo.text, complete:completed.toString(), id: id!.toString());
                              }

                        });},
                        fallback: (BuildContext context) {return Center(child: CircularProgressIndicator(),);  },

                      ),

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

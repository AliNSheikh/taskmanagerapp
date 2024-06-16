import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagerapp/Control/Cubit.dart';
import 'package:taskmanagerapp/Control/States.dart';
import 'package:taskmanagerapp/View/home.dart';

import '../componenets/cash.dart';
import '../componenets/reusable.dart';

class loginscreen extends StatelessWidget {
  TextEditingController usernameFieldController = TextEditingController();

  TextEditingController passwordFieldController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>Appcubit(),

      child: BlocConsumer<Appcubit,Appstates>(
        listener: (context,state) async {
          if (state is loginsuccessstate){
            await cashhelper.savedata(key: "token", value: currentuser!.token);
            await cashhelper.savedata(key: "id", value: currentuser!.id);
            navigateAndFinish(context, homescreen());
          }
          if (state is loginerrorstate){
            showresult(context, Colors.red, "Error");
          }
        },
        builder: (context,state){
          return Scaffold(
            body: Container(
              width: getwidth(context),
              height: getheight(context),
              child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.only(
                        left: width! * 0.04,
                        top: height! * 0.1,
                        right: width! * 0.04,
                      ),
                      child: Column(
                        children: [
                          PrimaryText(
                            words: "Welcome Back",
                          ),
                          SizedBox(height: 10),
                          SecondlyText(
                            words: "Welcome back! Please enter your details.",
                          ),
                          SizedBox(height: 64),
                          textinput(
                              controller: usernameFieldController,
                              hint: "Username",
                              obscure: false,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "Username Must Not Be Empty";
                                } else {
                                  return null;
                                }
                              },
                              type: TextInputType.text
                          ),
                          SizedBox(height: 24),
                          textinput(
                            type: TextInputType.visiblePassword,
                            obscure: Appcubit.get(context).isPassword,
                            hint: "Password",
                            validator: (String? value) {
                              if (value!.length < 6) {
                                return "Password is Short";
                              } else {
                                return null;
                              }
                            },
                            controller: passwordFieldController,
                            eyeicon: IconButton(
                              onPressed: () {
                                Appcubit.get(context).changePasswordIcon();
                              },
                              icon: Icon(Appcubit.get(context).suffixIcon),
                            ),

                          ),
                          SizedBox(height: 24),
                          ConditionalBuilder(
                              condition: state is! loginloadstate,
                              builder: (context) => buildButton(
                                  context: context,
                                  name: "Login",
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      Appcubit.get(context).loginuser(
                                          username: usernameFieldController.text,
                                          password: passwordFieldController.text);

                                    }
                                  }),
                              fallback: (context) =>
                                  Center(child: CircularProgressIndicator())),
                        ],
                      ),
                    )),
              ),
            ),
          );
        },

      ),
    );
  }
}

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:taskmanagerapp/Model/usermodel.dart';
import 'package:taskmanagerapp/View/edittask.dart';
import 'package:toastification/toastification.dart';

import '../Control/Cubit.dart';
import '../Model/taskmodel.dart';

double? width;
double? height;
int? id;
bool isinternet=false;
Future<void> checkinternet()async{
  var connectivityResult = await (Connectivity().checkConnectivity());
  if(connectivityResult==ConnectivityResult.none){
    isinternet=false;

  }else{
    isinternet=true;

  }
}
String baseurl="https://dummyjson.com";
usermodel? currentuser;
getwidth(BuildContext context) {
  width = MediaQuery.of(context).size.width;
  return MediaQuery.of(context).size.width;
}

getheight(BuildContext context) {
  height = MediaQuery.of(context).size.height;
  return MediaQuery.of(context).size.height;
}
//primary
Color fontcolorprimary =Color(0xff000000);
double sizeprimary = 24;
String fontfamilyprimary ="Poppins";
FontWeight fontwightprimary =FontWeight.w600;


//secondary
Color fontcolorsecond =Color(0XFF828282);
double sizesecond = 14;
String fontfamilysecond ="Poppins";
FontWeight fontwightsecond =FontWeight.w400;

Widget PrimaryText({
  required String words,
  Color? color,
  double? fontsize,
  String? fontfami,
  FontWeight? wight,
  TextOverflow? over,
}) =>
    Text(
      words,
      overflow: over != null ? over : null,
      style: TextStyle(
        color: color != null ? color : fontcolorprimary,
        fontSize: fontsize != null ? fontsize : sizeprimary,
        fontFamily: fontfami != null ? fontfami : fontfamilyprimary,
        fontWeight: wight != null ? wight : fontwightprimary,
      ),
    );
Widget SecondlyText(
    {required String words,
      Color? color,
      double? fontsize,
      String? fontfami,
      TextDecoration? decoration,
      TextAlign? align,
      FontWeight? wight}) =>
    Text(
      words,
      textAlign: align == null ? TextAlign.start : align,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      style: TextStyle(
        color: color == null ? fontcolorsecond : color,
        fontSize: fontsize == null ? sizesecond : fontsize,
        fontFamily: fontfami == null ? fontfamilysecond : fontfami,
        fontWeight: wight == null ? fontwightsecond : wight,
        decoration: decoration == null ? TextDecoration.none : decoration,
      ),
    );

Widget textinput(
    {required TextEditingController controller,
      required TextInputType type,
      required String hint,
      required bool obscure,
      Widget? eyeicon,
      InputBorder? border,
      String? lab,
      String? Function(String?)? validator}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: type,
        validator: validator,
        decoration: InputDecoration(
          suffixIcon: eyeicon,
          hintText: hint,
          border: border,
          label: lab != null ? Text(lab) : null,
        ),
        style: TextStyle(
            fontSize: 16.0, fontFamily: 'Poppins', fontWeight: FontWeight.w200),
      ),
    );

Widget buildButton(
    {required context,
      required String name,
      Color? Textcolor,
      Color? buttoncolor,
      void Function()? onTap}) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height! * 0.06,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Textcolor == null ? fontcolorprimary : buttoncolor,
          border: Textcolor != null
              ? Border.all(
            color: Textcolor,
            style: BorderStyle.solid,
            width: 1,
          )
              : null,
        ),
        child: Center(
            child: PrimaryText(
              words: name,
              color: Textcolor != null ? Textcolor : Colors.white,
              fontsize: 18,
              fontfami: "Inter",
            )),
      ),
    ),
  );



}

Widget buildsmallButton(
    {required context,
      required String name,
      Color? Textcolor,
      Color? buttoncolor,
      void Function()? onTap}) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: InkWell(
      onTap: onTap,
      child: Container(
        width: width!*0.3,
        height: height! * 0.06,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Textcolor == null ? fontcolorprimary : buttoncolor,
          border: Textcolor != null
              ? Border.all(
            color: Textcolor,
            style: BorderStyle.solid,
            width: 1,
          )
              : null,
        ),
        child: Center(
            child: PrimaryText(
              words: name,
              color: Textcolor != null ? Textcolor : Colors.white,
              fontsize: 18,
              fontfami: "Inter",
            )),
      ),
    ),
  );
}


void showresult(
    BuildContext context,
    Color color,
    String text,
    ) =>
    toastification.show(
      context: context,

      backgroundColor: color,
      autoCloseDuration: const Duration(seconds: 3),
      style: ToastificationStyle.flat,
      description: PrimaryText(
        words: text,
        fontsize: 14,
        wight: FontWeight.w400,
      ),
      borderRadius: BorderRadius.circular(12),
    );

void navigateTo(context,widget) => Navigator.push
  (
  context,
  MaterialPageRoute(
    builder:(context) => widget,
  ),
);

void navigateAndFinish(context,widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder:(context) => widget,
  ),
      (route) => false,
);

Widget homeBuilder(context , taskmodel model) => Padding(
  padding: const EdgeInsets.all(6.0),
  child:Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          spreadRadius: 3,
          blurRadius: 4,
          offset: Offset(
            2,
            4,
          ),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("To Do: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SecondlyText(words:"${model.todo}".substring(0,9)+"...",
                      
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height! * 0.05,
                  ),
                  Row(
                    children: [
                      Text("Compleated: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SecondlyText(words:"${model.completed}",

                      ),
                    ],
                  ),
                  SizedBox(
                    height: height! * 0.007,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      IconButton(
                          icon:Icon(Icons.arrow_forward_ios),
                        onPressed: () {  navigateTo(context, edittask(model: model,));},)
                    ],
                  )


                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);

Widget buildlistpagination({required int number,required Appcubit cubit,required int limit,required int skip})=>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap:()  async {
          await cubit.getlimittasks(limit: limit, skip: skip);
          cubit.changenlistindex(number-1);
        } ,
        child: Container(
          width: width!*0.1,
          height: width!*0.1,
          decoration: BoxDecoration(
            color: cubit.selectedlistindex==number-1 ? cubit.selectedlistcolor:Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
          ),
          child: Center(
        child: Text(
          "${number}",
          style: TextStyle(fontSize: 24),
        ),
          ),
        ),
      ),
    );
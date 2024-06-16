abstract class Appstates{}
class initstate extends Appstates{}
class ChangePasswordIconState extends Appstates{}
class loginloadstate extends Appstates{}
class loginsuccessstate extends Appstates{}
class loginerrorstate extends Appstates{}
class addloadstate extends Appstates{}
class addsuccessstate extends Appstates{}
class adderrorstate extends Appstates{}
class updateloadstate extends Appstates{}
class updatesuccessstate extends Appstates{
  String message;
  updatesuccessstate({required this.message});
}
class updateerrorstate extends Appstates{
  String message;
  updateerrorstate({required this.message});
}
class setcompletestate extends Appstates{}
///////
class gettaskloadstate extends Appstates{}
class gettasksuccessstate extends Appstates{}
class gettaskerrorstate extends Appstates{}
/////////////
class creatdbloadstate extends Appstates{}
class creatdbsucstate extends Appstates{}
class creatdberrstate extends Appstates{}
class insertdbloadstate extends Appstates{}
class insertdbsucstate extends Appstates{}
class insertdberrstate extends Appstates{}
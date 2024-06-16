class usermodel{
  int? id;
  String?username;
  String? token;
  String? refreshtoken;
  usermodel({
    required this.id,
    required this.username,
    required this.token,
    required this.refreshtoken,
});
  usermodel.fromJson(dynamic data){
    id=data["id"];
    username=data["username"];
    token=data["token"];
    refreshtoken=data["refreshToken"];

  }
}
class taskmodel{
  int? id;
  String? todo;
  bool? completed;
  int? userId;
  taskmodel({
    required this.id,
    required this.completed,
    required this.todo,
    required this.userId,
});
  taskmodel.fromJson(dynamic data){
    id=data["id"];
    completed=data["completed"];
    todo=data["todo"];
    userId=data["userId"];
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': todo,
      'userId': userId,
      'completed': completed,
    };
  }
}

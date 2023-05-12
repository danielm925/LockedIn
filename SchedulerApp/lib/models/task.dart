class Task{
  int? id;
  String? name;
  String? description;
  int? isCompleted;
  String? date;
  String? time;

  Task({
    this.id,
    this.name,
    this.description,
    this.isCompleted,
    this.date,
    this.time
});

  Task.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['isCompleted'] = isCompleted;
    data['date'] = date;
    data['time'] = time;

    return data;
  }
}
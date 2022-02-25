class Employee {
  int? id;
  String name;
  int salary;
  int age;
  String image;

  Employee({required this.id,required this.name,required this.salary,required this.age,required this.image});

  Employee.from({required this.name,required this.salary,required this.age,required this.image});

  Employee.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['employee_name'],
        salary = json['employee_salary'],
        age = json['employee_age'],
        image = json['profile_image'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'employee_name': name,
    'employee_salary': salary,
    'age': age,
    'profile_image': image,
  };
}

class EmployeeList{
  String status;
  String message;
  List<Employee> data;

  EmployeeList.fromJson(Map<String, dynamic> json)
      : status = json["status"],
        message = json["message"],
        data = List<Employee>.from(json["data"].map((e) => Employee.fromJson(e)));

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List.from(data.map((e) => e.toJson())),
  };
}

class EmployeeMap{
  String status;
  String message;
  Employee data;

  EmployeeMap.fromJson(Map<String, dynamic> json)
      : status = json["status"],
        message = json["message"],
        data = Employee.fromJson(json["data"]);

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}
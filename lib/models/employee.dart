import 'package:flutter_app/models/position.dart';

import 'branch.dart';
import 'department.dart';

class Employee {
  String id;
  String name;
  String gender;
  DateTime birthDate;
  String address;
  String phoneNumber;
  String email;
  Department department;
  Position position;
  Branch branch;
  double salary;

  Employee({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.department,
    required this.position,
    required this.branch,
    required this.salary,
  });
}

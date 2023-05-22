import 'package:flutter_app/models/employee.dart';

class Job {
  String id;
  String name;
  String description;
  DateTime startTime;
  DateTime endTime;
  String employeeId;

  Job({
    required this.id,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.employeeId,
  });
}

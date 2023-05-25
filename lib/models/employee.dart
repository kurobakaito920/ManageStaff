import 'dart:math';

import 'package:flutter_app/models/position.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'branch.dart';
import 'department.dart';

class Employee {
  String? id;
  String name;
  String gender;
  DateTime birthDate;
  String address;
  String phoneNumber;
  String email;
  String department;
  Position position;
  Branch branch;
  double salary;

  Employee({
    this.id,
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

  Employee.fromJson(Map<String, Object?> json) : this(
    name: json['name']! as String,
    gender: json['gender']! as String,
    birthDate: json['birthDate']! as DateTime,
    address: json['address']! as String,
    phoneNumber: json['phoneNumber']! as String,
    email: json['email']! as String,
    department: json['department']! as String,
    position: json['position']! as Position,
    branch: json['branch']! as Branch,
    salary: json['salary']! as double,
  );

  Map<String, Object?> toJson(){
    return{
      'name': name,
      'gender': gender,
      'birthDate': birthDate,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'department': department,
      'position': position,
      'branch': branch,
      'salary': salary,
    };
  }

  final employeeRef = FirebaseFirestore.instance.collection('employees')
    .withConverter(fromFirestore: (snapshot, _) => Employee.fromJson(snapshot.data()!), 
    toFirestore: (employee, _) => employee.toJson(),
  );
}
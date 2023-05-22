import 'package:cloud_firestore/cloud_firestore.dart';
class Department {
  String? id;
  String name;
  String description;
  int numberOfEmployees;

  // Constructor
  Department({
    this.id,
    required this.name,
    required this.description,
    required this.numberOfEmployees,
  });
  
   Department.fromJson(Map<String, Object?> json) : this(
    name: json['name']! as String,
    description: json['description']! as String,
    numberOfEmployees: json['numberOfEmployees']! as int,
  );

  Map<String, Object?> toJson(){
    return {
      "name" : name,
      "description" : description,
      "numberOfEmployees" : numberOfEmployees,
    };
  }
  final departmentRef = FirebaseFirestore.instance.collection('departments')
      .withConverter(fromFirestore: (snapshot, _) => Department.fromJson(snapshot.data()!),
    toFirestore: (department, _) => department.toJson(),
  );
}
import 'package:cloud_firestore/cloud_firestore.dart';

class Position {
  String? id;
  String name;
  String description;
  double hourlyRate; // Mức lương theo giờ
  double averageSalary; // Mức lương trung bình

  Position({
    this.id,
    required this.name,
    required this.description,
    required this.hourlyRate,
    required this.averageSalary,
  });

  Position.fromJson(Map<String, Object?> json) : this(
    name: json['name']! as String,
    description: json['description']! as String,
    hourlyRate: json['hourlyRate']! as double,
    averageSalary: json['averageSalary']! as double,
  );

  Map<String, Object?> toJson(){
    return {
      'name': name,
      'description': description,
      'hourlyRate': hourlyRate,
      'averageSalary': averageSalary,
    };
  }

  final positionRef = FirebaseFirestore.instance.collection('positions')
    .withConverter(fromFirestore: (snapshot, _) => Position.fromJson(snapshot.data()!),
    toFirestore: (position, _) => position.toJson(),
  );
}

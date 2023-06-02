import 'package:flutter_app/models/employee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  String? id;
  String name;
  String description;
  String dateWork;
  String dateEnd;
  String startTime;
  String endTime;
  String employeeWork;

  Job({
    this.id,
    required this.name,
    required this.description,
    required this.dateWork,
    required this.dateEnd,
    required this.startTime,
    required this.endTime,
    required this.employeeWork,
  });
  Job.fromJson(Map<String, Object?>json) : this(
    name: json['name']! as String,
    description: json['description']! as String,
    dateWork: json['dateWork']! as String,
    dateEnd: json['dateEnd']! as String,
    startTime: json['startTime']! as String,
    endTime: json['endTime']! as String,
    employeeWork: json['employeeWork']! as String,
  );

  Map<String, Object?> toJson(){
    return{
      'name': name,
      'description': description,
      'dateWork': dateWork,
      'dateEnd': dateEnd,
      'startTime': startTime,
      'endTime': endTime,
      'employeeWork': employeeWork,
    };
  }

  final jobRef = FirebaseFirestore.instance.collection('Jobs')
    .withConverter(fromFirestore: (snapshot, _) => Job.fromJson(snapshot.data()!), 
    toFirestore: (job, _) => job.toJson(),
  );
}

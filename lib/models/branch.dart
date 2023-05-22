import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/data/data.dart';

class Branch {
  String? id;
  String name;
  String address;
  String phoneNumber;
  String email;


  Branch({
    this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.email,
  });

  Branch.fromJson(Map<String, Object?> json) : this(
    name: json['name']! as String,
    address: json['address']! as String,
    phoneNumber: json['phoneNumber']! as String,
    email: json['email']! as String,
  );

  Map<String, Object?> toJson(){
    return {
      "name" : name,
      "address" : address,
      "phoneNumber" : phoneNumber,
      "email" : email
    };
  }

  /*toJson(){
    return {
      "name" : name,
      "address" : address,
      "phoneNumber" : phoneNumber,
      "email" : email
    };
  }*/

  final branchRef = FirebaseFirestore.instance.collection('branch')
      .withConverter(fromFirestore: (snapshot, _) => Branch.fromJson(snapshot.data()!),
    toFirestore: (branch, _) => branch.toJson(),
  );
}

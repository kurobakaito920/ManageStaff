import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screen/job_management_page.dart';

import '../models/employee.dart';
import '../models/job.dart';

class JobList extends StatelessWidget {
  final List<Job> jobs = [];

  JobList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tạo Map lưu danh sách nhân viên cho từng công việc
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return Center(
              child: Text('Error loading jobs.'),
            );
          }
          final List<Job> jobs = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Job.fromJson(data);
          }).toList();

          return FutureBuilder<Map<String, List<Employee>>>(
            future: getEmployeesForJobs(jobs),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                final employeesForJobs = snapshot.data!;
                return ListView.builder(
                  itemCount: employeesForJobs.length,
                  itemBuilder: (context, index) {
                    final jobNames = employeesForJobs.keys.toList();
                    final jobName = jobNames[index];
                    final employeesForJob = employeesForJobs[jobName]!;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 2,
                        child: ExpansionTile(
                          title: Text(jobName),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: employeesForJob
                                    .map((employee) => _buildEmployeeCard(employee))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading employees.'),
                );
              } else {
                return Center(
                  child: Text('No employees found.'),
                );
              }
            },
          );
        },
      ),
    );
  }

  Future<Map<String, List<Employee>>> getEmployeesForJobs(List<Job> jobs) async {
    final employeesForJobs = <String, List<Employee>>{};
    final xJob = FirebaseFirestore.instance.collection('employees');

    for (final job in jobs) {
      if (!employeesForJobs.containsKey(job.name)) {
        employeesForJobs[job.name] = [];
      }
      final employeeSnapshot = await xJob.doc(job.employeeWork).get();
      if (employeeSnapshot.exists) {
        final employeeData = employeeSnapshot.data() as Map<String, dynamic>;
        final employee = Employee.fromJson(employeeData);
        employeesForJobs[job.name]!.add(employee);
      }
    }

    return employeesForJobs;
  }

  Widget _buildEmployeeCard(Employee employee) {
    CollectionReference xEmployees = FirebaseFirestore.instance.collection('employees');
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: ListTile(
          title: Text(employee.name),
          subtitle: FutureBuilder<DocumentSnapshot>(
            future: xEmployees.doc(employee.id).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading position...');
              }
              if (snapshot.hasData) {
                final positionData = snapshot.data!.data() as Map<String, dynamic>?;
                final positionName = positionData?['name'];
                return Text('$positionName - ${employee.department}');
              } else if (snapshot.hasError) {
                return Text('Error loading position');
              } else {
                return Text('Position not found');
              }
            },
          ),
          trailing: Text('\$${employee.salary.toStringAsFixed(2)}'),
        ),
      ),
    );
  }
}
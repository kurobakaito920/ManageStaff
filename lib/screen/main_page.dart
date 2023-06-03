import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/job.dart';
import 'package:flutter_app/screen/branch_page.dart';
import 'package:flutter_app/screen/employee.dart';
import 'package:flutter_app/screen/job_page.dart';
import 'package:flutter_app/screen/position_page.dart';
import 'package:flutter_app/screen/salary_calculator_page.dart';

import '../data/data.dart';
import '../models/employee.dart';
import 'department_page.dart';
import 'job_management_page.dart';
import 'login_page.dart';

class MainPage extends StatelessWidget {
  final List<Job> jobs = [];
  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Page"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Sidebar'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Quản lý nhân viên'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployeePage()),
                );
              },
            ),
            ListTile(
              title: Text('Quản lý phòng ban'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DepartmentPage()),
                );
              },
            ),
            ListTile(
              title: Text('Quản lý chức vụ'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PositionPage()),
                );
              },
            ),
            ListTile(
              title: Text('Quản lý chi nhánh'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BranchPage()),
                );
              },
            ),
            ListTile(
              title: Text('Quản lý công việc'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JobPage()),
                );
              },
            ),
            ListTile(
              title: Text('Tính lương nhân viên'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SalaryCalculator()),
                );
              },
            ),
            ListTile(
              title: Text('Đăng xuất'),
              onTap: () {
                _auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
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
                final positionName = employee.position;
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

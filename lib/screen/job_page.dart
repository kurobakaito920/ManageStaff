import 'package:flutter/material.dart';

import '../data/data.dart';
import '../models/employee.dart';
import '../models/job.dart';

class JobList extends StatelessWidget {
  final List<Job> jobs;

  const JobList({Key? key, required this.jobs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tạo Map lưu danh sách nhân viên cho từng công việc
    final Map<String, List<Employee>> employeesForJobs = {};
    for (final job in jobs) {
      if (!employeesForJobs.containsKey(job.name)) {
        employeesForJobs[job.name] = [];
      }
      // final employee = employees.firstWhere((e) => e.id == job.employeeId);
      // employeesForJobs[job.name]!.add(employee);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
      ),
      body: ListView.builder(
        itemCount: employeesForJobs.length,
        itemBuilder: (context, index) {
          // Lấy tất cả các key của Map và chuyển sang List để truy xuất
          final jobNames = employeesForJobs.keys.toList();
          // Lấy tên của công việc tại vị trí index
          final jobName = jobNames[index];
          // Lấy danh sách nhân viên thực hiện công việc đó
          final employeesForJob = employeesForJobs[jobName]!;

          // Tạo Card hiển thị thông tin công việc và danh sách nhân viên
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2,
              child: ExpansionTile(
                title: Text(jobName),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
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
      ),
    );
  }

  Widget _buildEmployeeCard(Employee employee) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        // child: ListTile(
        //   title: Text(employee.name),
        //   subtitle:
        //       Text('${employee.position.name} - ${employee.department.name}'),
        //   trailing: Text('\$${employee.salary.toStringAsFixed(2)}'),
        // ),
      ),
    );
  }
}

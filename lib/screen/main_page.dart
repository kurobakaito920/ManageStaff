import 'package:flutter/material.dart';
import 'package:flutter_app/models/job.dart';
import 'package:flutter_app/screen/branch_page.dart';
import 'package:flutter_app/screen/employee.dart';
import 'package:flutter_app/screen/job_page.dart';
import 'package:flutter_app/screen/position_page.dart';
import 'package:flutter_app/screen/salary_calculator_page.dart';

import '../data/data.dart';
import 'department_page.dart';
import 'job_management_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              title: Text('Công việc theo từng nhân viên'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JobList(jobs: jobs)),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Trang chính'),
      ),
    );
  }
}

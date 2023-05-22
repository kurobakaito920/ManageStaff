import 'package:flutter/material.dart';
import 'package:flutter_app/models/employee.dart';

import '../data/data.dart';

class SalaryCalculator extends StatefulWidget {
  const SalaryCalculator({Key? key}) : super(key: key);

  @override
  _SalaryCalculatorState createState() => _SalaryCalculatorState();
}

class _SalaryCalculatorState extends State<SalaryCalculator> {
  String selectedOption = 'Per hour'; // Lựa chọn tính lương
  void calculateSalary() {
    final List<String> salaryInfo =
        []; // Danh sách lưu thông tin lương của các nhân viên

    for (final employee in employees) {
      double salary;
      if (selectedOption == 'Per hour') {
        const totalHours = 160;
        salary = employee.position.hourlyRate * totalHours;
      } else {
        salary = employee.position.averageSalary;
      }
      employee.salary = salary;

      // Thêm thông tin lương của nhân viên vào danh sách
      salaryInfo.add('${employee.name}: $salary \$');
    }

    // Hiển thị thông tin lương của tất cả các nhân viên bằng một hộp thoại
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Employee salaries'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: salaryInfo.map((info) => Text(info)).toList(),
        ),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculate employee salaries'),
      ),
      body: Column(
        children: [
          // Chọn phương thức tính lương
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Calculate salary by '),
              DropdownButton<String>(
                value: selectedOption,
                items: <String>['Per hour', 'Theo chức vụ']
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedOption = value!;
                  });
                },
              ),
            ],
          ),
          // Hiển thị danh sách nhân viên
          Expanded(
            child: ListView.builder(
              itemCount: employees.length,
              itemBuilder: (BuildContext context, int index) {
                final employee = employees[index];
                return Card(
                  child: ListTile(
                    title: Text(employee.name),
                    subtitle: Text('Position: ${employee.position.name}'),
                    trailing: Text('Salary: ${employee.salary} \$'),
                  ),
                );
              },
            ),
          ),
          // Nút tính lương
          ElevatedButton(
            onPressed: () {
              // Thực hiện tính lương
              calculateSalary();
            },
            child: const Text('Calculate salary'),
          ),
        ],
      ),
    );
  }
}

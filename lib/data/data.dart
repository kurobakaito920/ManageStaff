import 'package:flutter_app/models/position.dart';

import '../models/branch.dart';
import '../models/department.dart';
import '../models/employee.dart';
import '../models/job.dart';

//! Employee
// List<Employee> employees = [
//   Employee(
//     id: '1',
//     name: 'John Smith',
//     gender: 'Male',
//     birthDate: DateTime(1985, 12, 1),
//     address: '123 Main St, Anytown, USA',
//     phoneNumber: '555-1234',
//     email: 'john.smith@example.com',
//     department: departments[0], // Sales department
//     position: positions[0], // Sales Representative
//     branch: branches[0],
//     salary: 2500.00,
//   ),
//   Employee(
//     id: '2',
//     name: 'Jane Doe',
//     gender: 'Female',
//     birthDate: DateTime(1990, 6, 15),
//     address: '456 Elm St, Anytown, USA',
//     phoneNumber: '555-5678',
//     email: 'jane.doe@example.com',
//     department: departments[1], // Marketing department
//     position: positions[1], // Marketing Specialist
//     branch: branches[0],
//     salary: 3000.00,
//   ),
//   Employee(
//     id: '3',
//     name: 'Thanh Ty',
//     gender: 'Female',
//     birthDate: DateTime(1990, 6, 15),
//     address: '456 Elm St, Anytown, USA',
//     phoneNumber: '555-5678',
//     email: 'jane.doe@example.com',
//     department: departments[1], // Marketing department
//     position: positions[1], // Marketing Specialist
//     branch: branches[0],
//     salary: 3000.00,
//   ),
// ];

//! Department
List<Department> departments = [
  Department(
    id: '001',
    name: 'Sales',
    description: 'Responsible for sales activities',
    numberOfEmployees: 10,
  ),
  Department(
    id: '002',
    name: 'Marketing',
    description: 'Responsible for marketing activities',
    numberOfEmployees: 8,
  ),
];

//! Position
final positions = [
  Position(
    id: '1',
    name: 'Sales Representative',
    description: 'Sells products to customers',
    hourlyRate: 20.0, // Giả sử mức lương theo giờ là 20 $
    averageSalary: 2500.0, // Giả sử mức lương trung bình của Sales Representative là 2,500 $/tháng
  ),
  Position(
    id: '2',
    name: 'Marketing Specialist',
    description: 'Develops marketing campaigns',
    hourlyRate: 25.0, // Giả sử mức lương theo giờ là 25 $
    averageSalary: 3000.0, // Giả sử mức lương trung bình của Marketing Specialist là 3,000 $/tháng
  ),
];

//! Branch
List<Branch> branches = [
  Branch(
    id: '1',
    name: 'Main Branch',
    address: '789 Oak St, Anytown, USA',
    phoneNumber: '555-9012',
    email: 'main@example.com',
  ),
  Branch(
    id: '2',
    name: 'Branch 2',
    address: '456 Elm St, Anytown, USA',
    phoneNumber: '555-5678',
    email: 'branch2@example.com',
  ),
];
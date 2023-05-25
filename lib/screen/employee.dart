import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../models/employee.dart';
//import '../data/data.dart';
import '../models/department.dart';
import '../models/position.dart';
import '../models/branch.dart';

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  bool _showDetails = false;
  Employee? _selectedEmployee;
  CollectionReference xEmployee = FirebaseFirestore.instance.collection('employees');
  //List<Department> departments = [];
  List<Position> positions = [];
  List<Branch> branches = [];
  Future<void> _addNewEmployee() async{
    Employee newEmployee = Employee(
      name: '',
      gender: '',
      birthDate: DateTime.now(),
      address: '',
      phoneNumber: '',
      email: '',
      department: Department.fromJson(Map<String, Object?>()),
      position: positions[0],
      branch: branches[0],
      salary: 0.0,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Employee'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    newEmployee.name = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Gender'),
                  onChanged: (value) {
                    newEmployee.gender = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Birth Date'),
                  onChanged: (value) {
                    newEmployee.birthDate = DateTime.parse(value);
                  },
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address'),
                  onChanged: (value) {
                    newEmployee.address = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  onChanged: (value) {
                    newEmployee.phoneNumber = value;
                  },
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (value) {
                    newEmployee.email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('departments').snapshots(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      return const Center(
                        child: const CircularProgressIndicator(),
                      );
                    }
                    return DropdownButtonFormField<Department>(
                      decoration: InputDecoration(labelText: 'Department'),
                      value: newEmployee.department,
                      onChanged: (value) {
                        setState(() {
                          newEmployee.department = value!;
                        });
                      },
                      items: snapshot.data!.docs.map((DocumentSnapshot doc){
                        final departmentData = doc.data() as Map<String, dynamic>;
                        return DropdownMenuItem<Department>(
                          value: Department.fromJson(departmentData),
                          child: Text(departmentData['name'] as String),
                        );
                      }).toList(),
                    );
                  },
                ),
                // DropdownButtonFormField<Position>(
                //   decoration: InputDecoration(labelText: 'Position'),
                //   value: newEmployee.position,
                //   onChanged: (value) {
                //     setState(() {
                //       newEmployee.position = value!;
                //     });
                //   },
                //   items: positions
                //       .map((position) => DropdownMenuItem<Position>(
                //             value: position,
                //             child: Text(position.name),
                //           ))
                //       .toList(),
                // ),
                // DropdownButtonFormField<Branch>(
                //   decoration: InputDecoration(labelText: 'Branch'),
                //   value: newEmployee.branch,
                //   onChanged: (value) {
                //     setState(() {
                //       newEmployee.branch = value!;
                //     });
                //   },
                //   items: branches
                //       .map((branch) => DropdownMenuItem<Branch>(
                //             value: branch,
                //             child: Text(branch.name),
                //           ))
                //       .toList(),
                // ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Salary'),
                  onChanged: (value) {
                    newEmployee.salary = double.parse(value);
                  },
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  //employees.add(newEmployee);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees'),
      ),
      // body: ListView.builder(
      //   itemCount: employees.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     return Padding(
      //       padding:
      //           const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      //       child: Card(
      //         elevation: 4,
      //         child: ListTile(
      //           title: Text(employees[index].name),
      //           subtitle: _showDetails
      //               ? Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Text('name: ${employees[index].name}'),
      //                     Text('gender: ${employees[index].gender}'),
      //                     Text('birthDate: ${employees[index].birthDate}'),
      //                     Text('address: ${employees[index].address}'),
      //                     Text('phoneNumber: ${employees[index].phoneNumber}'),
      //                     Text('email: ${employees[index].email}'),
      //                     Text(
      //                         'department: ${employees[index].department.name}'),
      //                     Text('position: ${employees[index].position.name}'),
      //                     Text('branch: ${employees[index].branch.name}'),
      //                     Text('salary: ${employees[index].salary}'),
      //                   ],
      //                 )
      //               : null,
      //           trailing: Row(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               IconButton(
      //                 icon: Icon(
      //                   Icons.edit,
      //                   color: Colors.blue,
      //                 ),
      //                 onPressed: () {
      //                   setState(() {
      //                     _selectedEmployee = employees[index];
      //                   });
      //                   showDialog(
      //                     context: context,
      //                     builder: (BuildContext context) {
      //                       return AlertDialog(
      //                         title: Text('Edit Job'),
      //                         content: SingleChildScrollView(
      //                           child: Column(
      //                             mainAxisSize: MainAxisSize.min,
      //                             children: [
      //                               TextField(
      //                                 decoration:
      //                                     InputDecoration(labelText: 'Name'),
      //                                 onChanged: (value) {
      //                                   setState(() {
      //                                     _selectedEmployee!.name = value;
      //                                   });
      //                                 },
      //                                 controller: TextEditingController(
      //                                     text: _selectedEmployee!.name),
      //                               ),
      //                               TextField(
      //                                 decoration:
      //                                     InputDecoration(labelText: 'Gender'),
      //                                 onChanged: (value) {
      //                                   setState(() {
      //                                     _selectedEmployee!.gender = value;
      //                                   });
      //                                 },
      //                                 controller: TextEditingController(
      //                                     text: _selectedEmployee!.gender),
      //                               ),
      //                               TextField(
      //                                 decoration: InputDecoration(
      //                                     labelText: 'Birth Date'),
      //                                 onChanged: (value) {
      //                                   setState(() {
      //                                     _selectedEmployee!.birthDate =
      //                                         value as DateTime;
      //                                   });
      //                                 },
      //                                 controller: TextEditingController(
      //                                     text: _selectedEmployee!.birthDate
      //                                         .toString()),
      //                               ),
      //                               TextField(
      //                                 decoration:
      //                                     InputDecoration(labelText: 'Address'),
      //                                 onChanged: (value) {
      //                                   setState(() {
      //                                     _selectedEmployee!.address = value;
      //                                   });
      //                                 },
      //                                 controller: TextEditingController(
      //                                     text: _selectedEmployee!.address),
      //                               ),
      //                               TextField(
      //                                 decoration: InputDecoration(
      //                                     labelText: 'phoneNumber'),
      //                                 onChanged: (value) {
      //                                   setState(() {
      //                                     _selectedEmployee!.phoneNumber =
      //                                         value;
      //                                   });
      //                                 },
      //                                 controller: TextEditingController(
      //                                     text: _selectedEmployee!.phoneNumber),
      //                               ),
      //                               TextField(
      //                                 decoration:
      //                                     InputDecoration(labelText: 'email'),
      //                                 onChanged: (value) {
      //                                   setState(() {
      //                                     _selectedEmployee!.email = value;
      //                                   });
      //                                 },
      //                                 controller: TextEditingController(
      //                                     text: _selectedEmployee!.email),
      //                               ),
      //                               TextField(
      //                                 decoration: InputDecoration(
      //                                     labelText: 'department'),
      //                                 onChanged: (value) {
      //                                   setState(() {
      //                                     _selectedEmployee!.department.name =
      //                                         value;
      //                                   });
      //                                 },
      //                                 controller: TextEditingController(
      //                                     text: _selectedEmployee!
      //                                         .department.name),
      //                               ),
      //                               TextField(
      //                                 decoration: InputDecoration(
      //                                     labelText: 'position'),
      //                                 onChanged: (value) {
      //                                   setState(() {
      //                                     _selectedEmployee!.position.name =
      //                                         value;
      //                                   });
      //                                 },
      //                                 controller: TextEditingController(
      //                                     text:
      //                                         _selectedEmployee!.position.name),
      //                               ),
      //                               TextField(
      //                                 decoration:
      //                                     InputDecoration(labelText: 'branch'),
      //                                 onChanged: (value) {
      //                                   setState(() {
      //                                     _selectedEmployee!.branch.name =
      //                                         value;
      //                                   });
      //                                 },
      //                                 controller: TextEditingController(
      //                                     text: _selectedEmployee!.branch.name),
      //                               ),
      //                               TextField(
      //                                 decoration:
      //                                     InputDecoration(labelText: 'salary'),
      //                                 onChanged: (value) {
      //                                   setState(() {
      //                                     _selectedEmployee!.salary =
      //                                         value as double;
      //                                   });
      //                                 },
      //                                 controller: TextEditingController(
      //                                     text: _selectedEmployee!.salary
      //                                         .toString()),
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                         actions: [
      //                           TextButton(
      //                             child: Text('Cancel'),
      //                             onPressed: () {
      //                               setState(() {
      //                                 _selectedEmployee = null;
      //                               });
      //                               Navigator.of(context).pop();
      //                             },
      //                           ),
      //                           TextButton(
      //                             child: Text('Save'),
      //                             onPressed: () {
      //                               setState(() {
      //                                 employees[index] = _selectedEmployee!;
      //                                 _selectedEmployee = null;
      //                               });
      //                               Navigator.of(context).pop();
      //                             },
      //                           ),
      //                         ],
      //                       );
      //                     },
      //                   );
      //                 },
      //               ),
      //               IconButton(
      //                 icon: Icon(
      //                   Icons.delete,
      //                   color: Colors.red,
      //                 ),
      //                 onPressed: () {
      //                   showDialog(
      //                     context: context,
      //                     builder: (BuildContext context) {
      //                       return AlertDialog(
      //                         title: Text('Confirm'),
      //                         content: Text(
      //                             'Are you sure you want to delete this employee?'),
      //                         actions: [
      //                           TextButton(
      //                             child: Text('Cancel'),
      //                             onPressed: () {
      //                               Navigator.of(context).pop();
      //                             },
      //                           ),
      //                           TextButton(
      //                             child: Text('Delete'),
      //                             onPressed: () {
      //                               setState(() {
      //                                 employees.removeAt(index);
      //                               });
      //                               Navigator.of(context).pop();
      //                             },
      //                           ),
      //                         ],
      //                       );
      //                     },
      //                   );
      //                 },
      //               ),
      //             ],
      //           ),
      //           onTap: () {
      //             showDialog(
      //               context: context,
      //               builder: (BuildContext context) {
      //                 return EmployeeDetailDialog(employee: employees[index]);
      //               },
      //             );
      //           },
      //         ),
      //       ),
      //     );
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewEmployee,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class EmployeeDetailDialog extends StatelessWidget {
  final Employee employee;
  const EmployeeDetailDialog({required this.employee, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(employee.name),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${employee.id}'),
            Text('name: ${employee.name}'),
            Text('gender: ${employee.gender}'),
            Text('address: ${employee.address}'),
            Text('phoneNumber: ${employee.phoneNumber}'),
            Text('email: ${employee.email}'),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

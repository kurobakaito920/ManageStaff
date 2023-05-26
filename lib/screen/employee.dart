import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../models/employee.dart';
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
  List<DropdownMenuItem<String>> lstDepartments = [], lstBranches = [], lstPosition = [];
  Future<void> _addNewEmployee() async{
    Employee newEmployee = Employee(
      name: '',
      gender: '',
      birthDate: DateTime.now(),
      address: '',
      phoneNumber: '',
      email: '',
      department: '',
      position: '',
      branch: '',
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
                      return CircularProgressIndicator();
                    } else {
                      final dePartment = snapshot.data?.docs.reversed.toList();
                      lstDepartments = [];
                      for(var i in dePartment!) {
                        lstDepartments.add(DropdownMenuItem(
                          value: i.id,
                          child: Text(i['name'],),
                        ));
                      }
                    }
                    String? initalValue = newEmployee.department.isNotEmpty ? lstDepartments[0].value : null;
                    return DropdownButtonFormField<String>(
                      items: lstDepartments, 
                      onChanged: (value){
                        setState(() {
                          newEmployee.department = value!;
                        });
                      },
                      value: initalValue,
                      isExpanded: false,
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('positions').snapshots(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      return CircularProgressIndicator();
                    } else {
                      final positions = snapshot.data?.docs.reversed.toList();
                      lstPosition = [];
                      for(var i in positions!) {
                        lstPosition.add(DropdownMenuItem(
                          value: i.id,
                          child: Text(i['name'],),
                        ));
                      }
                    }
                    String? initalValue = newEmployee.position.isNotEmpty ? lstPosition[0].value : null;
                    return DropdownButtonFormField<String>(
                      items: lstPosition, 
                      onChanged: (value){
                        setState(() {
                          newEmployee.position = value!;
                        });
                      },
                      value: initalValue,
                      isExpanded: false,
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('branch').snapshots(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      return CircularProgressIndicator();
                    } else {
                      final branches = snapshot.data?.docs.reversed.toList();
                      lstBranches = [];
                      for(var i in branches!) {
                        lstBranches.add(DropdownMenuItem(
                          value: i.id,
                          child: Text(i['name'],),
                        ));
                      }
                    }
                    String? initalValue = newEmployee.branch.isNotEmpty ? lstBranches[0].value : null;
                    return DropdownButtonFormField<String>(
                      items: lstBranches, 
                      onChanged: (value){
                        setState(() {
                          newEmployee.branch = value!;
                        });
                      },
                      value: initalValue,
                      isExpanded: false,
                    );
                  },
                ),
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
                  xEmployee.add({
                    'name': newEmployee.name,
                    'gender': newEmployee.gender,
                    'birthDate': newEmployee.birthDate,
                    'address': newEmployee.address,
                    'phoneNumber': newEmployee.phoneNumber,
                    'email': newEmployee.email,
                    'department': newEmployee.department,
                    'position': newEmployee.position,
                    'branch': newEmployee.branch,
                    'salary': newEmployee.salary.toDouble(),
                  }).then((value) => print('Lưu thành công')).catchError((error) => print('Lỗi: ${error}'));
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('employees').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data != null){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text(snapshot.data!.docs[index].get('name')),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: (){
                              setState(() {
                                _selectedEmployee = Employee(
                                  name: snapshot.data!.docs[index].get('name'), 
                                  gender: snapshot.data!.docs[index].get('gender'), 
                                  birthDate: snapshot.data!.docs[index].get('birthDate'), 
                                  address: snapshot.data!.docs[index].get('address'), 
                                  phoneNumber: snapshot.data!.docs[index].get('phoneNumber'), 
                                  department: xEmployee.where('departments').get().toString(),
                                  position: xEmployee.where('departments').get().toString(),
                                  branch: xEmployee.where('departments').get().toString(),
                                  email: snapshot.data!.docs[index].get('email'),  
                                  salary: snapshot.data!.docs[index].get('salary'),
                                ); 
                              });
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Edit Job'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            decoration:
                                                InputDecoration(labelText: 'Name'),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedEmployee!.name = value;
                                              });
                                            },
                                            controller: TextEditingController(
                                                text: _selectedEmployee!.name),
                                          ),
                                          TextField(
                                            decoration:
                                                InputDecoration(labelText: 'Gender'),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedEmployee!.gender = value;
                                              });
                                            },
                                            controller: TextEditingController(
                                                text: _selectedEmployee!.gender),
                                          ),
                                          TextField(
                                            decoration:
                                                InputDecoration(labelText: 'Address'),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedEmployee!.address = value;
                                              });
                                            },
                                            controller: TextEditingController(
                                                text: _selectedEmployee!.address),
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                                labelText: 'phoneNumber'),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedEmployee!.phoneNumber =
                                                    value;
                                              });
                                            },
                                            controller: TextEditingController(
                                                text: _selectedEmployee!.phoneNumber),
                                          ),
                                          TextField(
                                            decoration:
                                                InputDecoration(labelText: 'email'),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedEmployee!.email = value;
                                              });
                                            },
                                            controller: TextEditingController(
                                                text: _selectedEmployee!.email),
                                          ),
                                          // TextField(
                                          //   decoration: InputDecoration(
                                          //       labelText: 'department'),
                                          //   onChanged: (value) {
                                          //     setState(() {
                                          //       _selectedEmployee!.department.name =
                                          //           value;
                                          //     });
                                          //   },
                                          //   controller: TextEditingController(
                                          //       text: _selectedEmployee!
                                          //           .department.name),
                                          // ),
                                          // TextField(
                                          //   decoration: InputDecoration(
                                          //       labelText: 'position'),
                                          //   onChanged: (value) {
                                          //     setState(() {
                                          //       _selectedEmployee!.position.name =
                                          //           value;
                                          //     });
                                          //   },
                                          //   controller: TextEditingController(
                                          //       text:
                                          //           _selectedEmployee!.position.name),
                                          // ),
                                          // TextField(
                                          //   decoration:
                                          //       InputDecoration(labelText: 'branch'),
                                          //   onChanged: (value) {
                                          //     setState(() {
                                          //       _selectedEmployee!.branch.name =
                                          //           value;
                                          //     });
                                          //   },
                                          //   controller: TextEditingController(
                                          //       text: _selectedEmployee!.branch.name),
                                          // ),
                                          TextField(
                                            decoration:
                                                InputDecoration(labelText: 'salary'),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedEmployee!.salary =
                                                    value as double;
                                              });
                                            },
                                            controller: TextEditingController(
                                                text: _selectedEmployee!.salary
                                                    .toString()),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          setState(() {
                                            _selectedEmployee = null;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Save'),
                                        onPressed: () {
                                          setState(() {
                                            xEmployee.doc(snapshot.data!.docs[index].id).update({
                                              'name': _selectedEmployee!.name,
                                              'gender': _selectedEmployee!.gender,
                                              'birthDate': _selectedEmployee!.birthDate,
                                              'address': _selectedEmployee!.address,
                                              'phoneNumber': _selectedEmployee!.phoneNumber,
                                              'email': _selectedEmployee!.email,
                                              'salary': _selectedEmployee!.salary,
                                            });
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm'),
                                    content: Text(
                                        'Are you sure you want to delete this employee?'),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Delete'),
                                        onPressed: () {
                                          setState(() {
                                            xEmployee.doc(snapshot.data!.docs[index].id).delete().then((value) => print('Xóa thành công')).catchError((error)=> print('Không thành công'));
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EmployeeDetailDialog(snapshot.data!.docs[index].id);
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError){
            return const Text('Error');
          } else{
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewEmployee,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class EmployeeDetailDialog extends StatelessWidget {
  final String id;
  const EmployeeDetailDialog(this.id);

  @override
  Widget build(BuildContext context) {
    CollectionReference yEmployee = FirebaseFirestore.instance.collection('employees');
    return FutureBuilder<DocumentSnapshot>(
      future: yEmployee.doc(id).get(),
      builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
          return AlertDialog(
            title: Text('${data['name']}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('name: ${data['name']}'),
                  Text('gender: ${data['gender']}'),
                  Text('address: ${data['address']}'),
                  Text('phoneNumber: ${data['phoneNumber']}'),
                  Text('email: ${data['email']}'),
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
        }else if(snapshot.hasData){
          return Text('Something went wrong');
        } else {
          return Text('Document does not exits');
        }
      },
    );
  }
}

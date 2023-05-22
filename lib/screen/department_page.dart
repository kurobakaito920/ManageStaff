import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/department.dart';

class DepartmentPage extends StatefulWidget {
  @override
  _DepartmentPageState createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  bool _showDetails = false;
  Department? _selectedDepartment;
  Department newDepartment = Department(name: '', description: '', numberOfEmployees: 0);
  CollectionReference xDepartment = FirebaseFirestore.instance.collection('departments');
  Future<void> _addNewDepartment() async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Department'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    newDepartment.name = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    newDepartment.description = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Number Of Employees'),
                  onChanged: (value) {
                    newDepartment.numberOfEmployees = int.parse(value);
                  },
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
                setState(() async{
                  QuerySnapshot existingDepartment = await xDepartment.where('name', isEqualTo: newDepartment.name).get();
                  if(existingDepartment.docs.isNotEmpty){
                    showDialog(
                      context: context, 
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text('THÔNG BÁO'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tên phòng ban đã tồn tại'),
                            ],
                          ),
                            actions: [  
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else{
                      xDepartment.add({
                      'name': newDepartment.name,
                      'description': newDepartment.description,
                      'numberOfEmployees' : newDepartment.numberOfEmployees,
                    }).then((value) => print("Thêm thành công")).catchError((error) => print("Lỗi: $error"));
                  }
                  Navigator.of(context).pop();
                });
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
        title: Text('Departments'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('departments').snapshots(),
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
                            onPressed: () {
                              setState(() {
                                _selectedDepartment = Department(
                                  name: snapshot.data!.docs[index].get('name'), 
                                  description: snapshot.data!.docs[index].get('description'), 
                                  numberOfEmployees: snapshot.data!.docs[index].get('numberOfEmployees'),
                                );
                              });
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Edit Department'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            decoration:
                                                InputDecoration(labelText: 'Name'),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedDepartment!.name = value;
                                              });
                                            },
                                            controller: TextEditingController(
                                                text: _selectedDepartment!.name),
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                                labelText: 'Description'),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedDepartment!.description =
                                                    value;
                                              });
                                            },
                                            controller: TextEditingController(
                                                text:
                                                    _selectedDepartment!.description),
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                                labelText: 'Number Of Employees'),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedDepartment!
                                                    .numberOfEmployees = value as int;
                                              });
                                            },
                                            controller: TextEditingController(
                                              text: _selectedDepartment
                                                      ?.numberOfEmployees
                                                      .toString() ??
                                                  '',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          setState(() {
                                            _selectedDepartment = null;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Save'),
                                        onPressed: () {
                                          setState(() async{
                                            QuerySnapshot existingDepartment = await xDepartment.where('name', isEqualTo: newDepartment.name).get();
                                            if(existingDepartment.docs.isNotEmpty){
                                              showDialog(
                                                context: context, 
                                                builder: (BuildContext context){
                                                  return AlertDialog(
                                                    title: Text('THÔNG BÁO'),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('Tên phòng ban đã tồn tại'),
                                                      ],
                                                    ),
                                                      actions: [  
                                                      TextButton(
                                                        child: Text('OK'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else{
                                                xDepartment.add({
                                                'name': newDepartment.name,
                                                'description': newDepartment.description,
                                                'numberOfEmployees' : newDepartment.numberOfEmployees,
                                              }).then((value) => print("Thêm thành công")).catchError((error) => print("Lỗi: $error"));
                                            }
                                            _selectedDepartment = null;
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
                                        'Are you sure you want to delete this Department?'),
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
                                            xDepartment.doc(snapshot.data!.docs[index].id).delete().then((value) => print("Xóa thành công")).catchError((error)=> print('Lỗi: ${error}'));
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
                            return DepartmentDetailDialog(
                              snapshot.data!.docs[index].id
                            );
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
          } else {
              return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewDepartment,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class DepartmentDetailDialog extends StatelessWidget {
  final String id;
  const DepartmentDetailDialog(this.id);

  @override
  Widget build(BuildContext context) {
    CollectionReference yDepartment = FirebaseFirestore.instance.collection('departments');
    return FutureBuilder<DocumentSnapshot>(
      future: yDepartment.doc(id).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return AlertDialog(
            title: Text('${data['name']}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mô tả: ${data['description']}'),
                  Text('Số lượng người trong phòng: ${data['numberOfEmployees']}'),
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
          return Text("Something went wrong");
        }else{
          return Text("Document does not exist");
        }
      },
    );
  }
}
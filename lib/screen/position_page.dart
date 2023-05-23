import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/position.dart';

class PositionPage extends StatefulWidget {
  @override
  _PositionPageState createState() => _PositionPageState();
}

class _PositionPageState extends State<PositionPage> {
  bool _showDetails = false;
  Position? _selectedPosition;
  CollectionReference xPosition = FirebaseFirestore.instance.collection('positions');

  void _addNewPosition() {
    Position newPosition = Position(
      id: '',
      name: '',
      description: '',
      hourlyRate: 0,
      averageSalary: 0,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Position'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    newPosition.name = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    newPosition.description = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Hourly Rate'),
                  onChanged: (value) {
                    newPosition.hourlyRate = double.parse(value);
                  },
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Average Salary'),
                  onChanged: (value) {
                    newPosition.averageSalary = double.parse(value);
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
                setState(() async{
                   QuerySnapshot existingPosition = await xPosition.where('name', isEqualTo: newPosition.name).get();
                  if(existingPosition.docs.isNotEmpty){
                    showDialog(
                      context: context, 
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text('THÔNG BÁO'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tên chức vụ đã tồn tại'),
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
                      xPosition.add({
                      'name': newPosition.name,
                      'description': newPosition.description,
                      'hourlyRate': newPosition.hourlyRate,
                      'averageSalary': newPosition.averageSalary,
                    }).then((value) => print("Thêm thành công")).catchError((error) => print("Lỗi: $error"));
                    Navigator.of(context).pop();
                  }
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
        title: Text('Positions'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('positions').snapshots(),
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
                                _selectedPosition = Position(
                                  name: snapshot.data!.docs[index].get('name'), 
                                  description: snapshot.data!.docs[index].get('description'), 
                                  hourlyRate: snapshot.data!.docs[index].get('hourlyRate'), 
                                  averageSalary: snapshot.data!.docs[index].get('averageSalary'),
                                );
                              });
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Edit Position'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            decoration:
                                                InputDecoration(labelText: 'Name'),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedPosition!.name = value;
                                              });
                                            },
                                            controller: TextEditingController(
                                                text: _selectedPosition!.name),
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                                labelText: 'Description'),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedPosition!.description =
                                                    value;
                                              });
                                            },
                                            controller: TextEditingController(
                                                text: _selectedPosition!.description),
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                                labelText: 'Hourly Rate'),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedPosition!.hourlyRate =
                                                    value as double;
                                              });
                                            },
                                            controller: TextEditingController(
                                                text: _selectedPosition!.hourlyRate
                                                    .toString()),
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                                labelText: 'Average Salary'),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedPosition!.averageSalary =
                                                    value as double;
                                              });
                                            },
                                            controller: TextEditingController(
                                                text: _selectedPosition!.averageSalary
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
                                            _selectedPosition = null;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Save'),
                                        onPressed: () {
                                          setState(() {
                                            xPosition.doc(snapshot.data!.docs[index].id).update({
                                              'name': _selectedPosition!.name,
                                              'description': _selectedPosition!.description,
                                              'hourlyRate': _selectedPosition!.hourlyRate,
                                              'averageSalary': _selectedPosition!.averageSalary,
                                            }).then((value) => print('Cập nhật thành công')).catchError((error) => print("Lỗi: ${error}"));
                                            _selectedPosition = null;
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
                                        'Are you sure you want to delete this position?'),
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
                                            xPosition.doc(snapshot.data!.docs[index].id).delete().then((value) => print('Xóa thành công')).catchError((error) => print('Lỗi: ${error}'));
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
                            return PositionDetailDialog(snapshot.data!.docs[index].id);
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
        onPressed: _addNewPosition,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class PositionDetailDialog extends StatelessWidget {
  final String id;
  const PositionDetailDialog(this.id);

  @override
  Widget build(BuildContext context) {
    CollectionReference yPosition = FirebaseFirestore.instance.collection('positions');
    return FutureBuilder<DocumentSnapshot>(
      future: yPosition.doc(id).get(),
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
                  Text('Description: ${data['description']}'),
                  Text('Hourly Rate: ${data['hourlyRate']}'),
                  Text('Average Salary: ${data['averageSalary']}'),
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

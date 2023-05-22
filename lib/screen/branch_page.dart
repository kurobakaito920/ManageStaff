import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../models/branch.dart';

class BranchPage extends StatefulWidget {
  @override
  _BranchPageState createState() => _BranchPageState();
}

class _BranchPageState extends State<BranchPage> {
  bool _showDetails = false;
  Branch? _selectedBranch;
  Branch newBranch = Branch(name: '', address: '', phoneNumber: '', email: '');
  CollectionReference xBranch = FirebaseFirestore.instance.collection('branch');
  Future<void> _addNewBranch() async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Branch'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    newBranch.name = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address'),
                  onChanged: (value) {
                    newBranch.address = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  onChanged: (value) {
                    newBranch.phoneNumber = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (value) {
                    newBranch.email = value;
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
                setState(() {
                  xBranch.add({
                    'name': newBranch.name,
                    'address': newBranch.address,
                    'phoneNumber': newBranch.phoneNumber,
                    'email': newBranch.email,  
                  }).then((value) => print("Thêm thành công"))
                  .catchError((error) => print("Lỗi: $error"));
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
        title: Text('Branches'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('branch').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data != null){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index){
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
                                    _selectedBranch = Branch(
                                      name: snapshot.data!.docs[index].get('name'), 
                                      address: snapshot.data!.docs[index].get('address'), 
                                      phoneNumber: snapshot.data!.docs[index].get('phoneNumber'), 
                                      email: snapshot.data!.docs[index].get('email'),
                                    );
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Edit Branch'),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                decoration:
                                                    InputDecoration(labelText: 'Name'),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedBranch!.name = value;
                                                  });
                                                },
                                                controller: TextEditingController(
                                                    text: _selectedBranch!.name),
                                              ),
                                              TextField(
                                                decoration:
                                                    InputDecoration(labelText: 'Address'),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedBranch!.address = value;
                                                  });
                                                },
                                                controller: TextEditingController(
                                                    text: _selectedBranch!.address),
                                              ),
                                              TextField(
                                                decoration: InputDecoration(
                                                    labelText: 'Phone Number'),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedBranch!.phoneNumber = value;
                                                  });
                                                },
                                                controller: TextEditingController(
                                                    text: _selectedBranch!.phoneNumber),
                                              ),
                                              TextField(
                                                decoration:
                                                    InputDecoration(labelText: 'Email'),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedBranch!.email = value;
                                                  });
                                                },
                                                controller: TextEditingController(
                                                    text: _selectedBranch!.email),
                                              ), 
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              setState(() {
                                                _selectedBranch = null;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Save'),
                                            onPressed: () {
                                              setState(() {
                                                xBranch.doc(snapshot.data!.docs[index].id).update({
                                                  'name': _selectedBranch!.name,
                                                  'address': _selectedBranch!.address,
                                                  'phoneNumber': _selectedBranch!.phoneNumber,
                                                  'email': _selectedBranch!.email,
                                                }).then((value) {
                                                  print('Cập nhật thông tin thành công');
                                                }).catchError((error) => print('Lỗi: ${error}'));
                                                _selectedBranch = null;
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
                                            'Are you sure you want to delete this branch?'),
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
                                                xBranch.doc(snapshot.data!.docs[index].id).delete().then((value) => print("Xóa thành công")).catchError((error) => print('Lỗi: ${error}'));
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
                                return BranchDetailDialog(snapshot.data!.docs[index].id);
                              },
                            );
                          },
                        ),
                      ),
                    );
                }
              );
            } else if (snapshot.hasError){
              return const Text('Error');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addNewBranch,
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );     
    }
}

class BranchDetailDialog extends StatelessWidget {
  final String id;
  const BranchDetailDialog(this.id);
  @override
  Widget build(BuildContext context) {
    CollectionReference zBranch = FirebaseFirestore.instance.collection('branch');
    return FutureBuilder<DocumentSnapshot>(
      future: zBranch.doc(id).get(),
      builder:(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return AlertDialog(
            title: Text("${data['name']}"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Address: ${data['address']}'),
                  Text('Phone Number: ${data['phoneNumber']}'),
                  Text('Email: ${data['email']}'),
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
        else if(snapshot.hasError){
          return Text("Something went wrong");
        }
        else{
          return Text("Document does not exist");
        }
      }, 
    );
  }
}

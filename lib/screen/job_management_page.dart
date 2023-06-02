import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/job.dart';
import 'dart:async';

class JobPage extends StatefulWidget {
  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  bool _showDetails = false;
  Job? _selectedJob;
  TextEditingController dateWorkController = TextEditingController(), 
  dateEndController = TextEditingController(),
  timeWorkController = TextEditingController(),
  timeEndController = TextEditingController();
  List<DropdownMenuItem<String>> lstEmployee = [];
  CollectionReference xJob = FirebaseFirestore.instance.collection('jobs');
  Job newJob = Job(
    id: '',
    name: '',
    description: '',
    dateWork: '',
    dateEnd: '',
    startTime: '',
    endTime: '',
    employeeWork: '',
  );

  @override
  void initState() {
    dateWorkController.text = "";
    dateEndController.text = "";
    timeWorkController.text = "";
    timeEndController.text = ""; //set the initial value of text field
    super.initState();
  }
  Future<void> _addNewJob() async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Job'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name'),
                  onChanged: (value) {
                    newJob.name = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    newJob.description = value;
                  },
                ),
                TextField(
                  controller: dateWorkController,
                  decoration: InputDecoration(labelText: 'Start Date'),
                  readOnly: true,
                  onTap: () async{
                    DateTime? pickDate = await showDatePicker(
                      context: context, 
                      initialDate: DateTime.now(), 
                      firstDate: DateTime(2023), 
                      lastDate: DateTime(2099)
                    );
                    if(pickDate != null ){
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickDate); 
                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement
                      setState(() {
                          dateWorkController.text = formattedDate;
                          newJob.dateWork = formattedDate.toString(); //set output date to TextField value. 
                      });
                    }else{
                        print("Date is not selected");
                    }
                  },
                ),
                TextField(
                  controller: dateEndController,
                  decoration: InputDecoration(labelText: 'End Date'),
                  readOnly: true,
                  onTap: () async{
                    DateTime? pickDate = await showDatePicker(
                      context: context, 
                      initialDate: DateTime.now(), 
                      firstDate: DateTime(2023), 
                      lastDate: DateTime(2099)
                    );
                    if(pickDate != null ){
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickDate); 
                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement
                      setState(() {
                          dateEndController.text = formattedDate;
                          newJob.dateEnd = formattedDate; //set output date to TextField value. 
                      });
                    }else{
                        print("Date is not selected");
                    }
                  },
                ),
                TextField(
                  controller: timeWorkController,
                  decoration: InputDecoration(labelText: 'Start Time'),
                  readOnly: true,
                  onTap: () async{
                    TimeOfDay? pickTime = await showTimePicker(
                      context: context, 
                      initialTime: TimeOfDay.now(),
                    );
                    if(pickTime != null ){
                      String formattedTime = pickTime.format(context);
                      print(formattedTime); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement
                      setState(() {
                          timeWorkController.text = formattedTime;
                          newJob.startTime = formattedTime.toString(); //set output date to TextField value. 
                      });
                    }else{
                        print("Time is not selected");
                    }
                  },
                ),
                TextField(
                  controller: timeEndController,
                  decoration: InputDecoration(labelText: 'End Time'),
                  readOnly: true,
                  onTap: () async{
                    TimeOfDay? pickTime = await showTimePicker(
                      context: context, 
                      initialTime: TimeOfDay.now(),
                    );
                    if(pickTime != null ){
                      String formattedTime = pickTime.format(context);
                      print(formattedTime); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement
                      setState(() {
                          timeEndController.text = formattedTime;
                          newJob.endTime = formattedTime; //set output date to TextField value. 
                      });
                    }else{
                        print("Time is not selected");
                    }
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('employees').snapshots(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      return CircularProgressIndicator();
                    } else {
                      final employeeWork = snapshot.data?.docs.reversed.toList();
                      lstEmployee = [];
                      for(var i in employeeWork!) {
                        lstEmployee.add(DropdownMenuItem(
                          value: i.id,
                          child: Text(i['name'],),
                        ));
                      }
                    }
                    String? initalValue = newJob.employeeWork.isNotEmpty ? lstEmployee[0].value : null;
                    return DropdownButtonFormField<String>(
                      items: lstEmployee, 
                      onChanged: (value){
                        setState(() {
                          newJob.employeeWork = value!;
                        });
                      },
                      value: initalValue,
                      isExpanded: false,
                    );
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
              onPressed: (){
                setState(() {
                  xJob.add({
                    'name': newJob.name,
                    'description': newJob.description,
                    'dateWork': newJob.dateWork,
                    'dateEnd': newJob.dateEnd,
                    'startTime': newJob.startTime,
                    'endTime': newJob.endTime,
                    'employeeWork': newJob.employeeWork,
                  }).then((value) => print('Thêm thành công')).catchError((error) => print('Lỗi: ${error}'));
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
        title: Text('Jobs'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
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
                                _selectedJob = Job(
                                  name: snapshot.data!.docs[index].get('name'), 
                                  description: snapshot.data!.docs[index].get('description'), 
                                  dateWork: snapshot.data!.docs[index].get('dateWork'), 
                                  dateEnd: snapshot.data!.docs[index].get('dateEnd'), 
                                  startTime: snapshot.data!.docs[index].get('startTime'), 
                                  endTime: snapshot.data!.docs[index].get('endTime'), 
                                  employeeWork: snapshot.data!.docs[index].get('employeeWork'),
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
                                                _selectedJob!.name = value;
                                              });
                                            },
                                            controller: TextEditingController(
                                                text: _selectedJob!.name),
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                                labelText: 'Description'),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedJob!.description = value;
                                              });
                                            },
                                            controller: TextEditingController(
                                                text: _selectedJob!.description),
                                          ),
                                          TextField(
                                            controller: dateWorkController,
                                            decoration: InputDecoration(labelText: 'Start Date'),
                                            readOnly: true,
                                            onTap: () async{
                                              DateTime? pickDate = await showDatePicker(
                                                context: context, 
                                                initialDate: DateTime.now(), 
                                                firstDate: DateTime(2023), 
                                                lastDate: DateTime(2099)
                                              );
                                              if(pickDate != null ){
                                                String formattedDate = DateFormat('yyyy-MM-dd').format(pickDate); 
                                                print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                                  //you can implement different kind of Date Format here according to your requirement
                                                setState(() {
                                                    dateWorkController.text = formattedDate;
                                                    _selectedJob!.dateWork = formattedDate.toString(); //set output date to TextField value. 
                                                });
                                              }else{
                                                  print("Date is not selected");
                                              }
                                            },
                                          ),
                                          TextField(
                                            controller: dateEndController,
                                            decoration: InputDecoration(labelText: 'End Date'),
                                            readOnly: true,
                                            onTap: () async{
                                              DateTime? pickDate = await showDatePicker(
                                                context: context, 
                                                initialDate: DateTime.now(), 
                                                firstDate: DateTime(2023), 
                                                lastDate: DateTime(2099)
                                              );
                                              if(pickDate != null ){
                                                String formattedDate = DateFormat('yyyy-MM-dd').format(pickDate); 
                                                print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                                  //you can implement different kind of Date Format here according to your requirement
                                                setState(() {
                                                    dateEndController.text = formattedDate;
                                                    _selectedJob!.dateEnd = formattedDate; //set output date to TextField value. 
                                                });
                                              }else{
                                                  print("Date is not selected");
                                              }
                                            },
                                          ),
                                          TextField(
                                            controller: timeWorkController,
                                            decoration: InputDecoration(labelText: 'Start Time'),
                                            readOnly: true,
                                            onTap: () async{
                                              TimeOfDay? pickTime = await showTimePicker(
                                                context: context, 
                                                initialTime: TimeOfDay.now(),
                                              );
                                              if(pickTime != null ){
                                                String formattedTime = pickTime.format(context);
                                                print(formattedTime); //formatted date output using intl package =>  2021-03-16
                                                  //you can implement different kind of Date Format here according to your requirement
                                                setState(() {
                                                    timeWorkController.text = formattedTime;
                                                    _selectedJob!.startTime = formattedTime.toString(); //set output date to TextField value. 
                                                });
                                              }else{
                                                  print("Time is not selected");
                                              }
                                            },
                                          ),
                                          TextField(
                                            controller: timeEndController,
                                            decoration: InputDecoration(labelText: 'End Time'),
                                            readOnly: true,
                                            onTap: () async{
                                              TimeOfDay? pickTime = await showTimePicker(
                                                context: context, 
                                                initialTime: TimeOfDay.now(),
                                              );
                                              if(pickTime != null ){
                                                String formattedTime = pickTime.format(context);
                                                print(formattedTime); //formatted date output using intl package =>  2021-03-16
                                                  //you can implement different kind of Date Format here according to your requirement
                                                setState(() {
                                                    timeEndController.text = formattedTime;
                                                    _selectedJob!.endTime = formattedTime; //set output date to TextField value. 
                                                });
                                              }else{
                                                  print("Time is not selected");
                                              }
                                            },
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance.collection('employees').snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return CircularProgressIndicator();
                                              } else {
                                                final employeeWork = snapshot.data?.docs.reversed.toList();
                                                lstEmployee = [];
                                                for (var i in employeeWork!) {
                                                  lstEmployee.add(DropdownMenuItem(
                                                    value: i.id,
                                                    child: Text(i['name']),
                                                  ));
                                                }
                                              }
                                              String? initialValue = _selectedJob!.employeeWork.isNotEmpty ? lstEmployee[0].value : null;
                                              return DropdownButtonFormField<String>(
                                                items: lstEmployee,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedJob!.employeeWork = value!;
                                                  });
                                                },
                                                value: initialValue,
                                                isExpanded: false,
                                                decoration: InputDecoration(labelText: 'Branch'),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          setState(() {
                                            _selectedJob = null;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Save'),
                                        onPressed: () {
                                          setState(() {
                                            xJob.doc(snapshot.data!.docs[index].id).update({
                                              'name': _selectedJob!.name,
                                              'description': _selectedJob!.description,
                                              'dateWork': _selectedJob!.dateWork,
                                              'dateEnd': _selectedJob!.dateEnd,
                                              'timeStart': _selectedJob!.startTime,
                                              'endTime': _selectedJob!.endTime,
                                              'employeeWord': _selectedJob!.employeeWork,
                                            }).then((value) => print('Cập nhật thành công')).catchError((error) => print('Lỗi: $error'));
                                            _selectedJob = null;
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
                                        'Are you sure you want to delete this job?'),
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
                                            xJob.doc(snapshot.data!.docs[index].id).delete().then((value) => print('Xóa thành công')).catchError((error) => print('Lỗi: $error'));
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
                            return JobDetailDialog(snapshot.data!.docs[index].id);
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewJob,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class JobDetailDialog extends StatelessWidget {
  final String id;
  const JobDetailDialog(this.id);

  @override
  Widget build(BuildContext context) {
    CollectionReference yJob = FirebaseFirestore.instance.collection('jobs');
    return FutureBuilder<DocumentSnapshot>(
      future: yJob.doc(id).get(),
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
                  Text('Start date: ${data['dateWork']}'),
                  Text('End date: ${data['dateEnd']}'),
                  Text('Time start: ${data['startTime']}'),
                  Text('Time end: ${data['endTime']}'),
                  FutureBuilder<DocumentSnapshot<Object?>>(
                    future: FirebaseFirestore.instance.collection('employees').doc(data['employeeWork']).get(),
                    builder:(context, employeeSnapshot) {
                      if(employeeSnapshot.connectionState == ConnectionState.done && employeeSnapshot.hasData){
                        Map<String, dynamic>? employeeData = employeeSnapshot.data!.data() as Map<String, dynamic>?;
                        String employeeName = employeeData?['name'] ?? 'không tìm thấy';
                        return Text('employeeWork: $employeeName');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
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
        } else if (snapshot.hasData){
          return Text('Something went wrong');
        } else {
          return Text('Document does not exits');
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../models/job.dart';
import '../data/data.dart';

class JobPage extends StatefulWidget {
  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  bool _showDetails = false;
  Job? _selectedJob;

  void _addNewJob() {
    Job newJob = Job(
      id: '',
      name: '',
      description: '',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      employeeId: '',
    );

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
                  decoration: InputDecoration(labelText: 'Name'),
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
                TextFormField(
                  decoration: InputDecoration(labelText: 'Start Time'),
                  onChanged: (value) {
                    newJob.startTime = DateTime.parse(value);
                  },
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'End Time'),
                  onChanged: (value) {
                    newJob.endTime = DateTime.parse(value);
                  },
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Employee ID'),
                  onChanged: (value) {
                    newJob.employeeId = value;
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
                  jobs.add(newJob);
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
      body: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              elevation: 4,
              child: ListTile(
                title: Text(jobs[index].name),
                subtitle: _showDetails
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Start Time: ${jobs[index].startTime}'),
                          Text('End Time: ${jobs[index].endTime}'),
                          Text('Employee ID: ${jobs[index].employeeId}'),
                          Text('Description: ${jobs[index].description}'),
                        ],
                      )
                    : null,
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
                          _selectedJob = jobs[index];
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
                                      decoration: InputDecoration(
                                          labelText: 'Start time'),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedJob!.startTime =
                                              value as DateTime;
                                        });
                                      },
                                      controller: TextEditingController(
                                          text: _selectedJob!.startTime
                                              .toString()),
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                          labelText: 'End time'),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedJob!.endTime =
                                              value as DateTime;
                                        });
                                      },
                                      controller: TextEditingController(
                                          text:
                                              _selectedJob!.endTime.toString()),
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
                                      jobs[index] = _selectedJob!;
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
                                      jobs.removeAt(index);
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
                      return JobDetailDialog(job: jobs[index]);
                    },
                  );
                },
              ),
            ),
          );
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
  final Job job;
  const JobDetailDialog({required this.job, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(job.name),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${job.description}'),
            Text('Start Time: ${job.startTime}'),
            Text('End Time: ${job.endTime}'),
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

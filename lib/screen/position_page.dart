import 'package:flutter/material.dart';
import '../data/data.dart';
import '../models/position.dart';

class PositionPage extends StatefulWidget {
  @override
  _PositionPageState createState() => _PositionPageState();
}

class _PositionPageState extends State<PositionPage> {
  bool _showDetails = false;
  Position? _selectedPosition;

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
                setState(() {
                  positions.add(newPosition);
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
      body: ListView.builder(
        itemCount: positions.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              elevation: 4,
              child: ListTile(
                title: Text(positions[index].name),
                subtitle: _showDetails
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hourly Rate: ${positions[index].hourlyRate}'),
                          Text(
                              'Average Salary: ${positions[index].averageSalary}'),
                          Text('Description: ${positions[index].description}'),
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
                          _selectedPosition = positions[index];
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
                                      positions[index] = _selectedPosition!;
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
                                      positions.removeAt(index);
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
                      return PositionDetailDialog(position: positions[index]);
                    },
                  );
                },
              ),
            ),
          );
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
  final Position position;
  const PositionDetailDialog({required this.position, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(position.name),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${position.description}'),
            Text('Hourly Rate: ${position.hourlyRate}'),
            Text('Average Salary: ${position..averageSalary}'),
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

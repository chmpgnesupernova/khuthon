import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  TextEditingController _typeController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  Position? _currentPosition;

  Future<void> _getLocation() async {
    _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Submit Report')),
      body: Column(
        children: [
          TextField(controller: _typeController, decoration: InputDecoration(labelText: 'Pest Type')),
          TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description')),
          ElevatedButton(onPressed: _getLocation, child: Text('Get Location')),
        ],
      ),
    );
  }
}

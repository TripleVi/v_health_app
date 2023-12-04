import 'package:flutter/material.dart';

class Activity {
  final int _id;
  final String _name;
  final IconData _icon;
  final String _description;

  Activity(int id, String name, IconData icon, {String description = ""}) 
      : _id = id, _name = name, _icon = icon, _description = description, 
        assert(id >= 0 || id == -1),
        assert(name.isNotEmpty);
  
  Activity.empty() : this(-1, "", Icons.image);

  int get id => _id;
  String get name => _name;
  IconData get icon => _icon;
  String get description => _description;

  @override
  String toString() {
    return "{id: $_id, name: $_name, icon: $_icon, description: $_description}";
  }
}
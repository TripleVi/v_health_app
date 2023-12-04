import 'package:uuid/uuid.dart';

class BaseEntity {
  final String _id;

  BaseEntity({String? id}) : _id = id ?? const Uuid().v4();

  String get id => _id;
}
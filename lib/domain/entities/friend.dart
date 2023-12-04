class Friend {
  late String _id;
  late String _firstName;
  late String _lastName;
  late String _avatar;

  Friend({required String id, required String firstName, required String lastName, required String avatar}) {
    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.avatar = avatar;
  }

  Friend.empty() : this(
    id: "id",
    firstName: "John",
    lastName: "Doe",
    avatar: "avatar",
  );

  String get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get avatar => _avatar;

  set id(String id) {
    assert(id.isNotEmpty);
    _id = id;
  }

  set firstName(String firstName) {
    assert(firstName.isNotEmpty);
    _firstName = firstName;
  }

  set lastName(String lastName) {
    assert(lastName.isNotEmpty);
    _lastName = firstName;
  }

  set avatar(String avatar) {
    assert(avatar.isNotEmpty);
    _avatar = firstName;
  }

  @override
  String toString() {
    return "{id: $_id, firstName: $_firstName, lastName: $_lastName, avatar: $_avatar}";
  }
}
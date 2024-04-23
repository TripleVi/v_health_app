enum UserGender {
  male, 
  female,
}

extension UserGenderExtension on UserGender {
  bool get isMale => this == UserGender.male;
  bool get isFemale => this == UserGender.female;

  String get stringValue {
    switch (this) {
      case UserGender.male:
        return "Male";
      case UserGender.female:
      default:
        return "Female";
    }
  }
}
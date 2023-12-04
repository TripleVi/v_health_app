enum UserGender {
  male, 
  female, 
  other,
}

extension UserGenderExtension on UserGender {
  bool get isMale => this == UserGender.male;
  bool get isFemale => this == UserGender.female;
  bool get isOther => this == UserGender.other;

  String get stringValue {
    switch (this) {
      case UserGender.male:
        return "Male";
      case UserGender.female:
        return "Female";
      case UserGender.other:
      default:
        return "Other";
    }
  }
}
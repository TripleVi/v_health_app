class ClassifiedMotion {
  int timeFrame;
  int type;

  ClassifiedMotion(this.timeFrame, this.type);

  @override
  String toString() {
    return "{timeFrame: $timeFrame, type: $type}";
  }
}
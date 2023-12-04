// enum ChallengeType {groupGoal, individualGoal, running, cycling, unknown}

// extension TrackingStatusExtension on TrackingStatus {
//   bool get isInitial => this == TrackingStatus.initial;
//   bool get isStarted => this == TrackingStatus.started;
//   bool get isPaused => this == TrackingStatus.paused;
// }

// extension TrackingTargetExtension on TrackingTarget {
//   bool get isDistance => this == TrackingTarget.distance;
//   bool get isDuration => this == TrackingTarget.duration;
//   bool get isCalories => this == TrackingTarget.calories;
//   bool get isNotTargeted => this == TrackingTarget.noTarget;

//   String get stringValue {
//     switch (this) {
//       case TrackingTarget.distance:
//         return "Distance target";
//       case TrackingTarget.duration:
//         return "Duration target";
//       case TrackingTarget.calories:
//         return "Calories target";
//       case TrackingTarget.noTarget:
//         return "No target";
//       default:
//         return "";
//     }
//   }
// }
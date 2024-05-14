// ignore_for_file: constant_identifier_names

class HourlyReportFields {
  static const container = "hourly_report";

  static const id = "id";
  static const hour = "hour";
  static const steps = "steps";
  static const distance = "distance";
  static const activeTime = "active_time";
  static const calories = "calories";
  static const dayId = "day_id";

  HourlyReportFields._();
}

class DailyReportFields {
  static const container = "daily_report";

  static const id = "id";
  static const date = "date";
  static const steps = "steps";
  static const distance = "distance";
  static const activeTime = "active_time";
  static const calories = "calories";
  static const goalId = "goal_id";

  DailyReportFields._();
}

class AccelDataFields {
  static const ID = 'id';
  static const X = 'x';
  static const Y = 'y';
  static const Z = 'z';
  static const T = 't';
  static const Hour = 'hour';
  static const Quarter = 'quarter';
  static const Activity = 'activity';
  static const Date = 'date';

  static const table = 'accel_data_table';

  AccelDataFields._();
}

class NotificationFields {
  static const container = 'notifications';

  static const id = "notificationId";
  static const type = "type";
  static const sender = "fromUser";
  static const receiver = "toUser";
  static const dateTime = "dateTime";
  static const code = "code";
  static const status = "status";
  static const content = "content";
  static const imageUrl = "imageUrl";
  static const isChecked = "isChecked";

  NotificationFields._();
}

class DailyGoalFields {
  static const container = "daily_goal";

  static const id = "id";
  static const steps = "steps";
  static const calories = "calories";
  static const minutes = "minutes";

  DailyGoalFields._();
}

class ActivityRecordFields {
  static const container = "activity_record";

  static const id = "record_id";
  static const startDate = "start_date";
  static const endDate = "end_date";
  static const workoutDuration = "workout_duration";
  static const distance = "distance";
  static const avgSpeed = "avg_speed";
  static const maxSpeed = "max_speed";
  static const avgPace = "avg_pace";
  static const maxPace = "max_pace";
  static const steps = "steps";
  static const stairsClimbed = "stairs_climbed";
  static const workoutCalories = "workout_calories";
  static const totalCalories = "total_calories";
  static const mapName = "map_name";

  ActivityRecordFields._();
}

class CoordinateFields {
  static const container = "coordinates";

  static const id = "id";
  static const latitude = "latitude";
  static const longitude = "longitude";
  static const timeFrame = "time_frame";
  static const activityType = "activity_type";
  static const recordId = "record_id";

  CoordinateFields._();
}

class PhotoFields {
  static const container = "images";

  static const id = "id";
  static const name = "name";
  static const date = "date";
  static const latitude = "latitude";
  static const longitude = "longitude";
  static const recordId = "record_id";

  PhotoFields._();
}

class PostFields {
  static const container = "post";

  static const id = "post_id";
  static const title = "title";
  static const content = "content";
  static const privacy = "privacy";
  static const createdDate = "created_date";
  static const recordId = "record_id";

  PostFields._();
}

class ReactionFields {
  static const container = "post";

  static const id = "post_id";
  static const title = "title";
  static const content = "content";
  static const privacy = "privacy";
  static const createdDate = "created_date";
  static const recordId = "record_id";

  ReactionFields._();
}

class WorkoutSessionFields {
  static const container = "workout_session";

  static const id = "session_id";
  static const distance = "distance";
  static const speed = "speed";
  static const pace = "pace";
  static const timeFrame = "time_frame";

  WorkoutSessionFields._();
}

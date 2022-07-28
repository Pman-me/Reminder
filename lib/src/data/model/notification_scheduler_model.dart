import 'package:objectbox/objectbox.dart';

@Entity()
@Unique(onConflict: ConflictStrategy.replace)
class NotificationSchedulerModel{
  @Id(assignable: true)
  int id;
  List<String> dateTimesMillisecondsSinceEpoch;
  @Property(type: PropertyType.date)
  DateTime startDateTime;
  @Property(type: PropertyType.date)
  DateTime endDateTime;
  bool isActive;
  String notificationTitle;

  NotificationSchedulerModel(
      {required this.id,
      required this.dateTimesMillisecondsSinceEpoch,
      required this.startDateTime,
      required this.endDateTime,this.isActive = true,required this.notificationTitle});

}

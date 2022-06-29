import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
@Unique(onConflict: ConflictStrategy.replace)
class NotificationSchedulerModel extends Equatable{
  @Id(assignable: true)
  int id;
  List<String> dateTimesMillisecondsSinceEpoch;
  @Property(type: PropertyType.date)
  DateTime startDateTime;
  @Property(type: PropertyType.date)
  DateTime endDateTime;
  bool isActive;

  NotificationSchedulerModel(
      {required this.id,
      required this.dateTimesMillisecondsSinceEpoch,
      required this.startDateTime,
      required this.endDateTime,this.isActive = true});

  @override
  List<Object?> get props =>[isActive];
}

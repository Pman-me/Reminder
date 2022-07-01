import 'package:objectbox/objectbox.dart';

import '../../data/local/objectbox.g.dart';
import '../model/notification_scheduler_model.dart';

class ObjectBoxHelper {
  Store? _store;
  Box<NotificationSchedulerModel>? _timeBox;
  static ObjectBoxHelper? _instance;

  ObjectBoxHelper._();

  factory ObjectBoxHelper() {
      _instance ??= ObjectBoxHelper._();
    return _instance!;
  }

  Future init() async {
    if (_store == null) {
      _store = await openStore();
      _timeBox = Box<NotificationSchedulerModel>(_store!);
    }
  }

  NotificationSchedulerModel? getDateAndTime(int id) => _timeBox!.get(id);

  List<NotificationSchedulerModel> getDateAndTimes() => _timeBox!.getAll();

  int put(NotificationSchedulerModel time) => _timeBox!.put(time);

  bool deleteTime(int id) => _timeBox!.remove(id);

  void close() {
    if (_store != null && !_store!.isClosed()) {
      _store!.close();
      _store =null;
    }
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_sync_flutter_libs/objectbox_sync_flutter_libs.dart';

import '../model/notification_scheduler_model.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 4100287068943610296),
      name: 'NotificationSchedulerModel',
      lastPropertyId: const IdUid(6, 1504571030042902130),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8007190088819872691),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 633035468634449753),
            name: 'dateTimesMillisecondsSinceEpoch',
            type: 30,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1270743198945595186),
            name: 'startDateTime',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 352783742265620980),
            name: 'endDateTime',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 5583523746119259944),
            name: 'isActive',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 1504571030042902130),
            name: 'notificationTitle',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(1, 4100287068943610296),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    NotificationSchedulerModel: EntityDefinition<NotificationSchedulerModel>(
        model: _entities[0],
        toOneRelations: (NotificationSchedulerModel object) => [],
        toManyRelations: (NotificationSchedulerModel object) => {},
        getId: (NotificationSchedulerModel object) => object.id,
        setId: (NotificationSchedulerModel object, int id) {
          object.id = id;
        },
        objectToFB: (NotificationSchedulerModel object, fb.Builder fbb) {
          final dateTimesMillisecondsSinceEpochOffset = fbb.writeList(object
              .dateTimesMillisecondsSinceEpoch
              .map(fbb.writeString)
              .toList(growable: false));
          final notificationTitleOffset =
              fbb.writeString(object.notificationTitle);
          fbb.startTable(7);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, dateTimesMillisecondsSinceEpochOffset);
          fbb.addInt64(2, object.startDateTime.millisecondsSinceEpoch);
          fbb.addInt64(3, object.endDateTime.millisecondsSinceEpoch);
          fbb.addBool(4, object.isActive);
          fbb.addOffset(5, notificationTitleOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = NotificationSchedulerModel(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              dateTimesMillisecondsSinceEpoch: const fb.ListReader<String>(
                      fb.StringReader(asciiOptimization: true),
                      lazy: false)
                  .vTableGet(buffer, rootOffset, 6, []),
              startDateTime: DateTime.fromMillisecondsSinceEpoch(
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0)),
              endDateTime: DateTime.fromMillisecondsSinceEpoch(
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0)),
              isActive: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 12, false),
              notificationTitle: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 14, ''));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [NotificationSchedulerModel] entity fields to define ObjectBox queries.
class NotificationSchedulerModel_ {
  /// see [NotificationSchedulerModel.id]
  static final id = QueryIntegerProperty<NotificationSchedulerModel>(
      _entities[0].properties[0]);

  /// see [NotificationSchedulerModel.dateTimesMillisecondsSinceEpoch]
  static final dateTimesMillisecondsSinceEpoch =
      QueryStringVectorProperty<NotificationSchedulerModel>(
          _entities[0].properties[1]);

  /// see [NotificationSchedulerModel.startDateTime]
  static final startDateTime = QueryIntegerProperty<NotificationSchedulerModel>(
      _entities[0].properties[2]);

  /// see [NotificationSchedulerModel.endDateTime]
  static final endDateTime = QueryIntegerProperty<NotificationSchedulerModel>(
      _entities[0].properties[3]);

  /// see [NotificationSchedulerModel.isActive]
  static final isActive = QueryBooleanProperty<NotificationSchedulerModel>(
      _entities[0].properties[4]);

  /// see [NotificationSchedulerModel.notificationTitle]
  static final notificationTitle =
      QueryStringProperty<NotificationSchedulerModel>(
          _entities[0].properties[5]);
}

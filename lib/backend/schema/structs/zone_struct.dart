// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Zone - Add/Update Records
class ZoneStruct extends BaseStruct {
  ZoneStruct({
    String? zoneNumber,
    String? zoneName,
    String? aspect,
    String? exposureToWind,
    String? shade,
  })  : _zoneNumber = zoneNumber,
        _zoneName = zoneName,
        _aspect = aspect,
        _exposureToWind = exposureToWind,
        _shade = shade;

  // "ZoneNumber" field.
  String? _zoneNumber;
  String get zoneNumber => _zoneNumber ?? '';
  set zoneNumber(String? val) => _zoneNumber = val;

  bool hasZoneNumber() => _zoneNumber != null;

  // "ZoneName" field.
  String? _zoneName;
  String get zoneName => _zoneName ?? '';
  set zoneName(String? val) => _zoneName = val;

  bool hasZoneName() => _zoneName != null;

  // "Aspect" field.
  String? _aspect;
  String get aspect => _aspect ?? '';
  set aspect(String? val) => _aspect = val;

  bool hasAspect() => _aspect != null;

  // "ExposureToWind" field.
  String? _exposureToWind;
  String get exposureToWind => _exposureToWind ?? '';
  set exposureToWind(String? val) => _exposureToWind = val;

  bool hasExposureToWind() => _exposureToWind != null;

  // "Shade" field.
  String? _shade;
  String get shade => _shade ?? '';
  set shade(String? val) => _shade = val;

  bool hasShade() => _shade != null;

  static ZoneStruct fromMap(Map<String, dynamic> data) => ZoneStruct(
        zoneNumber: data['ZoneNumber'] as String?,
        zoneName: data['ZoneName'] as String?,
        aspect: data['Aspect'] as String?,
        exposureToWind: data['ExposureToWind'] as String?,
        shade: data['Shade'] as String?,
      );

  static ZoneStruct? maybeFromMap(dynamic data) =>
      data is Map ? ZoneStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'ZoneNumber': _zoneNumber,
        'ZoneName': _zoneName,
        'Aspect': _aspect,
        'ExposureToWind': _exposureToWind,
        'Shade': _shade,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'ZoneNumber': serializeParam(
          _zoneNumber,
          ParamType.String,
        ),
        'ZoneName': serializeParam(
          _zoneName,
          ParamType.String,
        ),
        'Aspect': serializeParam(
          _aspect,
          ParamType.String,
        ),
        'ExposureToWind': serializeParam(
          _exposureToWind,
          ParamType.String,
        ),
        'Shade': serializeParam(
          _shade,
          ParamType.String,
        ),
      }.withoutNulls;

  static ZoneStruct fromSerializableMap(Map<String, dynamic> data) =>
      ZoneStruct(
        zoneNumber: deserializeParam(
          data['ZoneNumber'],
          ParamType.String,
          false,
        ),
        zoneName: deserializeParam(
          data['ZoneName'],
          ParamType.String,
          false,
        ),
        aspect: deserializeParam(
          data['Aspect'],
          ParamType.String,
          false,
        ),
        exposureToWind: deserializeParam(
          data['ExposureToWind'],
          ParamType.String,
          false,
        ),
        shade: deserializeParam(
          data['Shade'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ZoneStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ZoneStruct &&
        zoneNumber == other.zoneNumber &&
        zoneName == other.zoneName &&
        aspect == other.aspect &&
        exposureToWind == other.exposureToWind &&
        shade == other.shade;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([zoneNumber, zoneName, aspect, exposureToWind, shade]);
}

ZoneStruct createZoneStruct({
  String? zoneNumber,
  String? zoneName,
  String? aspect,
  String? exposureToWind,
  String? shade,
}) =>
    ZoneStruct(
      zoneNumber: zoneNumber,
      zoneName: zoneName,
      aspect: aspect,
      exposureToWind: exposureToWind,
      shade: shade,
    );

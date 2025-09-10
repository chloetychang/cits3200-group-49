// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ZonesStruct extends BaseStruct {
  ZonesStruct({
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

  // "zoneNumber" field.
  String? _zoneNumber;
  String get zoneNumber => _zoneNumber ?? '';
  set zoneNumber(String? val) => _zoneNumber = val;

  bool hasZoneNumber() => _zoneNumber != null;

  // "zoneName" field.
  String? _zoneName;
  String get zoneName => _zoneName ?? '';
  set zoneName(String? val) => _zoneName = val;

  bool hasZoneName() => _zoneName != null;

  // "aspect" field.
  String? _aspect;
  String get aspect => _aspect ?? '';
  set aspect(String? val) => _aspect = val;

  bool hasAspect() => _aspect != null;

  // "exposureToWind" field.
  String? _exposureToWind;
  String get exposureToWind => _exposureToWind ?? '';
  set exposureToWind(String? val) => _exposureToWind = val;

  bool hasExposureToWind() => _exposureToWind != null;

  // "shade" field.
  String? _shade;
  String get shade => _shade ?? '';
  set shade(String? val) => _shade = val;

  bool hasShade() => _shade != null;

  static ZonesStruct fromMap(Map<String, dynamic> data) => ZonesStruct(
        zoneNumber: data['zoneNumber'] as String?,
        zoneName: data['zoneName'] as String?,
        aspect: data['aspect'] as String?,
        exposureToWind: data['exposureToWind'] as String?,
        shade: data['shade'] as String?,
      );

  static ZonesStruct? maybeFromMap(dynamic data) =>
      data is Map ? ZonesStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'zoneNumber': _zoneNumber,
        'zoneName': _zoneName,
        'aspect': _aspect,
        'exposureToWind': _exposureToWind,
        'shade': _shade,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'zoneNumber': serializeParam(
          _zoneNumber,
          ParamType.String,
        ),
        'zoneName': serializeParam(
          _zoneName,
          ParamType.String,
        ),
        'aspect': serializeParam(
          _aspect,
          ParamType.String,
        ),
        'exposureToWind': serializeParam(
          _exposureToWind,
          ParamType.String,
        ),
        'shade': serializeParam(
          _shade,
          ParamType.String,
        ),
      }.withoutNulls;

  static ZonesStruct fromSerializableMap(Map<String, dynamic> data) =>
      ZonesStruct(
        zoneNumber: deserializeParam(
          data['zoneNumber'],
          ParamType.String,
          false,
        ),
        zoneName: deserializeParam(
          data['zoneName'],
          ParamType.String,
          false,
        ),
        aspect: deserializeParam(
          data['aspect'],
          ParamType.String,
          false,
        ),
        exposureToWind: deserializeParam(
          data['exposureToWind'],
          ParamType.String,
          false,
        ),
        shade: deserializeParam(
          data['shade'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ZonesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ZonesStruct &&
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

ZonesStruct createZonesStruct({
  String? zoneNumber,
  String? zoneName,
  String? aspect,
  String? exposureToWind,
  String? shade,
}) =>
    ZonesStruct(
      zoneNumber: zoneNumber,
      zoneName: zoneName,
      aspect: aspect,
      exposureToWind: exposureToWind,
      shade: shade,
    );

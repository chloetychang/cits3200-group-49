// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SubZonesStruct extends BaseStruct {
  SubZonesStruct({
    String? subZoneCode,
    String? zone,
    String? aspect,
    String? exposureToWind,
    String? shade,
  })  : _subZoneCode = subZoneCode,
        _zone = zone,
        _aspect = aspect,
        _exposureToWind = exposureToWind,
        _shade = shade;

  // "subZoneCode" field.
  String? _subZoneCode;
  String get subZoneCode => _subZoneCode ?? '';
  set subZoneCode(String? val) => _subZoneCode = val;

  bool hasSubZoneCode() => _subZoneCode != null;

  // "zone" field.
  String? _zone;
  String get zone => _zone ?? '';
  set zone(String? val) => _zone = val;

  bool hasZone() => _zone != null;

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

  static SubZonesStruct fromMap(Map<String, dynamic> data) => SubZonesStruct(
        subZoneCode: data['subZoneCode'] as String?,
        zone: data['zone'] as String?,
        aspect: data['aspect'] as String?,
        exposureToWind: data['exposureToWind'] as String?,
        shade: data['shade'] as String?,
      );

  static SubZonesStruct? maybeFromMap(dynamic data) =>
      data is Map ? SubZonesStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'subZoneCode': _subZoneCode,
        'zone': _zone,
        'aspect': _aspect,
        'exposureToWind': _exposureToWind,
        'shade': _shade,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'subZoneCode': serializeParam(
          _subZoneCode,
          ParamType.String,
        ),
        'zone': serializeParam(
          _zone,
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

  static SubZonesStruct fromSerializableMap(Map<String, dynamic> data) =>
      SubZonesStruct(
        subZoneCode: deserializeParam(
          data['subZoneCode'],
          ParamType.String,
          false,
        ),
        zone: deserializeParam(
          data['zone'],
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
  String toString() => 'SubZonesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SubZonesStruct &&
        subZoneCode == other.subZoneCode &&
        zone == other.zone &&
        aspect == other.aspect &&
        exposureToWind == other.exposureToWind &&
        shade == other.shade;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([subZoneCode, zone, aspect, exposureToWind, shade]);
}

SubZonesStruct createSubZonesStruct({
  String? subZoneCode,
  String? zone,
  String? aspect,
  String? exposureToWind,
  String? shade,
}) =>
    SubZonesStruct(
      subZoneCode: subZoneCode,
      zone: zone,
      aspect: aspect,
      exposureToWind: exposureToWind,
      shade: shade,
    );

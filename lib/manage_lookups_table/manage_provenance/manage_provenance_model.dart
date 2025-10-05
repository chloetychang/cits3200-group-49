import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'manage_provenance_widget.dart' show ManageProvenanceWidget;

class ManageProvenanceModel extends FlutterFlowModel<ManageProvenanceWidget> {
  /// State for provenance table
  final provenanceTableController =
      FlutterFlowDataTableController<ProvenanceRow>();
  List<ProvenanceRow> provenanceRows = [];
  List<LocationTypeRow> locationTypes = [];
  bool isLoading = false;
  String? errorMessage;

  /// State for location types dropdown
  bool isLoadingLocationTypes = false;
  String? locationTypeError;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    provenanceTableController.dispose();
  }
}

// ---------- Data model for provenance ----------
class ProvenanceRow {
  final int id;
  String location;
  String? bioregionCode;
  String? extraDetails;
  int? locationTypeId;   
  String? locationType;  
  ProvenanceRow({
    required this.id,
    required this.location,
    this.bioregionCode,
    this.extraDetails,
    this.locationTypeId,
    this.locationType,
  });

  factory ProvenanceRow.fromJson(Map<String, dynamic> json) {
    return ProvenanceRow(
      id: json['provenance_id'] as int,
      location: (json['location'] ?? '').toString(),
      bioregionCode: json['bioregion_code']?.toString(),
      extraDetails: json['extra_details']?.toString(),
      locationTypeId: json['location_type_id'] as int?,
      locationType: json['location_type']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "provenance_id": id,
        "location": location,
        "bioregion_code": bioregionCode,
        "extra_details": extraDetails,
        "location_type_id": locationTypeId,
      };
}

// ---------- Data model for location_type (dropdown) ----------
class LocationTypeRow {
  final int id;
  final String locationType;

  LocationTypeRow({
    required this.id,
    required this.locationType,
  });

  factory LocationTypeRow.fromJson(Map<String, dynamic> json) {
    return LocationTypeRow(
      id: json['location_type_id'] as int,
      locationType: (json['location_type'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'location_type_id': id,
        'location_type': locationType,
      };
}

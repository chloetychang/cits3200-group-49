import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import '/backend/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'manage_provenance_model.dart';
export 'manage_provenance_model.dart';

class ManageProvenanceWidget extends StatefulWidget {
  const ManageProvenanceWidget({super.key});

  static String routeName = 'ManageProvenance';
  static String routePath = '/manageProvenance';

  @override
  State<ManageProvenanceWidget> createState() => _ManageProvenanceWidgetState();
}

class _ManageProvenanceWidgetState extends State<ManageProvenanceWidget> {
  late ManageProvenanceModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // controllers
  final Map<int, TextEditingController> _locationCtrls = {};
  final Map<int, TextEditingController> _bioregionCtrls = {};
  final Map<int, TextEditingController> _extraCtrls = {};
  final Map<int, int?> _locationTypeIds = {}; // 下拉的外键

  final TextEditingController _newLocationCtrl = TextEditingController();
  final TextEditingController _newBioregionCtrl = TextEditingController();
  final TextEditingController _newExtraCtrl = TextEditingController();
  int? _newLocationTypeId;

  final Set<int> _dirtyIds = <int>{};
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ManageProvenanceModel());
    _load();
  }

  @override
  void dispose() {
    for (final c in _locationCtrls.values) c.dispose();
    for (final c in _bioregionCtrls.values) c.dispose();
    for (final c in _extraCtrls.values) c.dispose();
    _newLocationCtrl.dispose();
    _newBioregionCtrl.dispose();
    _newExtraCtrl.dispose();
    _model.dispose();
    super.dispose();
  }

Future<void> _load() async {
  setState(() => _loading = true);
  try {
    final list = await ApiService.getProvenances();
    _model.provenanceRows = list
        .map((e) => ProvenanceRow.fromJson(e as Map<String, dynamic>))
        .toList();

    _model.locationTypes = await ApiService.getLocationTypes();

    for (final r in _model.provenanceRows) {
      _locationCtrls.putIfAbsent(r.id, () => TextEditingController(text: r.location));
      _bioregionCtrls.putIfAbsent(r.id, () => TextEditingController(text: r.bioregionCode ?? ''));
      _extraCtrls.putIfAbsent(r.id, () => TextEditingController(text: r.extraDetails ?? ''));
      _locationTypeIds[r.id] = r.locationTypeId;
    }
  } finally {
    if (mounted) setState(() => _loading = false);
  }
}


  void _markDirty(int id) {
    if (id != -1) _dirtyIds.add(id);
  }

  Future<void> _onCancel() async {
    await _load();
    _newLocationCtrl.clear();
    _newBioregionCtrl.clear();
    _newExtraCtrl.clear();
    _newLocationTypeId = null;
    _dirtyIds.clear();
  }

  Future<void> _onSave() async {
    try {
      // 新增
      final newLocation = _newLocationCtrl.text.trim();
      if (newLocation.isNotEmpty) {
        await ApiService.createProvenance(
          location: newLocation,
          bioregionCode: _newBioregionCtrl.text.trim(),
          extraDetails: _newExtraCtrl.text.trim(),
          locationTypeId: _newLocationTypeId,
        );
        _newLocationCtrl.clear();
        _newBioregionCtrl.clear();
        _newExtraCtrl.clear();
        _newLocationTypeId = null;
      }

      // 更新
      for (final id in _dirtyIds) {
        await ApiService.updateProvenance(
        id: id,
        location: _locationCtrls[id]?.text ?? '',
        bioregionCode: _bioregionCtrls[id]?.text.isNotEmpty == true 
            ? _bioregionCtrls[id]!.text 
            : null,
        extraDetails: _extraCtrls[id]?.text.isNotEmpty == true 
            ? _extraCtrls[id]!.text 
            : null,
        locationTypeId: _locationTypeIds[id],
        );
      }
      _dirtyIds.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved")));
      }
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Save failed: $e")));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        body: SafeArea(
          top: true,
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 7,
                          child: FFButtonWidget(
                            onPressed: () async {
                              context
                                  .pushNamed(LandingASuperuserWidget.routeName);
                            },
                            text: 'Menu',
                            options: FFButtonOptions(
                              width: 100.0,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xF0B2DDB2),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleSmallFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: () {
                                      if (MediaQuery.sizeOf(context).width <
                                          kBreakpointSmall) {
                                        return 12.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointMedium) {
                                        return 14.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointLarge) {
                                        return 14.0;
                                      } else {
                                        return 16.0;
                                      }
                                    }(),
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleSmallIsCustom,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 10,
                          child: FFButtonWidget(
                            onPressed: () async {
                              context.pushNamed(
                                ManageConservationStatusWidget.routeName,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                    duration: Duration(milliseconds: 0),
                                  ),
                                },
                              );
                            },
                            text: 'Conservation Status',
                            options: FFButtonOptions(
                              width: 160.0,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFFF0F0F0),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleSmallFamily,
                                    color: Colors.black,
                                    fontSize: () {
                                      if (MediaQuery.sizeOf(context).width <
                                          kBreakpointSmall) {
                                        return 12.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointMedium) {
                                        return 14.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointLarge) {
                                        return 14.0;
                                      } else {
                                        return 16.0;
                                      }
                                    }(),
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleSmallIsCustom,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 10,
                          child: FFButtonWidget(
                            onPressed: () async {
                              context.pushNamed(
                                  ManageContainerTypeWidget.routeName);
                            },
                            text: 'Container types',
                            options: FFButtonOptions(
                              width: 160.0,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFFF0F0F0),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleSmallFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: () {
                                      if (MediaQuery.sizeOf(context).width <
                                          kBreakpointSmall) {
                                        return 12.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointMedium) {
                                        return 14.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointLarge) {
                                        return 14.0;
                                      } else {
                                        return 16.0;
                                      }
                                    }(),
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleSmallIsCustom,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 10,
                          child: FFButtonWidget(
                            onPressed: () async {
                              context.pushNamed(
                                ManagePlantUtilityWidget.routeName,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                    duration: Duration(milliseconds: 0),
                                  ),
                                },
                              );
                            },
                            text: 'Plant utility',
                            options: FFButtonOptions(
                              width: 160.0,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFFF0F0F0),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleSmallFamily,
                                    color: Colors.black,
                                    fontSize: () {
                                      if (MediaQuery.sizeOf(context).width <
                                          kBreakpointSmall) {
                                        return 12.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointMedium) {
                                        return 14.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointLarge) {
                                        return 14.0;
                                      } else {
                                        return 16.0;
                                      }
                                    }(),
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleSmallIsCustom,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 10,
                          child: FFButtonWidget(
                            onPressed: () async {
                              context.pushNamed(
                                ManagePlantingRemovalWidget.routeName,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                    duration: Duration(milliseconds: 0),
                                  ),
                                },
                              );
                            },
                            text: 'Planting removal causes',
                            options: FFButtonOptions(
                              width: 160.0,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFFF0F0F0),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleSmallFamily,
                                    color: Colors.black,
                                    fontSize: () {
                                      if (MediaQuery.sizeOf(context).width <
                                          kBreakpointSmall) {
                                        return 12.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointMedium) {
                                        return 14.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointLarge) {
                                        return 14.0;
                                      } else {
                                        return 16.0;
                                      }
                                    }(),
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleSmallIsCustom,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 10,
                          child: FFButtonWidget(
                            onPressed: () {
                              print('Button pressed ...');
                            },
                            text: 'Provenance',
                            options: FFButtonOptions(
                              width: 160.0,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFFF0F0F0),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleSmallFamily,
                                    color: Color(0xFFFF0000),
                                    fontSize: () {
                                      if (MediaQuery.sizeOf(context).width <
                                          kBreakpointSmall) {
                                        return 12.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointMedium) {
                                        return 14.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointLarge) {
                                        return 14.0;
                                      } else {
                                        return 16.0;
                                      }
                                    }(),
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleSmallIsCustom,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 10,
                          child: FFButtonWidget(
                            onPressed: () async {
                              context.pushNamed(
                                ManageProvenanceLocationTypesWidget.routeName,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                    duration: Duration(milliseconds: 0),
                                  ),
                                },
                              );
                            },
                            text: 'Provenance location type',
                            options: FFButtonOptions(
                              width: 160.0,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFFF0F0F0),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleSmallFamily,
                                    color: Colors.black,
                                    fontSize: () {
                                      if (MediaQuery.sizeOf(context).width <
                                          kBreakpointSmall) {
                                        return 12.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointMedium) {
                                        return 14.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointLarge) {
                                        return 14.0;
                                      } else {
                                        return 16.0;
                                      }
                                    }(),
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleSmallIsCustom,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 10,
                          child: FFButtonWidget(
                            onPressed: () async {
                              context.pushNamed(
                                ManagePropagationTypeWidget.routeName,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                    duration: Duration(milliseconds: 0),
                                  ),
                                },
                              );
                            },
                            text: 'Propagation type',
                            options: FFButtonOptions(
                              width: 160.0,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFFF0F0F0),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleSmallFamily,
                                    color: Colors.black,
                                    fontSize: () {
                                      if (MediaQuery.sizeOf(context).width <
                                          kBreakpointSmall) {
                                        return 12.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointMedium) {
                                        return 14.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointLarge) {
                                        return 14.0;
                                      } else {
                                        return 16.0;
                                      }
                                    }(),
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleSmallIsCustom,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 10,
                          child: FFButtonWidget(
                            onPressed: () async {
                              context.pushNamed(
                                ManageSpeciesUtilityWidget.routeName,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                    duration: Duration(milliseconds: 0),
                                  ),
                                },
                              );
                            },
                            text: 'Species/Utility',
                            options: FFButtonOptions(
                              width: 160.0,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFFF0F0F0),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleSmallFamily,
                                    color: Colors.black,
                                    fontSize: () {
                                      if (MediaQuery.sizeOf(context).width <
                                          kBreakpointSmall) {
                                        return 12.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointMedium) {
                                        return 14.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointLarge) {
                                        return 14.0;
                                      } else {
                                        return 16.0;
                                      }
                                    }(),
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleSmallIsCustom,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 10,
                          child: FFButtonWidget(
                            onPressed: () async {
                              context.pushNamed(
                                ManageZoneAspectWidget.routeName,
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: TransitionInfo(
                                    hasTransition: true,
                                    transitionType: PageTransitionType.fade,
                                    duration: Duration(milliseconds: 0),
                                  ),
                                },
                              );
                            },
                            text: 'Zone aspect',
                            options: FFButtonOptions(
                              width: 160.0,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFFF0F0F0),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleSmallFamily,
                                    color: Colors.black,
                                    fontSize: () {
                                      if (MediaQuery.sizeOf(context).width <
                                          kBreakpointSmall) {
                                        return 12.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointMedium) {
                                        return 14.0;
                                      } else if (MediaQuery.sizeOf(context)
                                              .width <
                                          kBreakpointLarge) {
                                        return 14.0;
                                      } else {
                                        return 16.0;
                                      }
                                    }(),
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleSmallIsCustom,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ]
                          .addToStart(SizedBox(width: 16.0))
                          .addToEnd(SizedBox(width: 16.0)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  final rows = [
                                    ..._model.provenanceRows,
                                    ProvenanceRow(
                                      id: -1,
                                      bioregionCode: '',
                                      location: '',
                                      locationTypeId: null,
                                      extraDetails: '',
                                    ),
                                  ];

                                  return FlutterFlowDataTable<ProvenanceRow>(
                                    controller: _model.provenanceTableController,
                                    data: rows,
                                    columnsBuilder: (onSortChanged) => [
                                      DataColumn2(label: Text('Bioregion code')),
                                      DataColumn2(label: Text('Location')),
                                      DataColumn2(label: Text('Location Type')),
                                      DataColumn2(label: Text('Extra details')),
                                    ],
                                    dataRowBuilder: (row, rowIndex, selected, onSelectChanged) {
                                      final isNew = row.id == -1;

                                      final bioregionCtrl = isNew
                                          ? _newBioregionCtrl
                                          : (_bioregionCtrls[row.id] ??=
                                              TextEditingController(text: row.bioregionCode));

                                      final locationCtrl = isNew
                                          ? _newLocationCtrl
                                          : (_locationCtrls[row.id] ??=
                                              TextEditingController(text: row.location));

                                      final extraCtrl = isNew
                                          ? _newExtraCtrl
                                          : (_extraCtrls[row.id] ??=
                                              TextEditingController(text: row.extraDetails ?? ''));

                                      final selectedLocationTypeId = isNew
                                          ? _newLocationTypeId
                                          : _locationTypeIds[row.id] ?? row.locationTypeId;

                                      return DataRow(
                                        selected: _dirtyIds.contains(row.id),
                                        onSelectChanged: (val) {
                                          if (!isNew && val == true) {
                                            setState(() => _dirtyIds.add(row.id));
                                          } else {
                                            setState(() => _dirtyIds.remove(row.id));
                                          }
                                        },
                                        color: WidgetStateProperty.all(
                                          rowIndex % 2 == 0
                                              ? FlutterFlowTheme.of(context).secondaryBackground
                                              : FlutterFlowTheme.of(context).primaryBackground,
                                        ),
                                        cells: [
                                          // Bioregion code
                                          DataCell(TextFormField(
                                            controller: bioregionCtrl,
                                            decoration: InputDecoration(
                                              hintText: 'Bioregion code',
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (_) => _markDirty(row.id),
                                          )),

                                          // Location
                                          DataCell(TextFormField(
                                            controller: locationCtrl,
                                            decoration: InputDecoration(
                                              hintText: 'Location',
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (_) => _markDirty(row.id),
                                          )),

                                          // Location Type (Dropdown)
                                          DataCell(DropdownButtonFormField<int>(
                                            value: selectedLocationTypeId,
                                            items: _model.locationTypes
                                                .map((lt) => DropdownMenuItem<int>(
                                                      value: lt.id,
                                                      child: Text(lt.locationType),
                                                    ))
                                                .toList(),
                                            onChanged: (val) {
                                              setState(() {
                                                if (isNew) {
                                                  _newLocationTypeId = val;
                                                } else {
                                                  _locationTypeIds[row.id] = val;
                                                  _markDirty(row.id);
                                                }
                                              });
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          )),

                                          // Extra details
                                          DataCell(TextFormField(
                                            controller: extraCtrl,
                                            decoration: InputDecoration(
                                              hintText: 'Extra details',
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (_) => _markDirty(row.id),
                                          )),
                                        ],
                                      );
                                    },
                                    paginated: true,
                                    selectable: false,
                                    hidePaginator: false,
                                    showFirstLastButtons: false,
                                    headingRowHeight: 56.0,
                                    dataRowHeight: 48.0,
                                    columnSpacing: 20.0,
                                    headingRowColor: FlutterFlowTheme.of(context).secondary,
                                    borderRadius: BorderRadius.circular(8.0),
                                    addHorizontalDivider: true,
                                    addTopAndBottomDivider: false,
                                    hideDefaultHorizontalDivider: true,
                                    horizontalDividerColor:
                                        FlutterFlowTheme.of(context).secondaryBackground,
                                    horizontalDividerThickness: 1.0,
                                    addVerticalDivider: false,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            Row(
                              children: [
                                const Spacer(),
                                FFButtonWidget(
                                  onPressed: _loading ? null : _onCancel,
                                  text: 'Cancel',
                                  options: FFButtonOptions(
                                    width: 100.0,
                                    height: 48.0,
                                    color: Colors.white,
                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context).titleSmallFamily,
                                          color: FlutterFlowTheme.of(context).primaryText,
                                        ),
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                FFButtonWidget(
                                  onPressed: _loading ? null : _onSave,
                                  text: 'Save',
                                  options: FFButtonOptions(
                                    width: 100.0,
                                    height: 48.0,
                                    color: Colors.white,
                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context).titleSmallFamily,
                                          color: FlutterFlowTheme.of(context).primaryText,
                                        ),
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

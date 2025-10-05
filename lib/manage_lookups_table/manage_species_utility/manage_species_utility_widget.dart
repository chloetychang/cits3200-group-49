import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/api_service.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'manage_species_utility_model.dart';
export 'manage_species_utility_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';


class ManageSpeciesUtilityWidget extends StatefulWidget {
  const ManageSpeciesUtilityWidget({super.key});

  static String routeName = 'ManageSpeciesUtility';
  static String routePath = '/manageSpeciesUtility';
  

  @override
  State<ManageSpeciesUtilityWidget> createState() =>
      _ManageSpeciesUtilityWidgetState();
}

class _ManageSpeciesUtilityWidgetState extends State<ManageSpeciesUtilityWidget> {
  late ManageSpeciesUtilityModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  

  void _createNewRowObject() {
    _newRow = SpeciesUtilityLinkRow(
      localKey: 'new_row_${DateTime.now().millisecondsSinceEpoch}',
      speciesId: -1,
      plantUtilityId: -1,
    );
  }

  final Map<String, int?> _selectedSpeciesIds = {};
  final Map<String, int?> _selectedUtilityIds = {};

  final Map<String, List<Map<String, dynamic>>> _dropdownOptions = {};

  final Set<String> _dirtyKeys = <String>{};
  bool _loading = false;

  List<Map<String, dynamic>> _preloadedSpecies = [];
  List<Map<String, dynamic>> _preloadedUtilities = [];
  late SpeciesUtilityLinkRow _newRow;
  final Map<String, TextEditingController> _speciesSearchControllers = {};
  final Map<String, TextEditingController> _utilitySearchControllers = {};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ManageSpeciesUtilityModel());
    _createNewRowObject();
    _loadLinks();
  }



Future<void> _loadLinks() async {
  if (!mounted) return;
  setState(() => _loading = true);
  

  _selectedSpeciesIds.clear();
  _selectedUtilityIds.clear();
  _dropdownOptions.clear();
  _dirtyKeys.clear();

  try {

    final results = await Future.wait([
      ApiService.getSpeciesUtilityLinks(),        
      ApiService.getSpeciesForPreloading(),      
      ApiService.getPlantUtilitiesForPreloading(), 
    ]);
    final linkList = results[0] as List<dynamic>;

    _preloadedSpecies = results[1] as List<Map<String, dynamic>>;
    _preloadedUtilities = results[2] as List<Map<String, dynamic>>;
    
    _model.rows = linkList
        .map((e) => SpeciesUtilityLinkRow.fromJson(e as Map<String, dynamic>))
        .toList();

    for (final r in _model.rows) {
      _selectedSpeciesIds[r.localKey] = r.speciesId;
      _selectedUtilityIds[r.localKey] = r.plantUtilityId;

      if (r.speciesId != -1 && r.speciesName != null) {
        final speciesKey = 'species_${r.localKey}';
        _dropdownOptions[speciesKey] = [{'id': r.speciesId, 'name': r.speciesName!}];
      }
      if (r.plantUtilityId != -1 && r.utilityName != null) {
        final utilityKey = 'utility_${r.localKey}';
        _dropdownOptions[utilityKey] = [{'id': r.plantUtilityId, 'utility': r.utilityName!}];
      }
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load initial data: $e')),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _loading = false);
    }
  }
}

  Future<void> _searchDropdownItems(String dropdownKey, String query, bool isSpecies) async {
    List<Map<String, dynamic>> results;
    if (isSpecies) {
      results = await ApiService.getSpecies(search: query);
    } else {
      results = await ApiService.getPlantUtilities(search: query);
    }
    if (!mounted) return;

    setState(() {
      final currentOptions = _dropdownOptions[dropdownKey] ?? [];
      final selectedId = isSpecies 
          ? _selectedSpeciesIds[dropdownKey.split('_').last] 
          : _selectedUtilityIds[dropdownKey.split('_').last];
      
      if (selectedId != null && !results.any((item) => item['id'] == selectedId)) {
        final selectedOption = currentOptions.firstWhere((item) => item['id'] == selectedId, orElse: () => {});
        if (selectedOption.isNotEmpty) {
          results.insert(0, selectedOption);
        }
      }
      _dropdownOptions[dropdownKey] = results;
    });
  }

  void _markDirty(String key) {
    if (mounted) {
      setState(() {
        _dirtyKeys.add(key);
      });
    }
  }

  Future<void> _onCancel() async {
    await _loadLinks(); 
  }
  Future<void> _onSave() async {
    if(_dirtyKeys.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes to save.')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      for (final key in _dirtyKeys) {
        final speciesId = _selectedSpeciesIds[key];
        final utilityId = _selectedUtilityIds[key];
        if (speciesId != null && utilityId != null) {

          await ApiService.createSpeciesUtilityLink(
            speciesId: speciesId,
            plantUtilityId: utilityId,
          );
        }
      }
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved successfully!')),
      );
      setState(() {
        _createNewRowObject();
      });
      await _loadLinks(); 
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    } finally {
      if(mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _model.dispose();


    _speciesSearchControllers.values.forEach((controller) => controller.dispose());
    _utilitySearchControllers.values.forEach((controller) => controller.dispose());

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primary,
      body: SafeArea(
        top: true,
        child: Container(
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 7,
                      child: FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(LandingASuperuserWidget.routeName);
                        },
                        text: 'Menu',
                        options: FFButtonOptions(
                          width: 100.0,
                          height: 50.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                          color: const Color(0xF0B2DDB2),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
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
                              kTransitionInfoKey: const TransitionInfo(
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
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: Colors.black,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(ManageContainerTypeWidget.routeName);
                        },
                        text: 'Container types',
                        options: FFButtonOptions(
                          width: 160.0,
                          height: 50.0,
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
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
                              kTransitionInfoKey: const TransitionInfo(
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
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: Colors.black,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
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
                              kTransitionInfoKey: const TransitionInfo(
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
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: Colors.black,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(
                            ManageProvenanceWidget.routeName,
                            extra: <String, dynamic>{
                              kTransitionInfoKey: const TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                                duration: Duration(milliseconds: 0),
                              ),
                            },
                          );
                        },
                        text: 'Provenance',
                        options: FFButtonOptions(
                          width: 160.0,
                          height: 50.0,
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: Colors.black,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
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
                              kTransitionInfoKey: const TransitionInfo(
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
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: Colors.black,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
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
                              kTransitionInfoKey: const TransitionInfo(
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
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: Colors.black,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: FFButtonWidget(
                        onPressed: () {
                        },
                        text: 'Species/Utility',
                        options: FFButtonOptions(
                          width: 160.0,
                          height: 50.0,
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: const Color(0xFFFF0000),
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
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
                              kTransitionInfoKey: const TransitionInfo(
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
                          color: const Color(0xFFF0F0F0),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                color: Colors.black,
                                fontSize: () {
                                  final w = MediaQuery.sizeOf(context).width;
                                  if (w < kBreakpointSmall) return 12.0;
                                  if (w < kBreakpointMedium) return 14.0;
                                  if (w < kBreakpointLarge) return 14.0;
                                  return 16.0;
                                }(),
                                letterSpacing: 0.0,
                                useGoogleFonts:
                                    !FlutterFlowTheme.of(context).titleSmallIsCustom,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ].addToStart(const SizedBox(width: 16.0)).addToEnd(const SizedBox(width: 16.0)),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: FlutterFlowDataTable<SpeciesUtilityLinkRow>(
                            controller: _model.speciesUtilityTableController,
                            data: [
                              ..._model.rows,
                              _newRow, 
                            ],
                            columnsBuilder: (onSortChanged) => const [
                              DataColumn2(label: Text('Species')),
                              DataColumn2(label: Text('Utility')),
                            ],
                            dataRowBuilder: (row, rowIndex, selected, onSelectChanged) {
                              final speciesDropdownKey = 'species_${row.localKey}';
                              final utilityDropdownKey = 'utility_${row.localKey}';

                              _dropdownOptions.putIfAbsent(speciesDropdownKey, () => []);
                              _dropdownOptions.putIfAbsent(utilityDropdownKey, () => []);

                              final speciesOptions = _dropdownOptions[speciesDropdownKey]!.isNotEmpty
                                  ? _dropdownOptions[speciesDropdownKey]!
                                  : _preloadedSpecies;
                                  
                              final utilityOptions = _dropdownOptions[utilityDropdownKey]!.isNotEmpty
                                  ? _dropdownOptions[utilityDropdownKey]!
                                  : _preloadedUtilities;

                              final speciesSearchController = _speciesSearchControllers.putIfAbsent(
                                row.localKey, () => TextEditingController());
                              final utilitySearchController = _utilitySearchControllers.putIfAbsent(
                                row.localKey, () => TextEditingController());


                              return DataRow(
                                color: WidgetStateProperty.all(
                                  rowIndex % 2 == 0
                                      ? FlutterFlowTheme.of(context).secondaryBackground
                                      : FlutterFlowTheme.of(context).primaryBackground,
                                ),
                                
                            

                                cells: [
                                  DataCell(
                                    DropdownButton2<int>(
                                      key: ValueKey('species_${row.localKey}_${speciesOptions.hashCode}'),
                                      isExpanded: true,
                                      value: _selectedSpeciesIds[row.localKey],
                                      hint: const Text('Select species'),
                                      items: speciesOptions
                                          .map((item) => DropdownMenuItem<int>(
                                                value: item['species_id'],
                                                child: Text(
                                                  item['species']?.toString() ?? 'Unknown',
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (val) {
                                        if (val == null) return;
                                        setState(() {
                                          _selectedSpeciesIds[row.localKey] = val;
                                          _markDirty(row.localKey);
                                        });
                                      },
                                      onMenuStateChange: (isOpen) {
                                        if (isOpen) {
                                          if (_dropdownOptions[speciesDropdownKey]!.isEmpty) {
                                            _searchDropdownItems(speciesDropdownKey, '', true);
                                          }
                                        }
                                      },
                                      dropdownStyleData: const DropdownStyleData(maxHeight: 300),
                                      
                                      // --- 修改这里 ---
                                      dropdownSearchData: DropdownSearchData(
                                        searchController: speciesSearchController, // 使用 state 中的 controller
                                        searchInnerWidgetHeight: 50,
                                        searchInnerWidget: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: speciesSearchController, // 确保 TextField 也使用同一个 controller
                                            decoration: const InputDecoration(
                                              hintText: 'Search species...',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (query) {
                                              _searchDropdownItems(speciesDropdownKey, query, true);
                                            },
                                          ),
                                        ),
                                        searchMatchFn: (item, searchValue) => true,
                                      ),
                                    ),
                                  ),

                                  /// Utility 下拉
                                  DataCell(
                                    DropdownButton2<int>(
                                      // ... (isExpanded, value, hint, items, onChanged 保持不变)
                                      isExpanded: true,
                                      value: _selectedUtilityIds[row.localKey],
                                      hint: const Text('Select utility'),
                                      items: utilityOptions
                                          .map((item) => DropdownMenuItem<int>(
                                                value: item['plant_utility_id'],
                                                child: Text(
                                                  item['utility']?.toString() ?? 'Unknown',
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (val) {
                                        if (val == null) return;
                                        setState(() {
                                          _selectedUtilityIds[row.localKey] = val;
                                          _markDirty(row.localKey);
                                        });
                                      },
                                      onMenuStateChange: (isOpen) {
                                        if (isOpen) {
                                          if (_dropdownOptions[utilityDropdownKey]!.isEmpty) {
                                            _searchDropdownItems(utilityDropdownKey, '', false);
                                          }
                                        }
                                      },
                                      dropdownStyleData: const DropdownStyleData(maxHeight: 300),
                                      
                                      // --- 修改这里 ---
                                      dropdownSearchData: DropdownSearchData(
                                        searchController: utilitySearchController, // 使用 state 中的 controller
                                        searchInnerWidgetHeight: 50,
                                        searchInnerWidget: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: utilitySearchController, // 确保 TextField 也使用同一个 controller
                                            decoration: const InputDecoration(
                                              hintText: 'Search utilities...',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (query) {
                                              _searchDropdownItems(utilityDropdownKey, query, false);
                                            },
                                          ),
                                        ),
                                        searchMatchFn: (item, searchValue) => true,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            paginated: true,
                            selectable: false,
                            headingRowHeight: 56.0,
                            dataRowHeight: 48.0,
                            columnSpacing: 20.0,
                            headingRowColor: FlutterFlowTheme.of(context).secondary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),

                        const SizedBox(height: 12.0),

                        /// 操作按钮
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
                                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                      color: FlutterFlowTheme.of(context).primaryText,
                                    ),
                                borderSide: const BorderSide(color: Colors.black),
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
                                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                      color: FlutterFlowTheme.of(context).primaryText,
                                    ),
                                borderSide: const BorderSide(color: Colors.black),
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
    );
  }
}
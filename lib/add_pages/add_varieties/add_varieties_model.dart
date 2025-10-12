import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'add_varieties_widget.dart' show AddVarietiesWidget;
import 'package:flutter/material.dart';

import '/backend/api_service.dart'; // use our API service 
import 'package:dropdown_textfield/dropdown_textfield.dart';

class AddVarietiesModel extends FlutterFlowModel<AddVarietiesWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  List<String> genusOptions = []; // labels for UI
  List<Map<String, dynamic>> genusData = []; // full objects with ids
  int? selectedGenusId; // numeric id
  bool isLoadingGenus = false;
  bool hasGenusIds = true; // true when genusData contains numeric genus_id
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  List<String> speciesOptions = [];
  List<Map<String, dynamic>> speciesData = [];
  int? selectedSpeciesId;
  // Combined species+variety dropdown (searchable) like Acquisitions
  late final SingleValueDropDownController speciesComboController;
  // Genus searchable controller (match Acquisition/Provenance pattern)
  late final SingleValueDropDownController genusComboController;
  List<Map<String, dynamic>> speciesWithVarietyDropdown = []; // { species_id, full_species_name }
  String? selectedSpeciesWithFullName;
  bool isLoadingSpecies = false;
  // State field(s) for DropDown widget.
  String? dropDownValue3;
  FormFieldController<String>? dropDownValueController3;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for DropDown widget.
  String? dropDownValue4;
  FormFieldController<String>? dropDownValueController4;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  @override
  void initState(BuildContext context) {
    speciesComboController = SingleValueDropDownController();
    genusComboController = SingleValueDropDownController();
  }

  Future<void> loadSpeciesWithVarietyDropdown() async {
    try {
      final raw = await ApiService.getVarietiesWithSpeciesDropdown();
      // Deduplicate by species_id
      final seen = <int>{};
      final list = <Map<String, dynamic>>[];
      for (final r in raw) {
        final sid = (r['species_id'] as int?);
        final full = (r['full_species_name'] ?? '') as String;
        if (sid == null || full.isEmpty) continue;
        if (seen.contains(sid)) continue;
        seen.add(sid);
        list.add({'species_id': sid, 'full_species_name': full});
      }
      speciesWithVarietyDropdown = list;
      speciesOptions = list.map((e) => e['full_species_name'] as String).toList()..sort();
      speciesData = list.map((e) => {'species_id': e['species_id'], 'species': e['full_species_name']}).toList();
      print('AddVarietiesModel.loadSpeciesWithVarietyDropdown: loaded ${speciesOptions.length} species');
    } catch (e) {
      print('AddVarietiesModel.loadSpeciesWithVarietyDropdown failed -> $e');
      speciesWithVarietyDropdown = [];
      speciesOptions = [];
    }
  }

  // Load genus list
  Future<void> loadGenus() async {
    isLoadingGenus = true;
    try {
  final rows = await ApiService.getGenusDropdown();
  // Expecting rows like [{ 'genus_id': 1, 'genus': 'Acacia' }, ...]
  genusData = rows;
      genusOptions = rows.map((r) => r['genus'] as String).toList();
      genusOptions.sort();
      hasGenusIds = genusData.isNotEmpty && genusData.first.containsKey('genus_id');
      print('AddVarietiesModel.loadGenus: loaded ${genusOptions.length} genus entries (hasGenusIds=$hasGenusIds)');
    } catch (e) {
      print('AddVarietiesModel.loadGenus: failed -> $e');
      // Fallback: try to build genus/species lists from acquisition varieties_with_species
      try {
        final raw = await ApiService.getVarietiesWithSpeciesDropdown();
        // raw entries expected: { 'variety_id', 'variety', 'full_species_name', 'species_id' }
        // Build a unique genus list by splitting the full_species_name
        final genusSet = <String>{};
        final fallbackSpecies = <Map<String, dynamic>>[];
        for (final r in raw) {
          final full = (r['full_species_name'] ?? '') as String;
          if (full.isEmpty) continue;
          final parts = full.split(' ');
          final g = parts.isNotEmpty ? parts.first : full;
          genusSet.add(g);
          // use the full species name as the display label so we can map back to species_id
          fallbackSpecies.add({
            'species_id': r['species_id'],
            'species': full,
            'full_species_name': full,
          });
        }
        genusOptions = genusSet.toList()..sort();
        genusData = genusOptions.map((g) => {'genus': g}).toList();
        // store speciesData as full labels
        speciesData = fallbackSpecies;
        speciesOptions = fallbackSpecies.map((s) => s['species'] as String).toList()..sort();
        hasGenusIds = false;
        print('AddVarietiesModel.loadGenus: fallback loaded genus=${genusOptions.length} species=${speciesOptions.length}');
      } catch (e2) {
        print('AddVarietiesModel.loadGenus fallback failed -> $e2');
        // keep empty lists so UI can handle gracefully
        genusData = [];
        genusOptions = [];
      }
    } finally {
      isLoadingGenus = false;
    }
  }

  // Load species for a given genus id
  Future<void> loadSpeciesForGenus(int genusId) async {
    isLoadingSpecies = true;
    try {
      if (hasGenusIds) {
        final rows = await ApiService.getSpeciesByGenus(genusId);
        // find genus name for display
        final genusEntry = genusData.firstWhere((g) => (g['genus_id'] as int?) == genusId, orElse: () => <String, dynamic>{});
        final genusName = (genusEntry['genus'] ?? '') as String;
        // convert rows to include full_species_name for display ("Genus species")
        final list = rows.map((r) {
          final speciesName = (r['species'] ?? '') as String;
          return {
            'species_id': r['species_id'],
            'species': speciesName,
            'full_species_name': genusName.isNotEmpty ? '\$genusName $speciesName' : speciesName,
          };
        }).toList();
        speciesData = list;
        speciesOptions = list.map((r) => r['full_species_name'] as String).toList();
        speciesOptions.sort();
        print('AddVarietiesModel.loadSpeciesForGenus: genusId=$genusId loaded ${speciesOptions.length} species (by id)');
      } else {
        // We don't have numeric genus ids; nothing to load by id here — caller should use loadSpeciesForGenusName
        print('AddVarietiesModel.loadSpeciesForGenus: skipping id-based load because hasGenusIds=false');
      }
    } catch (e) {
      print('AddVarietiesModel.loadSpeciesForGenus: genusId=$genusId failed -> $e');
      speciesData = [];
      speciesOptions = [];
    } finally {
      isLoadingSpecies = false;
    }
  }

  // Alternate loader: when we only have genus name (no genus_id) call this to filter speciesData by name
  Future<void> loadSpeciesForGenusName(String genusName) async {
    isLoadingSpecies = true;
    try {
      // if speciesData is empty, try to preload varieties_with_species
      if (speciesData.isEmpty) {
        final raw = await ApiService.getVarietiesWithSpeciesDropdown();
        final fallbackSpecies = <Map<String, dynamic>>[];
        for (final r in raw) {
          final full = (r['full_species_name'] ?? '') as String;
          if (full.isEmpty) continue;
          fallbackSpecies.add({
            'species_id': r['species_id'],
            'species': full,
            'full_species_name': full,
          });
        }
        speciesData = fallbackSpecies;
        speciesOptions = fallbackSpecies.map((s) => s['species'] as String).toList()..sort();
      }

      // filter by genus name (exact, case-insensitive match on the first token)
      final target = genusName.trim().toLowerCase();
      final filtered = speciesData.where((s) {
        final full = (s['full_species_name'] ?? s['species']) as String;
        final first = full.split(' ').isNotEmpty ? full.split(' ').first : full;
        return first.toLowerCase() == target;
      }).toList();
      speciesOptions = filtered.map((s) => s['species'] as String).toList();
      speciesOptions.sort();
      speciesData = filtered;
      print('AddVarietiesModel.loadSpeciesForGenusName: genus=$genusName found=${speciesOptions.length}');
    } catch (e) {
      print('AddVarietiesModel.loadSpeciesForGenusName failed -> $e');
      speciesData = [];
      speciesOptions = [];
    } finally {
      isLoadingSpecies = false;
    }
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
    speciesComboController.dispose();
    genusComboController.dispose();
  }
}

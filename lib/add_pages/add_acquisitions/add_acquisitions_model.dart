import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import '/backend/api_service.dart'; // use our API service
import 'add_acquisitions_widget.dart' show AddAcquisitionsWidget;
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class AddAcquisitionsModel extends FlutterFlowModel<AddAcquisitionsWidget> {
  // Combo controllers for genus and species dropdowns
  late final SingleValueDropDownController genusComboController;
  late final SingleValueDropDownController speciesComboController;
  late final SingleValueDropDownController supplierComboController;
  late final SingleValueDropDownController locationComboController;
  late final SingleValueDropDownController bioregionComboController;

  // State field for selected variety ID (from dropdown)
  int? selectedVarietyId;
  // State field for selected generation number (from dropdown)
  int? selectedGenerationNumber;
  ///  State fields for stateful widgets in this page.

  // 1) Acquisition Date widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  
  // 2) Genus DropDown widget.
  List<String> genusDropdown = []; // Holds list of genus to show in dropdown
  String? selectedGenus; // Stores the current selected genus
  FormFieldController<String>? genusDropdownController; // Manage state of genus dropdown form field

  // Fetch Genus Dropdown 
  Future<void> loadGenusDropdown() async {
    final rawList = await ApiService.getGenusDropdown();
    genusDropdown = rawList.toSet().toList()..sort();
  }

  // 2b) Species DropDown widget.
  List<String> speciesDropdown = []; // Holds list of species to show in dropdown
  String? selectedSpecies; // Stores the current selected species
  FormFieldController<String>? speciesDropdownController; // Manage state of species dropdown form field

  // Fetch Species Dropdown based on selected genus
  Future<void> loadSpeciesDropdown() async {
    final rawList = await ApiService.getSpeciesDropdown();
    speciesDropdown = rawList.toSet().toList()..sort();
  }

  // 3) Supplier DropDown widget.
  List<String> suppliersDropdown = [];
  String? dropDownSupplier;
  FormFieldController<String>? dropDownSupplierController;

  // Fetch Suppliers Dropdown
  Future<void> loadSuppliersDropdown() async {
    final rawList = await ApiService.getSuppliersDropdown();
    suppliersDropdown = rawList.toSet().toList()..sort();

     if (supplierComboController.dropDownValue != null &&
         !suppliersDropdown.contains(supplierComboController.dropDownValue!.value)) {
       suppliersDropdown.add(supplierComboController.dropDownValue!.value);
     }
  }

  // 4) Location DropDown widget
  List<String> locationDropdown = [];
  String? dropDownLocation;
  FormFieldController<String>? dropDownLocationController;

  // Fetch Provenance Location Dropdown
  Future<void> loadLocationDropdown() async {
    final rawList = await ApiService.getLocationDropdown();
    locationDropdown = rawList.toSet().toList()..sort();
  }

  List<String> bioregionDropdown = [];
  String? selectedBioregionCode;
  FormFieldController<String>? bioregionDropdownController;

  // Fetch Bioregion Dropdown
  Future<void> loadBioregionDropdown() async {
    // You need to implement this API call in ApiService
    final rawList = await ApiService.getBioregionDropdown();
    bioregionDropdown = rawList.toSet().toList()..sort();
  }

  // For future implementation - Add Family name and Generation Number into this Genetic_source data map. 
  // 5) Save Button Widget
  Future<void> saveAcquisition() async {
    final geneticSource = {
      "acquisition_date": textController1?.text,
      "variety_id": selectedVarietyId,
      "price": double.tryParse(textController3?.text ?? ''),
      "gram_weight": int.tryParse(textController4?.text ?? ''),
      "viability": int.tryParse(textController5?.text ?? ''),
      "generation_number": selectedGenerationNumber,
      "landscape_only": checkboxValue ?? false,
    };
    final supplier = {
      "supplier_name": dropDownSupplier,
    };
    final provenance = {
      "bioregion_code": selectedBioregionCode,
      "location": dropDownLocation,
    };
    await ApiService.createAcquisition(
      geneticSource: geneticSource,
      supplier: supplier,
      provenance: provenance,
    );  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode5;
  TextEditingController? textController5;
  String? Function(BuildContext, String?)? textController5Validator;
  // State field(s) for Checkbox widget.
  bool? checkboxValue;
  // State field(s) for DropDown widget.
  String? dropDownValue4;
  FormFieldController<String>? dropDownValueController4;
  // State field(s) for DropDown widget.
  String? dropDownValue5;
  FormFieldController<String>? dropDownValueController5;


  @override
  void initState(BuildContext context) {
    supplierComboController = SingleValueDropDownController();
    genusComboController = SingleValueDropDownController();
    speciesComboController = SingleValueDropDownController();
    locationComboController = SingleValueDropDownController();
    bioregionComboController = SingleValueDropDownController();
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    textFieldFocusNode4?.dispose();
    textController4?.dispose();

    textFieldFocusNode5?.dispose();
    textController5?.dispose();

    supplierComboController.dispose();
    genusComboController.dispose();
    speciesComboController.dispose();
    locationComboController.dispose();
    bioregionComboController.dispose();

  }

  

}

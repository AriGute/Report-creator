import 'package:flutter/material.dart';
import 'package:save_pdf/pages/models/base_form.dart';

class GeneratorForm extends BaseForm {
  // Identifying information
  String facilityName = "";
  String facilityOwner = "";
  String facilityAddres = "";
  String phoneNumber = "";

  // Tecnical details
  String generatorOutput = "";
  String generatorManufactur = "";
  String model = "";
  String id = "";
  String voltage = "";
  String generagorLocation = "";
  String feulType = "";
  String groundingMethod = "";

  String outputConductorCrossSection = "";
  String crossSectionOfGroundedConductor = "";
  String electrificationProtectionMethod = "";
  String autoGenerator = "";
  bool staticGenerator = false;
  String generatorPanelMainBreakerfacturer = "";
  String currentGeneratorPanelMainBreakerfacturer = "";
  String currentBalance = "";
  String magneticAdjustment = "";

  String fedPanelBreakerfacturer = "";
  String currentfedPanelBreakerfacturer = "";
  String wholeFacilityIsFedFromGenerator = "";
  bool theRestIsFromEnergyDepartment = false;
}

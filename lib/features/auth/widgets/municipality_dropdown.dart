import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import 'searchable_select_field.dart';

class MunicipalityDropdown extends StatelessWidget {
  const MunicipalityDropdown({
    super.key,
    required this.state,
    required this.controller,
  });

  final AuthState state;
  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return SearchableSelectField(
      label: 'Municipality',
      hintText: 'Select Municipality',
      value: state.municipality,
      items: controller.municipalities,
      enabled: true,
      onSelected: controller.selectMunicipality,
    );
  }
}

import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import 'searchable_select_field.dart';

class BarangayDropdown extends StatelessWidget {
  const BarangayDropdown({
    super.key,
    required this.state,
    required this.controller,
  });

  final AuthState state;
  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    final options = controller.barangaysFor(state.municipality);
    return SearchableSelectField(
      label: 'Barangay',
      hintText: 'Select Barangay',
      value: state.barangay,
      items: options,
      enabled: state.municipality != null,
      onSelected: controller.selectBarangay,
    );
  }
}

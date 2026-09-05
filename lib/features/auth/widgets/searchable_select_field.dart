import 'package:flutter/material.dart';

import '../../../core/constants/app_animations.dart';

class SearchableSelectField extends StatelessWidget {
  const SearchableSelectField({
    super.key,
    required this.label,
    required this.hintText,
    required this.value,
    required this.items,
    required this.enabled,
    required this.onSelected,
  });

  final String label;
  final String hintText;
  final String? value;
  final List<String> items;
  final bool enabled;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => _showPicker(context) : null,
      borderRadius: BorderRadius.circular(22),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(22)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22)),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
        child: Row(
          children: [
            Expanded(child: Text(value ?? hintText, style: TextStyle(color: value == null ? const Color(0xFF64748B) : null))),
            Icon(enabled ? Icons.expand_more_rounded : Icons.lock_outline_rounded),
          ],
        ),
      ),
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _SearchPickerSheet(label: label, items: items),
    );
    if (selected != null) onSelected(selected);
  }
}

class _SearchPickerSheet extends StatefulWidget {
  const _SearchPickerSheet({required this.label, required this.items});

  final String label;
  final List<String> items;

  @override
  State<_SearchPickerSheet> createState() => _SearchPickerSheetState();
}

class _SearchPickerSheetState extends State<_SearchPickerSheet> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.items.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.45,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(width: 44, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(999))),
                  const SizedBox(height: 16),
                  Text('Select ${widget.label}', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (v) => setState(() => query = v),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      hintText: 'Search',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: AppAnimations.indicator,
                      child: ListView.builder(
                        key: ValueKey(filtered.join('|')),
                        controller: scrollController,
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return ListTile(
                            title: Text(item),
                            onTap: () => Navigator.pop(context, item),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

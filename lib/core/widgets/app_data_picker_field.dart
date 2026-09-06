import 'package:flutter/material.dart';
import '../utils/date_utils.dart';
import '../theme/app_colors.dart';

class AppDatePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onChanged;
  final String? errorText;

  const AppDatePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    this.errorText,
  });

  Future<void> _pick(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pick(context),
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          suffixIcon: const Icon(Icons.calendar_today_rounded,
              size: 20, color: AppColors.textSecondary),
        ),
        child: Text(
          value == null ? 'Select date' : AppDateUtils.formatDate(value!),
          style: TextStyle(
            color: value == null ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
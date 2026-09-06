import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Reusable confirmation dialog. Returns true if the user confirmed,
/// false/null if cancelled or dismissed.
Future<bool> showConfirmationDialog(
    BuildContext context, {
      required String title,
      required String message,
      String confirmLabel = 'Confirm',
      String cancelLabel = 'Cancel',
      bool isDestructive = true,
    }) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: isDestructive ? AppColors.error : AppColors.primary,
          ),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
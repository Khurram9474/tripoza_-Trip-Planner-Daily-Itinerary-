import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripora/features/activities/presentation/widgets/app_button.dart';
import 'package:tripora/features/activities/presentation/widgets/category_chip.dart';
import 'package:tripora/features/activities/presentation/widgets/custom_app_bar.dart' show CustomAppBar;
import '../../data/models/activity_model.dart';
import '../../../trips/presentation/providers/trip_provider.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';

class EditActivityScreen extends ConsumerStatefulWidget {
  final String tripId;
  final String activityId;

  const EditActivityScreen({
    super.key,
    required this.tripId,
    required this.activityId,
  });

  @override
  ConsumerState<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends ConsumerState<EditActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  int? _selectedDay;
  String? _selectedCategory;
  TimeOfDay? _selectedTime;
  bool _isSaving = false;
  bool _prefilled = false;
  bool _formTouched = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _prefillIfNeeded(ActivityModel activity) {
    if (_prefilled) return;
    _nameController.text = activity.name;
    _locationController.text = activity.location;
    _descriptionController.text = activity.description;
    _selectedDay = activity.day;
    _selectedCategory = activity.category;

    final parts = activity.time.split(':');
    if (parts.length == 2) {
      _selectedTime = TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    }
    _prefilled = true;
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hour.toString().padLeft(2, '0');
    final minute = t.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _submit(ActivityModel original) {
    setState(() => _formTouched = true);
    final formValid = _formKey.currentState!.validate();
    final categoryValid = _selectedCategory != null;
    final timeValid = _selectedTime != null;
    if (!formValid || !categoryValid || !timeValid) return;

    setState(() => _isSaving = true);

    final updated = original.copyWith(
      day: _selectedDay,
      name: _nameController.text.trim(),
      time: _formatTime(_selectedTime!),
      location: _locationController.text.trim(),
      category: _selectedCategory,
      description: _descriptionController.text.trim(),
    );

    ref.read(tripProvider.notifier).updateActivity(widget.tripId, updated);

    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Activity updated successfully!')));
    context.pop();
  }

  Future<void> _confirmAndDelete() async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete Activity',
      message: 'Are you sure you want to delete this activity?',
      confirmLabel: 'Delete',
    );
    if (confirmed) {
      ref.read(tripProvider.notifier).deleteActivity(widget.tripId, widget.activityId);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Activity deleted')));
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = ref.watch(tripByIdProvider(widget.tripId));
    final activities = ref.watch(activitiesForTripProvider(widget.tripId));

    if (trip == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Edit Activity', showBack: true),
        body: const Center(child: Text('This trip no longer exists.')),
      );
    }

    ActivityModel? activity;
    for (final a in activities) {
      if (a.id == widget.activityId) activity = a;
    }

    if (activity == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Edit Activity', showBack: true),
        body: const Center(child: Text('This activity no longer exists.')),
      );
    }

    _prefillIfNeeded(activity);
    final totalDays = AppDateUtils.calculateDurationInDays(trip.startDate, trip.endDate);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Activity',
        showBack: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: _confirmAndDelete,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Day', style: AppTextStyles.bodyMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: List.generate(totalDays, (i) {
                    final day = i + 1;
                    final selected = day == _selectedDay;
                    return ChoiceChip(
                      label: Text('Day $day'),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedDay = day),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _nameController,
                  label: 'Activity Name',
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Activity name is required' : null,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickTime,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Time',
                      errorText:
                      (_formTouched && _selectedTime == null) ? 'Time is required' : null,
                      suffixIcon: const Icon(Icons.access_time_rounded, size: 20),
                    ),
                    child: Text(_selectedTime == null
                        ? 'Select time'
                        : _formatTime(_selectedTime!)),
                  ),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _locationController,
                  label: 'Location',
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Location is required' : null,
                ),
                const SizedBox(height: 16),
                Text('Category', style: AppTextStyles.bodyMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppConstants.activityCategories.map((c) {
                    return CategoryChip(
                      category: c,
                      selected: _selectedCategory == c,
                      onTap: () => setState(() => _selectedCategory = c),
                    );
                  }).toList(),
                ),
                if (_selectedCategory == null && _formTouched) ...[
                  const SizedBox(height: 6),
                  Text('Please select a category',
                      style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
                ],
                const SizedBox(height: 16),
                AppTextField(
                  controller: _descriptionController,
                  label: 'Description (optional)',
                  maxLines: 3,
                ),
                const SizedBox(height: 28),
                AppButton(
                  label: _isSaving ? 'Saving...' : 'Save Changes',
                  onPressed: _isSaving ? null : () => _submit(activity!),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
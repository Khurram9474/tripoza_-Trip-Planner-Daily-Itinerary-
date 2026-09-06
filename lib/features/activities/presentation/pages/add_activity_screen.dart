import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripora/features/activities/presentation/widgets/app_button.dart';
import 'package:tripora/features/activities/presentation/widgets/category_chip.dart';
import 'package:tripora/features/activities/presentation/widgets/custom_app_bar.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/activity_model.dart';
import '../../../trips/presentation/providers/trip_provider.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';

class AddActivityScreen extends ConsumerStatefulWidget {
  final String tripId;
  final int? preselectedDay;

  const AddActivityScreen({
    super.key,
    required this.tripId,
    this.preselectedDay,
  });

  @override
  ConsumerState<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends ConsumerState<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  late int _selectedDay;
  String? _selectedCategory;
  TimeOfDay? _selectedTime;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.preselectedDay ?? 1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
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

  void _submit() {
    final formValid = _formKey.currentState!.validate();
    final categoryValid = _selectedCategory != null;
    final timeValid = _selectedTime != null;

    if (!formValid || !categoryValid || !timeValid) {
      setState(() {}); // trigger rebuild to show inline errors below
      return;
    }

    setState(() => _isSaving = true);

    final activity = ActivityModel(
      id: const Uuid().v4(),
      day: _selectedDay,
      name: _nameController.text.trim(),
      time: _formatTime(_selectedTime!),
      location: _locationController.text.trim(),
      category: _selectedCategory!,
      description: _descriptionController.text.trim(),
    );

    ref.read(tripProvider.notifier).addActivity(widget.tripId, activity);

    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Activity added successfully!')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final trip = ref.watch(tripByIdProvider(widget.tripId));
    final totalDays = trip == null
        ? 1
        : AppDateUtils.calculateDurationInDays(trip.startDate, trip.endDate);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Add Activity', showBack: true),
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
                  hint: 'e.g. Visit Museum',
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
                      errorText: (_isSaving == false && _selectedTime == null && _formKeyTouched)
                          ? 'Time is required'
                          : null,
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
                  hint: 'e.g. National Museum',
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
                if (_selectedCategory == null && _formKeyTouched) ...[
                  const SizedBox(height: 6),
                  Text('Please select a category',
                      style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
                ],
                const SizedBox(height: 16),
                AppTextField(
                  controller: _descriptionController,
                  label: 'Description (optional)',
                  hint: 'Add any notes about this activity',
                  maxLines: 3,
                ),
                const SizedBox(height: 28),
                AppButton(
                  label: _isSaving ? 'Adding...' : 'Add Activity',
                  onPressed: _isSaving
                      ? null
                      : () {
                    setState(() => _formKeyTouched = true);
                    _submit();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _formKeyTouched = false;
}
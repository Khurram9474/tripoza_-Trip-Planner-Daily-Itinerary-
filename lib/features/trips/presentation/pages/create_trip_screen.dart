import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripora/core/widgets/app_data_picker_field.dart';
import 'package:tripora/features/activities/presentation/widgets/app_button.dart';
import 'package:tripora/features/activities/presentation/widgets/custom_app_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/date_utils.dart';
import '../providers/trip_provider.dart';
import '../../../../routes/app_router.dart';

class CreateTripScreen extends ConsumerStatefulWidget {
  final String? editingTripId;

  const CreateTripScreen({super.key, this.editingTripId});

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _destinationController = TextEditingController();
  final _travelersController = TextEditingController(text: '1');

  DateTime? _startDate;
  DateTime? _endDate;
  String? _dateError;
  bool _isSaving = false;
  bool _prefilled = false;

  bool get _isEditing => widget.editingTripId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _destinationController.dispose();
    _travelersController.dispose();
    super.dispose();
  }

  void _prefillIfNeeded() {
    if (_prefilled || !_isEditing) return;
    final trip = ref.read(tripByIdProvider(widget.editingTripId!));
    if (trip != null) {
      _nameController.text = trip.name;
      _destinationController.text = trip.destination;
      _travelersController.text = '${trip.travelers}';
      _startDate = trip.startDate;
      _endDate = trip.endDate;
      _prefilled = true;
    }
  }

  bool _validateDates() {
    if (_startDate == null || _endDate == null) {
      setState(() => _dateError = 'Please select both start and end dates');
      return false;
    }
    if (!AppDateUtils.isEndDateValid(_startDate!, _endDate!)) {
      setState(() => _dateError = 'End date cannot be before start date');
      return false;
    }
    setState(() => _dateError = null);
    return true;
  }

  void _submit() async {
    final formValid = _formKey.currentState!.validate();
    final datesValid = _validateDates();
    if (!formValid || !datesValid) return;

    setState(() => _isSaving = true);
    final notifier = ref.read(tripProvider.notifier);

    if (_isEditing) {
      final existing = ref.read(tripByIdProvider(widget.editingTripId!))!;
      final updated = existing.copyWith(
        name: _nameController.text.trim(),
        destination: _destinationController.text.trim(),
        startDate: _startDate!,
        endDate: _endDate!,
        travelers: int.parse(_travelersController.text.trim()),
      );
      notifier.updateTrip(updated);
      setState(() => _isSaving = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Trip updated successfully!')));
      context.pop();
    } else {
      final trip = notifier.createTrip(
        name: _nameController.text.trim(),
        destination: _destinationController.text.trim(),
        startDate: _startDate!,
        endDate: _endDate!,
        travelers: int.parse(_travelersController.text.trim()),
      );
      setState(() => _isSaving = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Trip created successfully!')));
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      context.pushReplacement(AppRoutes.tripDetailsPath(trip.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    _prefillIfNeeded();
    final today = DateTime.now();

    return Scaffold(
      appBar: CustomAppBar(title: _isEditing ? 'Edit Trip' : 'Create Trip', showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: _nameController,
                  label: 'Trip Name',
                  hint: 'e.g. Northern Escape',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Trip name is required';
                    if (v.trim().length < 3) return 'Trip name must be at least 3 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _destinationController,
                  label: 'Destination',
                  hint: 'e.g. Hunza Valley',
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Destination is required' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppDatePickerField(
                        label: 'Start Date',
                        value: _startDate,
                        firstDate: _isEditing ? DateTime(today.year - 1) : today,
                        lastDate: DateTime(today.year + 3),
                        onChanged: (d) => setState(() {
                          _startDate = d;
                          if (_endDate != null && _endDate!.isBefore(d)) _endDate = null;
                        }),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppDatePickerField(
                        label: 'End Date',
                        value: _endDate,
                        firstDate: _startDate ?? today,
                        lastDate: DateTime(today.year + 3),
                        onChanged: (d) => setState(() => _endDate = d),
                      ),
                    ),
                  ],
                ),
                if (_dateError != null) ...[
                  const SizedBox(height: 6),
                  Text(_dateError!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
                ],
                const SizedBox(height: 16),
                AppTextField(
                  controller: _travelersController,
                  label: 'Number of Travelers',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Number of travelers is required';
                    final n = int.tryParse(v.trim());
                    if (n == null || n < 1) return 'Enter at least 1 traveler';
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                AppButton(
                  label: _isSaving
                      ? (_isEditing ? 'Saving...' : 'Creating...')
                      : (_isEditing ? 'Save Changes' : 'Create Trip'),
                  onPressed: _isSaving ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
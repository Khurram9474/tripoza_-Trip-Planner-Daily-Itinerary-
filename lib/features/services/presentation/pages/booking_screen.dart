import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../routes/app_router.dart';
import '../../../services/presentation/providers/service_provider.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String serviceId;

  const BookingScreen({super.key, required this.serviceId});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _requestController = TextEditingController();

  DateTime? _selectedDate;
  int _numberOfPeople = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _requestController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _incrementPeople() => setState(() => _numberOfPeople++);

  void _decrementPeople() {
    if (_numberOfPeople > 1) {
      setState(() => _numberOfPeople--);
    }
  }

  void _submit(double pricePerPerson, String serviceName, String serviceCategory) {
    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a booking date.')),
      );
      return;
    }

    if (!isFormValid) return;

    context.push(
      AppRoutes.bookingSummary,
      extra: {
        'serviceId': widget.serviceId,
        'serviceName': serviceName,
        'serviceCategory': serviceCategory,
        'customerName': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'bookingDate': _selectedDate!,
        'numberOfPeople': _numberOfPeople,
        'pricePerPerson': pricePerPerson,
        'specialRequest': _requestController.text.trim(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(serviceByIdProvider(widget.serviceId));

    if (service == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('This service is no longer available.', style: AppTextStyles.bodyMedium)),
      );
    }

    final totalAmount = service.price * _numberOfPeople;

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSelectedServiceCard(service.name, service.category, service.location),
            const SizedBox(height: 20),
            Text('Your Information', style: AppTextStyles.sectionHeading),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
              validator: Validators.fullName,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined)),
              validator: Validators.phone,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined)),
              validator: Validators.email,
            ),
            const SizedBox(height: 20),
            Text('Booking Date', style: AppTextStyles.sectionHeading),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: const InputDecoration(prefixIcon: Icon(Icons.calendar_today_outlined)),
                child: Text(
                  _selectedDate == null
                      ? 'Select a date'
                      : DateFormat('d MMMM yyyy').format(_selectedDate!),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _selectedDate == null ? AppColors.textSecondary : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Number of People', style: AppTextStyles.sectionHeading),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _decrementPeople,
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppColors.primary,
                  ),
                  Text('$_numberOfPeople', style: AppTextStyles.sectionHeading),
                  IconButton(
                    onPressed: _incrementPeople,
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _requestController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Special Request (optional)',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Amount', style: AppTextStyles.sectionHeading),
                  Text(
                    'PKR ${_formatPrice(totalAmount)}',
                    style: AppTextStyles.screenTitle.copyWith(fontSize: 20, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _submit(service.price, service.name, service.category),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
              child: const Text('Continue to Summary'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedServiceCard(String name, String category, String location) {
    return Card(
      color: AppColors.surfaceVariant,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.confirmation_number_outlined, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.cardTitle),
                  Text('$category · $location', style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }
}
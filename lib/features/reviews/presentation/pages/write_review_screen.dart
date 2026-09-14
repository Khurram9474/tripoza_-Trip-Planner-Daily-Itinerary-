import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../providers/review_provider.dart';
import '../widgets/star_rating_input.dart';

class WriteReviewScreen extends ConsumerStatefulWidget {
  final String serviceId;
  final String serviceName;

  const WriteReviewScreen({super.key, required this.serviceId, required this.serviceName});

  @override
  ConsumerState<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends ConsumerState<WriteReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();
  final _imageUrlController = TextEditingController();

  int _rating = 0;
  bool _isSubmitting = false;
  String? _ratingError;

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _ratingError = _rating == 0 ? 'Please select a rating.' : null);

    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid || _rating == 0) return;

    setState(() => _isSubmitting = true);

    await ref.read(allReviewsProvider.notifier).submitReview(
      serviceId: widget.serviceId,
      serviceName: widget.serviceName,
      userName: _nameController.text.trim(),
      rating: _rating,
      reviewText: _reviewController.text.trim(),
      imageUrl: _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you! Your review has been submitted.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Write a Review')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: AppColors.surfaceVariant,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Icon(Icons.confirmation_number_outlined, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(widget.serviceName, style: AppTextStyles.cardTitle),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Your Rating', style: AppTextStyles.sectionHeading, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            StarRatingInput(
              rating: _rating,
              onChanged: (value) => setState(() {
                _rating = value;
                _ratingError = null;
              }),
            ),
            if (_ratingError != null) ...[
              const SizedBox(height: 4),
              Text(
                _ratingError!,
                style: AppTextStyles.caption.copyWith(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Your Name', prefixIcon: Icon(Icons.person_outline)),
              validator: Validators.reviewerName,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _reviewController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Write your review',
                hintText: 'Share your experience...',
                alignLabelWithHint: true,
              ),
              validator: Validators.reviewText,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Image URL (optional)',
                prefixIcon: Icon(Icons.image_outlined),
                hintText: 'Paste a photo link from your trip',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
              child: _isSubmitting
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}
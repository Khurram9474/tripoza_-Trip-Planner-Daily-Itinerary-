enum TravelStyle { adventure, relaxation, family, cultural, luxury, budget }

enum BudgetLevel { low, medium, high }

class TravelPreference {
  final TravelStyle style;
  final BudgetLevel budget;
  final int durationDays;
  final String preferredCategory; // 'Hotels' | 'Tours' | 'Transportation' | 'Activities'
  final int travelers;

  const TravelPreference({
    required this.style,
    required this.budget,
    required this.durationDays,
    required this.preferredCategory,
    required this.travelers,
  });

  static const styleLabels = {
    TravelStyle.adventure: 'Adventure',
    TravelStyle.relaxation: 'Relaxation',
    TravelStyle.family: 'Family',
    TravelStyle.cultural: 'Cultural',
    TravelStyle.luxury: 'Luxury',
    TravelStyle.budget: 'Budget',
  };

  static const budgetLabels = {
    BudgetLevel.low: 'Low',
    BudgetLevel.medium: 'Medium',
    BudgetLevel.high: 'High',
  };

  /// Category each travel style is most associated with — used to boost
  /// matching scores even when the user's explicit category differs.
  static const styleToCategory = {
    TravelStyle.adventure: 'Activities',
    TravelStyle.relaxation: 'Hotels',
    TravelStyle.family: 'Tours',
    TravelStyle.cultural: 'Tours',
    TravelStyle.luxury: 'Hotels',
    TravelStyle.budget: 'Transportation',
  };
}
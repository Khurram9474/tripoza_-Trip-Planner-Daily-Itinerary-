import '../../services/models/travel_service_model.dart';
import 'models/recommendation_result.dart';
import 'models/travel_preference.dart';

class RecommendationEngine {
  RecommendationEngine._();

  static BudgetLevel _priceTier(double price) {
    if (price <= 6000) return BudgetLevel.low;
    if (price <= 15000) return BudgetLevel.medium;
    return BudgetLevel.high;
  }

  static List<RecommendationResult> generate({
    required TravelPreference preference,
    required List<TravelService> allServices,
  }) {
    final styleCategory = TravelPreference.styleToCategory[preference.style];
    final results = <RecommendationResult>[];

    for (final service in allServices) {
      if (!service.isAvailable) continue;

      var score = 0;
      final reasons = <String>[];

      if (service.category == preference.preferredCategory) {
        score += 2;
        reasons.add('Matches your preferred category (${preference.preferredCategory}).');
      }

      if (service.category == styleCategory) {
        score += 1;
        reasons.add('Fits a ${TravelPreference.styleLabels[preference.style]} travel style.');
      }

      if (_priceTier(service.price) == preference.budget) {
        score += 1;
        reasons.add('Within your ${TravelPreference.budgetLabels[preference.budget]!.toLowerCase()} budget range.');
      }

      if (score == 0) continue; // skip completely unrelated services

      final tier = score >= 3
          ? MatchTier.best
          : score == 2
          ? MatchTier.good
          : MatchTier.fair;

      results.add(RecommendationResult(service: service, score: score, tier: tier, reasons: reasons));
    }

    results.sort((a, b) => b.score.compareTo(a.score));
    return results;
  }
}
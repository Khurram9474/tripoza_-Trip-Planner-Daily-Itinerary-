import '../../../services/models/travel_service_model.dart';

enum MatchTier { best, good, fair }

class RecommendationResult {
  final TravelService service;
  final int score;
  final MatchTier tier;
  final List<String> reasons;

  const RecommendationResult({
    required this.service,
    required this.score,
    required this.tier,
    required this.reasons,
  });

  String get matchLabel => switch (tier) {
    MatchTier.best => 'Best Match',
    MatchTier.good => 'Good Match',
    MatchTier.fair => 'Fair Match',
  };

  int get matchPercent => switch (tier) {
    MatchTier.best => 95,
    MatchTier.good => 75,
    MatchTier.fair => 55,
  };
}
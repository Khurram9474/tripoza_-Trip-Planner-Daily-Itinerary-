import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/models/travel_service_model.dart';
import '../../data/models/chat_message.dart';

/// Predefined questions shown as tappable suggestions.
const List<String> assistantSuggestedQuestions = [
  'Where should I travel?',
  'What can I do there?',
  'What should I choose for a low budget?',
  'Which destination is suitable for families?',
];

final assistantMessagesProvider = StateNotifierProvider<AssistantNotifier, List<ChatMessage>>(
      (ref) => AssistantNotifier(),
);

class AssistantNotifier extends StateNotifier<List<ChatMessage>> {
  AssistantNotifier()
      : super([
    const ChatMessage(
      text: "Hi! I'm your Tripora travel assistant. Tap a question below and I'll help you plan.",
      isUser: false,
    ),
  ]);

  void askQuestion(String question, List<TravelService> allServices) {
    state = [...state, ChatMessage(text: question, isUser: true)];

    final answer = _generateAnswer(question, allServices);
    state = [...state, ChatMessage(text: answer, isUser: false)];
  }

  String _generateAnswer(String question, List<TravelService> services) {
    switch (question) {
      case 'Where should I travel?':
        final topRated = [...services]..sort((a, b) => b.rating.compareTo(a.rating));
        final picks = topRated.take(3).map((s) => s.location.split(',').first).toSet().take(3).join(', ');
        return 'Based on top-rated experiences right now, you might enjoy $picks. They consistently get great reviews from other travelers.';

      case 'What can I do there?':
        final activities = services.where((s) => s.category == 'Activities').take(3);
        if (activities.isEmpty) return "I don't have activity suggestions right now — check the Activities category in Travel Services.";
        final names = activities.map((a) => a.name).join(', ');
        return 'You could try: $names. All of these are bookable directly from the Travel Services section.';

      case 'What should I choose for a low budget?':
        final cheap = [...services]..sort((a, b) => a.price.compareTo(b.price));
        final pick = cheap.first;
        return '${pick.name} in ${pick.location} is one of the most affordable options at PKR ${pick.price.toStringAsFixed(0)} ${pick.priceUnit}. A great pick if you\'re watching your budget.';

      case 'Which destination is suitable for families?':
        final tours = services.where((s) => s.category == 'Tours');
        if (tours.isEmpty) return 'I don\'t have family-oriented suggestions right now — try browsing Tours in Travel Services.';
        final best = tours.reduce((a, b) => a.rating >= b.rating ? a : b);
        return '${best.name} in ${best.location} is well-suited for families — it\'s a guided experience with a rating of ${best.rating.toStringAsFixed(1)}, so you\'re in safe hands.';

      default:
        return "I'm not sure about that yet, but you can browse all services and use the preference form for personalized picks!";
    }
  } 
}
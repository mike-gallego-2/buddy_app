import 'package:buddy_app/services/openai_service.dart';

class BuddyRepository {
  Future<String> sendMessage(Map<int, String> prompt) async {
    final openAiService = OpenAiService();
    // convert the map to a string
    final promptString = prompt.values.join('\n');
    final response = await openAiService.create(prompt: promptString);
    return response;
  }

  String convertResponseToReadableText(String response) {
    final responseSection = response.split(':');
    final readableText = responseSection.last;
    return readableText;
  }
}

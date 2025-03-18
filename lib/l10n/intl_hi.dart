import 'dart:convert';
import 'dart:io';

void main() async {
  String jsonString = await File('localization.json').readAsString();
  Map<String, dynamic> localizedStrings = json.decode(jsonString);

  print(localizedStrings["title"]); // Outputs: स्वागत हे
  print(localizedStrings["message"]); // Outputs: नमस्ते, दुनिया!
}

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/character.dart';
import '../models/fortune.dart';

class FortuneService {
  static Future<List<Character>> getCharacters() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/characters.json',
    );
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    final List<dynamic> charactersJson = jsonData['characters'];
    return charactersJson.map((json) => Character.fromJson(json)).toList();
  }

  static Future<List<Fortune>> getFortunes() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/fortunes.json',
    );
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    final List<dynamic> fortunesJson = jsonData['fortunes'];
    return fortunesJson.map((json) => Fortune.fromJson(json)).toList();
  }

  static Future<Fortune> getRandomFortune() async {
    final fortunes = await getFortunes();
    fortunes.shuffle();
    return fortunes.first;
  }
}

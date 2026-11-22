import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/db/database.dart';

/// Extension point for AI question generation (ONLINE only).
///
/// The app never holds an AI provider key. It calls YOUR server (for example
/// a Supabase Edge Function), which holds the key, reads the supplied
/// textbook text, and returns a question pack in the format described in
/// docs/QUESTION_PACK_FORMAT.md. The pack is then imported with
/// `LibraryRepo.importPack(book, json, source: 'ai')`, which stores the
/// questions as unverified so a teacher can review them.
///
/// NOT YET WIRED INTO THE UI and not tested against a real server.
abstract class QuestionGenerator {
  Future<String> generatePack({
    required Textbook book,
    required Chapter chapter,
    Topic? topic,
    required String sourceText,
    required int count,
    String type = 'mcq',
  });
}

class RemoteQuestionGenerator implements QuestionGenerator {
  /// e.g. https://<project>.functions.supabase.co/generate-questions
  final Uri endpoint;

  /// The signed-in user's access token (never a provider secret).
  final String? userToken;
  RemoteQuestionGenerator(this.endpoint, {this.userToken});

  @override
  Future<String> generatePack({
    required Textbook book,
    required Chapter chapter,
    Topic? topic,
    required String sourceText,
    required int count,
    String type = 'mcq',
  }) async {
    final r = await http
        .post(endpoint,
            headers: {
              'content-type': 'application/json',
              if (userToken != null) 'authorization': 'Bearer $userToken',
            },
            body: jsonEncode({
              'grade': book.grade,
              'subject': book.subject,
              'language': book.language,
              'bookTitle': book.title,
              'chapterNumber': chapter.number,
              'chapterTitle': chapter.title,
              'topicTitle': topic?.title,
              'sourceText': sourceText,
              'count': count,
              'type': type,
            }))
        .timeout(const Duration(seconds: 120));
    if (r.statusCode != 200) {
      throw StateError('Question server error ${r.statusCode}');
    }
    return utf8.decode(r.bodyBytes);
  }
}

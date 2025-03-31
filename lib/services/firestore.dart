import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_navigation_drawer/constants/firestore.dart';
import 'package:flutter_navigation_drawer/models/feedback.dart';

class Firestore {
  Firestore._();

  static final Firestore instance = Firestore._();

  Future<List<FeedbackModel>> getAllFeedbacks() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(FirestoreConstants.feedbackCollection)
          .get();
      List<FeedbackModel> models = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .map((data) => FeedbackModel.fromJson(data))
          .toList();
      models.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );

      List<String> userIds = models.map((model) => model.userId).toList();
      List<String> uniqueUserIds = userIds.toSet().toList();

      Map<String, String> userNamesMap = await FirebaseFirestore.instance
          .collection(FirestoreConstants.executivesCollection)
          .get()
          .then((snapshot) {
        return Map.fromEntries(
          snapshot.docs
              .where((doc) => uniqueUserIds.contains(doc.id))
              .map((doc) => MapEntry(doc.id, doc.data()['name'] as String)),
        );
      });

      for (final model in models) {
        model.userName = userNamesMap[model.userId] ?? 'Unknown User';
      }
      return models;
    } catch (e) {
      log("Error fetching data: $e");
      return [];
    }
  }
}

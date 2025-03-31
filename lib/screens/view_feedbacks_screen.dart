import 'package:flutter/material.dart';
import 'package:flutter_navigation_drawer/services/firestore.dart';
import '../models/feedback.dart';

class ViewFeedbacksScreen extends StatelessWidget {
  const ViewFeedbacksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback List'),
      ),
      body: FutureBuilder<List<FeedbackModel>>(
        future: Firestore.instance.getAllFeedbacks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No feedbacks available'));
          }

          final feedbacks = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final feedback = feedbacks[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Loan Number', feedback.loanNumber),
                      _buildInfoRow(
                          'Executive Name', feedback.userName ?? 'Unknown'),
                      _buildInfoRow('Reason', feedback.reason),
                      _buildInfoRow('Message', feedback.message),
                      _buildInfoRow('User ID', feedback.userId),
                      _buildInfoRow('Date', _formatDate(feedback.createdAt)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}

import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String leftLabel;
  final String rightLabel;
  final String leftScore;
  final String rightScore;
  final VoidCallback? onTap;

  const ScoreCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.leftLabel,
    required this.rightLabel,
    required this.leftScore,
    required this.rightScore,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).cardColor;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height : 4),
                      Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  Icon(Icons.more_vert, color: Colors.grey[600]),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TeamScore(label: leftLabel, score: leftScore),
                  _TeamScore(label: rightLabel, score: rightScore),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamScore extends StatelessWidget {
  final String label;
  final String score;
  const _TeamScore({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary)),
        SizedBox(height: 6),
        Text(score, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/score_card.dart';

class MatchDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScoreCard(
                title: 'India vs Australia',
                subtitle: 'T20 • Eden Gardens',
                leftLabel: 'IND',
                rightLabel: 'AUS',
                leftScore: '178/6 (20 ov)',
                rightScore: 'Chasing',
              ),

              SizedBox(height: 8),
              Text('Live Summary', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 8),

              Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Score', style: TextStyle(fontWeight: FontWeight.w700)),
                          Text('Overs', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _PlayerStat(name: 'Rohit Sharma', stat: '46 (32)')),
                          Expanded(child: _PlayerStat(name: 'Virat Kohli', stat: '58 (40)')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12),
              Text('Bowling', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 8),
              Card(
                child: Column(
                  children: List.generate(3, (i) => ListTile(
                    leading: CircleAvatar(child: Text('B${i+1}')),
                    title: Text('Bowler ${i+1}'),
                    subtitle: Text('2-0-18-1'),
                    trailing: Icon(Icons.more_horiz),
                  )),
                ),
              ),

              SizedBox(height: 12),
              Text('Match Actions', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: ElevatedButton.icon(onPressed: () => Navigator.pushNamed(context, '/score-input'), icon: Icon(Icons.edit), label: Text('Update Score'))),
                  SizedBox(width: 8),
                  Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: Icon(Icons.insert_chart_outlined), label: Text('Stats'))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerStat extends StatelessWidget {
  final String name;
  final String stat;
  const _PlayerStat({required this.name, required this.stat});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 6),
        Text(stat, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }
}

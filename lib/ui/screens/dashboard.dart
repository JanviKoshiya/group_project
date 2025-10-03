import 'package:flutter/material.dart';
import '../widgets/score_card.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Score'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Today', style: Theme.of(context).textTheme.titleMedium),
              ),

              // Live match card
              ScoreCard(
                title: 'India vs Australia',
                subtitle: 'T20 • Final • Eden Gardens',
                leftLabel: 'IND',
                rightLabel: 'AUS',
                leftScore: '178/6',
                rightScore: '3.4 ov',
                onTap: () => Navigator.pushNamed(context, '/match'),
              ),

              // Quick actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _QuickAction(
                        icon: Icons.add_circle_outline,
                        label: 'Start Match',
                        onTap: () => Navigator.pushNamed(context, '/score-input')),
                    _QuickAction(
                        icon: Icons.show_chart,
                        label: 'Stats',
                        onTap: () {}),
                    _QuickAction(
                        icon: Icons.history,
                        label: 'History',
                        onTap: () {}),
                  ],
                ),
              ),

              // Recent matches list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text('Recent Matches', style: Theme.of(context).textTheme.titleMedium),
              ),
              ...List.generate(3, (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    leading: CircleAvatar(child: Text('M${i+1}')),
                    title: Text('Match ${i+1} — Local Cup'),
                    subtitle: Text('HT 142/8 • 20 ov'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, '/match'),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 6),
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
              SizedBox(height: 8),
              Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

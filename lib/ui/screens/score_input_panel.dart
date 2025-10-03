import 'package:flutter/material.dart';

class ScoreInputPanelScreen extends StatefulWidget {
	@override
	_ScoreInputPanelScreenState createState() => _ScoreInputPanelScreenState();
}

class _ScoreInputPanelScreenState extends State<ScoreInputPanelScreen> with SingleTickerProviderStateMixin {
	int runs = 0;
	int total = 178;
	String lastEvent = '';
	late AnimationController _tapController;

	@override
	void initState() {
		super.initState();
		_tapController = AnimationController(vsync: this, duration: Duration(milliseconds: 180));
	}

	@override
	void dispose() {
		_tapController.dispose();
		super.dispose();
	}

	void addRuns(int r) {
		setState(() {
			runs = r;
			total += r;
			lastEvent = '+$r';
		});
		_tapController.forward(from: 0);
	}

	void addWicket() {
		setState(() {
			lastEvent = 'W';
		});
		_tapController.forward(from: 0);
	}

	void addExtra(String type) {
		setState(() {
			lastEvent = type;
			total += 1;
		});
		_tapController.forward(from: 0);
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		return Scaffold(
			appBar: AppBar(title: Text('Score Input')),
			body: SafeArea(
				child: Column(
					children: [
						Padding(
							padding: const EdgeInsets.all(12.0),
							child: Row(
								children: [
									Expanded(
										child: Card(
											child: Padding(
												padding: const EdgeInsets.all(16.0),
												child: Column(
													crossAxisAlignment: CrossAxisAlignment.start,
													children: [
														Text('Current Score', style: theme.textTheme.titleMedium),
														SizedBox(height: 8),
														Row(
															crossAxisAlignment: CrossAxisAlignment.end,
															children: [
																Text('$total', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
																SizedBox(width: 8),
																Text(' / 6', style: TextStyle(color: Colors.grey)),
															],
														),
														SizedBox(height: 8),
														Text('Last: $lastEvent', style: TextStyle(color: Colors.grey[600])),
													],
												),
											),
										),
									),
								],
							),
						),

						// Scoring buttons
						Padding(
							padding: const EdgeInsets.symmetric(horizontal: 12.0),
							child: Wrap(
								spacing: 10,
								runSpacing: 10,
								alignment: WrapAlignment.center,
								children: [
									_ScoreButton(label: '0', color: theme.colorScheme.surface, onTap: () => addRuns(0)),
									_ScoreButton(label: '1', color: theme.colorScheme.primary, onTap: () => addRuns(1)),
									_ScoreButton(label: '2', color: theme.colorScheme.primary, onTap: () => addRuns(2)),
									_ScoreButton(label: '3', color: theme.colorScheme.primary, onTap: () => addRuns(3)),
									_ScoreButton(label: '4', color: Colors.green, onTap: () => addRuns(4)),
									_ScoreButton(label: '6', color: Colors.orange, onTap: () => addRuns(6)),
									_ScoreButton(label: 'W', color: Colors.redAccent, onTap: addWicket),
									_ScoreButton(label: 'NB', color: theme.colorScheme.secondary, onTap: () => addExtra('NB')),
									_ScoreButton(label: 'WD', color: theme.colorScheme.secondary, onTap: () => addExtra('WD')),
								],
							),
						),

						Spacer(),
						Padding(
							padding: const EdgeInsets.all(12.0),
							child: Row(
								children: [
									Expanded(child: OutlinedButton(onPressed: () {}, child: Text('Undo'))),
									SizedBox(width: 8),
									Expanded(child: ElevatedButton(onPressed: () {}, child: Text('Save'))),
								],
							),
						)
					],
				),
			),
		);
	}
}

class _ScoreButton extends StatelessWidget {
	final String label;
	final Color color;
	final VoidCallback onTap;
	const _ScoreButton({required this.label, required this.color, required this.onTap});

	@override
	Widget build(BuildContext context) {
		return Material(
			color: color,
			borderRadius: BorderRadius.circular(10),
			child: InkWell(
				onTap: onTap,
				borderRadius: BorderRadius.circular(10),
				child: Container(
					width: 84,
					height: 56,
					alignment: Alignment.center,
					child: Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
				),
			),
		);
	}
}


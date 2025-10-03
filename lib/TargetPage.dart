import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoring_app/data/local/db_helper.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';


class TargetPage extends StatefulWidget {
  TargetPage({super.key});

  @override
  State<TargetPage> createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  List<Map<String, dynamic>> allData = [];
  DBHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getScorecard();
  }

  void getScorecard() async {
    try {
      allData = await dbRef!.getFullScorecard();
      print("Fetched data: $allData"); // Debugging to ensure data is fetched
      setState(() {}); // Update the UI
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Show Score"),
      ),
      body: allData.isNotEmpty
          ? GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Adjust based on screen width
          childAspectRatio: 2.5, // Adjust for row aspect ratio
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        padding: const EdgeInsets.all(8),
        itemCount: allData.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("S. No: ${allData[index][DBHelper.COLUMN_SNO]}"),
                Text("Name: ${allData[index][DBHelper.COLUMN_NAME]}"),
                Text("Runs: ${allData[index][DBHelper.COLUMN_RUN]}"),
                Text("Balls: ${allData[index][DBHelper.COLUMN_BALL]}"),
                Text("Fours: ${allData[index][DBHelper.COLUMN_FOURS]}"),
                Text("Sixes: ${allData[index][DBHelper.COLUMN_SIXS]}"),
                Text("SR: ${allData[index][DBHelper.COLUMN_STRICKRATE]}"),
              ],
            ),
          );
        },
      )
          : Center(
        child: Text('No Data Found'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Add a player and refresh the scorecard
            bool check = await dbRef!.addPlayers(
              Name: 'Pratik',
              Run: 25,
              Ball: 25,
              Four: 3,
              Six: 0,
              SR: 100,
            );
            print("Data added successfully: $check"); // Debugging to ensure data is added

            if (check) {
              getScorecard(); // Refresh the scorecard
            }
          } catch (e) {
            print("Error adding data: $e");
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

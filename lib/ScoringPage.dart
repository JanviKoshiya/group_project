import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoring_app/MainPage.dart';

class Scoringpage extends StatefulWidget {

  final HomeTeam;
  final VisitorTeam;
  final TotalOver;
  String GroupValue;
  String NoneGroupValue;
  String TossValue;
  int Inning;
  int TotalRuns = 0;

  Scoringpage(this.HomeTeam,this.VisitorTeam,this.TotalOver,this.GroupValue,this.NoneGroupValue,this.TossValue,this.Inning,this.TotalRuns,{super.key}) {

    // TODO: implement Scoringpage
    print('$HomeTeam , $VisitorTeam ,$TotalOver, $GroupValue');
    //print('$TotalRuns');
  }

  @override
  State<Scoringpage> createState() => _ScoringpageState();
}

class _ScoringpageState extends State<Scoringpage> {

  var StrikerController = TextEditingController();
  var NonStrikerController = TextEditingController();
  var BowlerContoller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text('${widget.Inning} Innings Opening players ${widget.TotalRuns}'),
      ),

      body: Column(
        children: [
          Container(
            height: 42,
            alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Striker',style: TextStyle(fontSize: 22,color: Colors.deepPurple,fontWeight: FontWeight.w700),),
              ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: StrikerController,
              decoration: InputDecoration(
                hintText: 'Striker Batsman Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
          ),

          SizedBox(height: 11,),

          Container(
            height: 42,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Non-Striker',style: TextStyle(fontSize: 22,color: Colors.deepPurple,fontWeight: FontWeight.w700),),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: NonStrikerController,
              decoration: InputDecoration(
                hintText: 'Non-Striker Batsman Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
          ),

          SizedBox(height: 11,),

          Container(
            height: 42,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Bowler Name',style: TextStyle(fontSize: 22,color: Colors.deepPurple,fontWeight: FontWeight.w700),),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: BowlerContoller,
              decoration: InputDecoration(
                hintText: 'Bowler Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
          ),

          SizedBox(height: 20,),

          Container(
            color: Colors.deepPurple,
            padding: EdgeInsets.all(8.0),
            child: OutlinedButton(onPressed: (){

              if (StrikerController.text.isEmpty ||
                  NonStrikerController.text.isEmpty ||
                  BowlerContoller.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Fill Empty Data"),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(
                      StrikerController.text.toString(),
                      NonStrikerController.text,
                      BowlerContoller.text,
                      widget.HomeTeam,
                      widget.VisitorTeam,
                      widget.TotalOver,
                      widget.GroupValue,
                      widget.NoneGroupValue,
                      widget.TossValue,
                      widget.Inning,
                      widget.TotalRuns
                    ),
                  ),
                );
              }
            },
              child: Text('Start Match',
                  style: TextStyle(
                      fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500)),
          ),
          ),
        ],
      ),
    );
  }
}



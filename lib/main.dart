import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scoring_app/splash_page.dart';
import 'package:scoring_app/ui/screens/dashboard.dart';
import 'package:scoring_app/ui/screens/match_details.dart';
import 'package:scoring_app/ui/screens/score_input_panel.dart';
import 'package:scoring_app/ui/theme.dart';

import 'ScoringPage.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FlutterApp());
}



class FlutterApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Flutter ",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: splash_page(),
      routes: {
        '/dashboard': (_) => DashboardScreen(),
        '/match': (_) => MatchDetailsScreen(),
        '/score-input': (_) => ScoreInputPanelScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var HomeTeamController = TextEditingController();
  var VisitorTeamController = TextEditingController();
  var OversController = TextEditingController();

  String HTName ='';
  String VTName ='';
  String groupValue = 'Home Team';
  String NoneGroupValue = '';
  String TossResult = "Bat";
  int Inning = 1;
  int TotalRuns = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Scoring App '),
      ),
      body: Column(
        children: [
          Container(
              height: 42,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: Text('Teams',style: TextStyle(fontSize: 22,color: Colors.deepPurple,fontWeight: FontWeight.w700,),),
              )
          ),

          SizedBox(height: 11),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value){
                setState(() {
                  HTName = value;
                  print('$HTName');
                });
              },
              controller: HomeTeamController,
              decoration: InputDecoration(
                  hintText: 'Home Team',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                filled: true,
              ),
            ),
          ),

          SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value){
                setState(() {
                  VTName = value;
                  print('$VTName');
                });
              },
              controller: VisitorTeamController,
              decoration: InputDecoration(
                  hintText: 'Visitor Team',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                filled: true,
              ),
            ),
          ),

          SizedBox(height: 11),

          Container(
            height: 42,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Toss Won by ?',style: TextStyle(fontSize: 22,color: Colors.deepPurple,fontWeight: FontWeight.w700,),),
              )
          ),

          SizedBox(height: 11),

          Row(
            children: [
              Radio(
                  value: HTName,
                  groupValue: groupValue,
                  onChanged: (value){
                      setState(() {
                        groupValue = value!;
                      });
                  }),
              Text(HTName.isEmpty?'Home Team':HTName),

              SizedBox(width: 11,),

              Radio(
                  value: VTName,
                  groupValue: groupValue,
                  onChanged: (value){
                    setState(() {
                      groupValue = value!;
                    });
                  }),
              Text(VTName.isEmpty?'Visitor Team':VTName),
            ],
          ),

          SizedBox(height: 11),

          Container(
            height: 42,
            alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Selected to',style: TextStyle(fontSize: 22,color: Colors.deepPurple,fontWeight: FontWeight.w700,),),
              )
          ),

          Row(
            children: [
              Radio(
                  value: "Bat",
                  groupValue: TossResult,
                  onChanged: (value){
                    setState(() {
                      TossResult = value!;
                    });
                  }),
              Text('Bat'),
              
              //Radio(value: value, groupValue: , onChanged: onChanged)
              
              Radio(
                  value: "Ball",
                  groupValue: TossResult,
                  onChanged: (value){
                    setState(() {
                      TossResult = value!;
                    });
                  }),
              Text('Ball'),
            ],
          ),

          SizedBox(height: 11,),

          Container(
            height: 42,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Overs',style: TextStyle(fontSize: 22,color: Colors.deepPurple,fontWeight: FontWeight.w700),),
              ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: OversController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'How many Overs do you want to play',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                filled: true,
              ),
            ),
          ),

          SizedBox(height: 20),
          
          Container(
              color: Colors.deepPurple,
              padding: EdgeInsets.all(8.0),
              child: OutlinedButton(onPressed: (){

                if (HomeTeamController.text.isEmpty || VisitorTeamController.text.isEmpty || OversController.text.isEmpty)
                {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Fill Empty Data"),
                  ));
                }
                else
                {
                  print('$groupValue  ----------- $HTName');
                  if(groupValue == HTName.toString()  )
                  {
                    print('$groupValue  ----------- $HTName ---------- $TossResult');
                    if (TossResult == "Bat")
                    {
                      groupValue = VTName;
                      NoneGroupValue = HTName;
                    }
                    else
                    {
                      groupValue = HTName;
                      NoneGroupValue = VTName;
                    }
                  }
                  if(groupValue == VTName)
                  {
                    if(TossResult== "Bat")
                    {
                      groupValue = HTName;
                      NoneGroupValue = VTName;
                    }
                    else
                    {
                      groupValue = VTName;
                      NoneGroupValue = HTName;
                      //TossResult = "Bat";
                    }
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Scoringpage(this.HomeTeamController.text,this.VisitorTeamController.text,this.OversController.text,this.groupValue,this.NoneGroupValue,this.TossResult,this.Inning,this.TotalRuns)),);
                }
                }
              , child: Text('Start Match',style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.w500),),),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoring_app/OverPage.dart';
import 'package:scoring_app/ScoringPage.dart';
import 'package:scoring_app/TargetPage.dart';
import 'package:scoring_app/data/local/db_helper.dart';

import 'WicketPage.dart';

class MainPage extends StatefulWidget {
  String SBName;
  String NBName;
  String BName;
  String HomeTeam;
  String VisitorTeam;
  String TotalOver;
  String GroupValue;
  String NoneGroupValue;
  String TossValue;
  int Inning;
  int TotalRuns = 0;

  MainPage(this.SBName,this.NBName,this.BName,this.HomeTeam,this.VisitorTeam,this.TotalOver,this.GroupValue,this.NoneGroupValue,this.TossValue,this.Inning,this.TotalRuns,{super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  //bool isChecked = false;
  bool Wide = false;
  bool NoBall = false;
  bool Byes = false;
  bool LagByes = false;
  bool Wicket = false;

  int Runs=0;
  int Wickets = 0;

  double Overs = 0.0;

  List<int> ballsInOver = [];
  int currentOver = 1;
  int currentBall = 0;

  // Over Logic
  void addBallToOver(int ballType)
  {
    setState(() {
      ballsInOver.add(ballType);
      if(Wide){
        extraRuns(ballType);
      }
      else
      {
        if(NoBall){
          noBallExtraRuns(ballType);
        }
        else{
          currentBall++;
          if(currentBall == 6){
            currentBall = 0;
            currentOver++ ;
            ballsInOver = [];

            Navigator.push(context, MaterialPageRoute(builder: (context) => OverPage(widget.BName ),),).then((value){
              setState(() {
                widget.BName = value;
                if(Striker == 1){
                  Striker = 0;
                }
                else{
                  Striker = 1;
                }
              });
            }
            );
          }
        }
      }
    });
  }

  // batsman run and ball
  int SBRuns = 0;
  int SBBalls = 0;
  int NBRuns = 0;
  int NBBalls = 0;
  int Striker = 1;
  //late int NonStriker;
  int StrikerFours = 0;
  int StrikerSix = 0;
  int NonStrikerFours =0 ;
  int NonStrikerSix = 0;
  double SBSR = 0;
  double NBSR = 0;

  //int NonStriker = 2;
  void batsmanRunsAndBalls(int run)
  {
      //int TotalRuns = Runs+1;
      if(Wickets>=9)
      {
        widget.TotalRuns = Runs+1;
        if(widget.Inning == 2)
        {
          if(Runs > widget.TotalRuns)
          {
            Get.defaultDialog(
              title: '${widget.GroupValue} is Winner Runs Chas Successfully...',
              content: TextButton(onPressed: (){
                //Get.to(TargetPage());
              },child: Text('Done'),),
            );
          }
          else
          {
            Get.defaultDialog(
              title: '${widget.NoneGroupValue} is Winner Runs Chas Not Successfully...',
              content: TextButton(onPressed: (){
                //Get.to(TargetPage());
              },child: Text('Done'),),
            );
          }
        }
        else
        {
          Get.defaultDialog(
            title:'${widget.TotalRuns} Runs to Win',
            titlePadding: EdgeInsets.only(top: 11),
            //contentPadding: EdgeInsets.all(11),
            middleText: 'Runs to Win',
            content: TextButton(onPressed: (){
              widget.Inning = 2;
              Get.to(Scoringpage(widget.HomeTeam, widget.VisitorTeam,widget.TotalOver,widget.GroupValue,widget.NoneGroupValue,widget.TossValue,widget.Inning,widget.TotalRuns));
            },
              child: Text('Done'),),
          );
        }

      }
      else{
        if(Striker == 1){

          if(Wicket){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WicketPage(widget.SBName, text: null,),),).then((value){
              setState(() {
                widget.SBName = value;
                Wickets++;
                SBRuns = 0;
                SBBalls = 0;
                StrikerFours = 0;
                StrikerSix = 0;
                SBSR = 0;
                
              });
            });
          }

          if(Byes==false){
            if(LagByes==false){
              if(run == 4){
                StrikerFours++;
              }
              if(run == 6){
                StrikerSix++;
              }
              SBRuns =SBRuns + run;
              SBBalls++;
              SBSR= (SBRuns/SBBalls)*100; // Strike Rate
              //SBSR.toStringAsFixed(2);
              if(run%2 != 0){
                Striker=0;
              }
            }
            else{                               //LagByes
              SBBalls++;
              if(run%2 != 0){
                Striker=0;
              }
            }
          }
          else                         // Byes
              {
            SBBalls++;
            if(run%2 != 0){
              Striker=0;
            }
          }
        }
        else
        {
          if(Wicket){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WicketPage(widget.NBName, text: null,),),).then((value){
              setState(() {
                widget.NBName = value;
                Wickets++;
                NBRuns = 0;
                NBBalls = 0;
                NonStrikerFours = 0;
                NonStrikerSix = 0;
                NBSR = 0;
              });
            });
          }

          if(Byes == false){
            if(LagByes==false){
              if(run == 4){
                NonStrikerFours++;
              }
              if(run == 6){
                NonStrikerSix++;
              }
              NBRuns = NBRuns + run;
              NBBalls++;
              NBSR=(NBRuns/NBBalls)*100;
              //NBSR.toStringAsFixed(2);
              if(run%2 != 0){
                Striker=1;
              }
            }
            else{                          // LagByes
              NBBalls++;
              if(run%2 != 0){
                Striker=1;
              }
            }
          }
          else{
            NBBalls++;
            if(run%2 != 0){
              Striker=1;
            }
          }
        }
      }
    }



  // Over increment
  int overs=0;
  int balls=0;
  void totalOver(int run) {
    if(run == 0 || run == 1 || run == 2 || run == 3 || run == 4 || run == 5 || run == 6) {
      setState(() {
        //double TotalOvers = double.parse(widget.TotalOver);
        if(widget.Inning == 2){
          if (Runs >= widget.TotalRuns) {
            Get.defaultDialog(
              title: '${widget.GroupValue} is Winner Runs Chas Successfully...',
              content: TextButton(onPressed: () {
                //Get.to(TargetPage());
              }, child: Text('Done'),),
            );
          }
        }
        
        if(Wide)
        {

        }
        else
        {
          if(NoBall)
          {

          }
          else{
            balls++;
            if(balls == 6)
            {
              balls++;
              overs++;
              balls = 0;
              double TotalOvers = double.parse(widget.TotalOver);
              //TotalRuns = Runs+1;
              if(TotalOvers == overs)
              {
                widget.TotalRuns = Runs+1;
                Get.defaultDialog(
                  title:'${widget.TotalRuns} Runs to Win',
                  titlePadding: EdgeInsets.only(top: 11),
                  //contentPadding: EdgeInsets.all(11),
                  middleText: 'Runs to Win',
                  content: TextButton(onPressed: (){
                    widget.Inning = 2;
                    Get.to(Scoringpage(widget.HomeTeam, widget.VisitorTeam,widget.TotalOver,widget.GroupValue,widget.NoneGroupValue,widget.TossValue,widget.Inning,widget.TotalRuns));
                  },
                    child: Text('Done'),),
                );
              }

              if(widget.Inning == 2) {

                if (TotalOvers == overs && Runs < widget.TotalRuns) {
                  Get.defaultDialog(
                    title: '${widget.GroupValue} is Winner Runs Chas Not Successfully...',
                    content: TextButton(onPressed: () {
                      //Get.to(TargetPage());
                    }, child: Text('Done'),),
                  );
                }
              }
              //
            }
          }
        }
      });
    }
  }
  // Extra Runs

  void extraRuns(int run){
    if(Wide == true && run == 0 || run == 1 || run == 2 || run == 3 || run == 4 || run == 5 || run == 6){
      setState(() {
        if(Striker == 1){
          if(run%2 != 0){
            Striker=0;
          }
        }
        if(Striker != 1){
          if(run%2 != 0){
            Striker=1;
          }
        }
        Runs++;
      });
    }
  }

  void noBallExtraRuns(int run){
    if(NoBall == true && run == 0 || run == 1 || run == 2 || run == 3 || run == 4 || run == 5 || run == 6){
      setState(() {
        Runs++;
      });
    }
  }

  // Balls Logic

  // 0 Run



  void zeroRun(int run){
    setState(() {
      Runs +=0;
      addBallToOver(run);
    });
  }

  // 1 Run

  void oneRun(int run){
    setState(() {
      Runs +=1;
      print('${run}');
      addBallToOver(run);

    });
  }

  // 2 Runs

  void twoRun(int run){
    setState(() {
      Runs +=2;
      addBallToOver(run);


    });
  }

  // 3 Runs

  void threeRun(int run){
    setState(() {
      Runs +=3;
      addBallToOver(run);
    });
  }

  // 4 Runs

  void fourRun(int run){
    setState(() {
      Runs +=4;
      addBallToOver(run);
    });
  }

  // 5 Runs

  void fiveRun(int run){
    setState(() {
      Runs +=5;
      addBallToOver(run);
    });
  }

  // 6 Runs

  void sixRun(int run){
    setState(() {
      Runs +=6;
      addBallToOver(run);
    });
  }

  @override
  Widget build(BuildContext context) {

    DBHelper db = DBHelper.getInstance;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.Inning} Inning Scoring ${widget.GroupValue}  ${widget.TossValue}'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('$Runs - $Wickets',style: TextStyle(fontSize: 42,fontWeight: FontWeight.w700,color: Colors.black),),
                    SizedBox(width: 4,),
                    Text('( $overs . $balls )',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700,color: Colors.black),)
                  ],
                ),
              ),
              width: double.infinity,
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Batsman'),
                          ),
                      ),
            
                      Expanded(
                          flex: 1,
                          child: Text('R'),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('B'),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('4s'),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('6s'),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('SR'),
                      ),
                    ],
                  ),
            
                  Divider(),
                  //SizedBox(height: 2,)
            
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex : 5,
                            child: Text('${widget.SBName}',style: TextStyle(color: Colors.black),),
                        ),
            
                        Expanded(
                            flex: 1,
                            child: Text('${SBRuns}',style: TextStyle(color: Colors.black,fontSize: 14),),
                        ),
            
                        Expanded(
                          flex: 1,
                          child: Text('${SBBalls}',style: TextStyle(color: Colors.black,fontSize: 14),),
                        ),
            
                        Expanded(
                          flex: 1,
                          child: Text('${StrikerFours}',style: TextStyle(color: Colors.black,fontSize: 14),),
                        ),
            
                        Expanded(
                          flex: 1,
                          child: Text('${StrikerSix}',style: TextStyle(color: Colors.black,fontSize: 14),),
                        ),
            
                        Expanded(
                          flex: 1,
                          child: Text('${SBSR.toStringAsFixed(2)}',style: TextStyle(color: Colors.black,fontSize: 14),),
                        ),
                      ],
                    ),
                  ),
            
                  Row(
                    children: [
                      Expanded(
                        flex : 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${widget.NBName}',style: TextStyle(color: Colors.black,),),
                        ),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('${NBRuns}',style: TextStyle(color: Colors.black,fontSize: 14),),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('${NBBalls}',style: TextStyle(color: Colors.black,fontSize: 14),),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('${NonStrikerFours}',style: TextStyle(color: Colors.black,fontSize: 14),),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('${NonStrikerSix}',style: TextStyle(color: Colors.black,fontSize: 14),),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('${NBSR.toStringAsFixed(2)}',style: TextStyle(color: Colors.black,fontSize: 14),),
                      ),
                    ],
                  ),
            
                  /*
                  Row(
                    children: [
                      Expanded(
                        flex : 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Bowler',style: TextStyle(color: Colors.black,fontSize: 14,),),
                        ),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('O',style: TextStyle(color: Colors.black,fontSize: 14),),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('M',style: TextStyle(color: Colors.black,fontSize: 14),),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('R',style: TextStyle(color: Colors.black,fontSize: 14),),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('W',style: TextStyle(color: Colors.black,fontSize: 14),),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('ER',style: TextStyle(color: Colors.black,fontSize: 14),),
                      ),
                    ],
                  ),
                 */
                  Divider(),
                  /*
                  Row(
                    children: [
                      Expanded(
                        flex : 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${widget.BName}',style: TextStyle(color: Colors.black,),),
                        ),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('',style: TextStyle(color: Colors.black,fontSize: 14),),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('',style: TextStyle(color: Colors.black,fontSize: 14),),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('',style: TextStyle(color: Colors.black,fontSize: 14),),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('',style: TextStyle(color: Colors.black,fontSize: 14),),
                      ),
            
                      Expanded(
                        flex: 1,
                        child: Text('',style: TextStyle(color: Colors.black,fontSize: 14),),
                      ),
                    ],
                  ),
                  */
                ],
              ),
            
            
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${widget.BName} This Over :',style: TextStyle(color: Colors.black,fontSize: 14)),
                  ),
                  SizedBox(width: 20,),
                  Text('${ballsInOver.join('   ')}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                ],
              ),

            ),
          ),
          Expanded(
              flex: 2,
              child: Container(
              width: double.infinity,

              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Expanded(
                          flex: 4,
                          child: Checkbox(
                            value: Wide,
                            onChanged: (bool? value) {
                              setState(() {
                                Wide = value ?? false;
                                print('${Wide}');
                              });
                            },
                          ),
                        ),
                      ),
                      const Text('Wide',style: TextStyle(color: Colors.black,fontSize: 16),),

                      SizedBox(width: 10,),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Expanded(
                          flex: 4,
                          child: Checkbox(
                            value: NoBall,
                            onChanged: (bool? value) {
                              setState(() {
                                NoBall = value ?? false;
                              });
                            },
                          ),
                        ),
                      ),
                      const Text('No Ball',style: TextStyle(color: Colors.black,fontSize: 16)),

                      SizedBox(width: 10,),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Expanded(
                          flex: 4,
                          child: Checkbox(
                            value: Byes,
                            onChanged: (bool? value) {
                              setState(() {
                                Byes = value ?? false;
                              });
                            },
                          ),
                        ),
                      ),
                      const Text('Byes',style: TextStyle(color: Colors.black,fontSize: 16)),

                      SizedBox(width: 10,),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Expanded(
                          flex: 4,
                          child: Checkbox(
                            value: LagByes,
                            onChanged: (bool? value) {
                              setState(() {
                                LagByes = value ?? false;
                              });
                            },
                          ),
                        ),
                      ),
                      const Text('Leg Byes',style: TextStyle(color: Colors.black,fontSize: 16)),
                    ],
                  ),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Expanded(
                          flex: 4,
                          child: Checkbox(
                            value: Wicket,
                            onChanged: (bool? value) {
                              setState(() {
                                Wicket = value ?? false;
                              });
                            },
                          ),
                        ),
                      ),
                      const Text('Wicket',style: TextStyle(color: Colors.black,fontSize: 16)),

                      SizedBox(width: 30,),

                      ElevatedButton(onPressed: (){}, child: Text('Retire',style: TextStyle(color: Colors.black,fontSize: 16),),),

                      SizedBox(width: 10,),

                      ElevatedButton(onPressed: (){
                        if(Striker == 1){
                          Striker = 0;
                        }
                        else{
                          Striker = 1;
                        }
                      }, child: Text('Swap Batsman',style: TextStyle(color: Colors.black,fontSize: 16),),),
                    ],
                  ),
                ],
              ),
          ),
          ),
          Expanded(
              flex: 3,
              child: Container(
              width: double.infinity,

              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(onPressed: (){}, child: Text('Undo',style: TextStyle(color: Colors.black,fontSize: 16),),),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(onPressed: (){}, child: Text('Partnership',style: TextStyle(color: Colors.black,fontSize: 16),),),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(onPressed: (){}, child: Text('Extra',style: TextStyle(color: Colors.black,fontSize: 16),),),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 7,
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ElevatedButton(onPressed: (){
                                  zeroRun(0);
                                  totalOver(0);
                                  if(Wide){

                                  }
                                  else{
                                    batsmanRunsAndBalls(0);
                                  }


                                }, child: Text('0',style: TextStyle(fontSize: 28,fontWeight: FontWeight.w500),),
                                style: ElevatedButton.styleFrom(shape: CircleBorder()),),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ElevatedButton(onPressed: (){
                                  oneRun(1);
                                  totalOver(1);
                                  if(Wide){

                                  }
                                  else{
                                      batsmanRunsAndBalls(1);
                                  }

                                }, child: Text('1',style: TextStyle(fontSize: 28,fontWeight: FontWeight.w500),),
                                  style: ElevatedButton.styleFrom(shape: CircleBorder()),),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ElevatedButton(onPressed: (){
                                  twoRun(2);
                                  totalOver(2);
                                  if(Wide){

                                  }
                                  else{
                                    batsmanRunsAndBalls(2);
                                  }

                                }, child: Text('2',style: TextStyle(fontSize: 28,fontWeight: FontWeight.w500),),
                                  style: ElevatedButton.styleFrom(shape: CircleBorder()),),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ElevatedButton(onPressed: (){
                                  threeRun(3);
                                  totalOver(3);
                                  if(Wide){

                                  }
                                  else{
                                    batsmanRunsAndBalls(3);
                                  }

                                }, child: Text('3',style: TextStyle(fontSize: 28,fontWeight: FontWeight.w500),),
                                  style: ElevatedButton.styleFrom(shape: CircleBorder()),),
                              ),
                            ],
                          ),

                          Row(
                            children: [

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ElevatedButton(onPressed: (){
                                  fourRun(4);
                                  totalOver(4);
                                  if(Wide){

                                  }
                                  else{
                                    batsmanRunsAndBalls(4);
                                  }
                                }, child: Text('4',style: TextStyle(fontSize: 28,fontWeight: FontWeight.w500),),
                                  style: ElevatedButton.styleFrom(shape: CircleBorder()),),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ElevatedButton(onPressed: (){
                                  fiveRun(5);
                                  totalOver(5);
                                  if(Wide){

                                  }
                                  else{
                                    batsmanRunsAndBalls(5);
                                  }
                                }, child: Text('5',style: TextStyle(fontSize: 28,fontWeight: FontWeight.w500),),
                                  style: ElevatedButton.styleFrom(shape: CircleBorder()),),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ElevatedButton(onPressed: (){
                                  sixRun(6);
                                  totalOver(6);
                                  if(Wide){

                                  }
                                  else{
                                    batsmanRunsAndBalls(6);
                                  }

                                }, child: Text('6',style: TextStyle(fontSize: 28,fontWeight: FontWeight.w500),),
                                  style: ElevatedButton.styleFrom(shape: CircleBorder()),),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ElevatedButton(onPressed: (){}, child: Text('...',style: TextStyle(fontSize: 28,fontWeight: FontWeight.w500),),
                                  style: ElevatedButton.styleFrom(shape: CircleBorder()),),
                              ),
                            ],
                          )
                        ],
                      ),


                    ),
                  ),
                ],
              ),
          ),
          ),
        ],
      ),
    );
  }
}

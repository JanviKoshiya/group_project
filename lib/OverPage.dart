import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverPage extends StatefulWidget {

  String BName;
  OverPage(this.BName,{super.key});

  @override
  State<OverPage> createState() => _OverPageState();
}

class _OverPageState extends State<OverPage> {

  var BNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bowler Name'),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Enter Bowler Name',style: TextStyle(fontSize: 22,color: Colors.deepPurple,fontWeight: FontWeight.w700,),),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: BNameController,
              decoration: InputDecoration(
                hintText: "Bowler Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
          ),

          ElevatedButton(onPressed: (){
            if(BNameController.text.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enter Bowler Name'))
              );
            }
            else{
              String BName = BNameController.text;
              Navigator.pop(context,BName);
            }
          },
              child: Text('Done',style: TextStyle(fontSize: 22,color: Colors.deepPurple,fontWeight: FontWeight.w700,)))
        ],
      ),
    );
  }
}

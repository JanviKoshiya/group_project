import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WicketPage extends StatefulWidget {

  String SBName;

  // Accept an optional named parameter `text` if callers provide it.
  WicketPage(this.SBName, {super.key, String? text});

  @override
  State<WicketPage> createState() => _WicketPageState();
}

class _WicketPageState extends State<WicketPage> {

  var StrikerController = TextEditingController();

  String dropdownvalue = 'Bowled';

  var items = ['Bowled','Catch out' , 'Run Out' , 'Stumping' , 'LBW' , 'Hit Wicket'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wicket fall'),
      ),

      body: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('How Wicket fall ?',style: TextStyle(fontSize: 22,color: Colors.deepPurple,fontWeight: FontWeight.w700,),),
              ),
          ),
          SizedBox(height: 11,),
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                  value: dropdownvalue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items){
                    return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                    );
              }).toList(), onChanged: (String? newValue){
                    setState(() {
                      dropdownvalue = newValue!;
                    });
              },),
            ),
          ),

          SizedBox(height: 11,),

          Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('New batsman',style: TextStyle(fontSize: 22,color: Colors.deepPurple,fontWeight: FontWeight.w700,),),
              ),
          ),

          SizedBox(height: 11,),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: StrikerController,
              decoration: InputDecoration(
                hintText: 'New Batsman Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
          ),

          SizedBox(height: 11,),

          ElevatedButton(onPressed: (){
            if(StrikerController.text.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Fill Empty Data"),
                  ),
              );
            }
            else {

              String SBName = StrikerController.text;
              Navigator.pop(context,SBName);

            }
          },
            child: Text('Done',),),
        ],
      ),
    );
  }
}

class NBName {
}

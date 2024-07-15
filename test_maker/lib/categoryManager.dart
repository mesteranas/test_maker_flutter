import 'package:test/questionsManager.dart';

import 'jsonControl.dart';
import 'language.dart';
import 'package:flutter/material.dart';
class categoryManager extends StatefulWidget{
  categoryManager({Key?key}):super(key:key);
  @override
  State<categoryManager> createState()=>_categoryManager();
}
class _categoryManager extends State<categoryManager>{
  TextEditingController _name=TextEditingController();
  var _=Language.translate;
  Map<String,dynamic> data={};
  void initState(){
    super.initState();
    load();
    }
  void load() async{
      data=await get();

    setState((){
    });

  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(_("category manager")),),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: () async{
              await showDialog(context: context, builder: (context){
                return Dialog(child:Center(
                  child:Column(
                    children: [
                      TextFormField(controller: _name,decoration: InputDecoration(labelText: _("category name")),),
                      ElevatedButton(onPressed: () async{
                        data[_name.text]={};
                        await save(data);
                        Navigator.pop(context);
                      }, child: Text(_("add")))
                    ],
                  ) ,
                ) ,);
              });
              setState(() {
                
              });
            }, child: Text(_("add"))),
            for (var category in data.keys.toList())
            ListTile(
              title: Text(category.toString()),
              onLongPress:() async{
                data.remove(category);
                await save(data);
                setState(() {
                  
                });
              } ,
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>questionsManager(category: category)));
              },
            )
          ],
        ),
      ),
    );
  }
}

import 'package:final_project/CameraApp.dart';
import 'package:flutter/material.dart';

import 'MetinSayfasi.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("İşaret Dili"),),
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(child: Text("İşaret Dili Çevirmeni",style: TextStyle(fontSize: 29),),),
                SizedBox(width: 10,),
                RaisedButton(onPressed: ()=> {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()))
                },
                  color: Colors.blueGrey,
                  child: Text(
                      "Video ile Anla"
                  ),
                ),
                SizedBox(width: 50,),
                RaisedButton(onPressed: ()=> {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    MetinSayfasi()
                  )),
                },
                  color: Colors.blue,
                  child: Text(
                  "Resim ile İfade Et"
                  ),
                )
              ],
            )
          ],

        ),
      ),
    );
  }
}

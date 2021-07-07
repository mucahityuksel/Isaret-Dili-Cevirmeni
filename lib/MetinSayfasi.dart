import 'dart:io';
import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MetinSayfasi extends StatefulWidget {
  @override
  _MetinSayfasiState createState() => _MetinSayfasiState();
}

class _MetinSayfasiState extends State<MetinSayfasi> {
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    String x;
    String y;
    List a = ["assets/a1.jpg"];
    List k = [];

    return Scaffold(

      body: Container(
        child: (Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: textController,
              decoration: InputDecoration(

                  hintText: "Kelime Giriniz",
                  suffixIcon: IconButton(
                    onPressed: () =>
                    {
                      textController.clear(),
                      k = []
                    },

                    icon: Icon(Icons.clear),
                  )
              ),
            ),
            SizedBox(width: 50,),
            RaisedButton(
              onPressed: () =>
              {
                x = textController.text,
                k = (x.split('')),
                print(k),
                showDialog(
                    context: context,
                    builder: (context) {
                      return Container(
                        child: yazdir(k),
                      );
                    })
              },
              color: Colors.blueGrey,
              child: Text("Kelimeyi İşsaret Dilinde Göster"),
            ),
          ],
        )),
      ),
    );
  }
}

Widget yazdir(List a) {
  print(a.length);
  return ListView.builder(
    itemCount: 1,
    padding: EdgeInsets.all(8),
    itemBuilder: (BuildContext ctx, int item) {
      return Column(
        children: [
          for ( var i in a )Image.asset("assets/${i}1.png")
        ],
      );
    },
  );
}

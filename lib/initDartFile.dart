import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class initData extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return initData_state();
  }
}

class initData_state extends State<initData> {

  TextEditingController textController_N = TextEditingController();
  TextEditingController textController_Tn = TextEditingController();
  TextEditingController textController_Tk = TextEditingController();
  TextEditingController textController_alfa = TextEditingController();
  TextEditingController textController_step = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Введите данные"),
      ),
      body: Container(
        child: Column(
          children: [
            TextField(
              controller: textController_N,
            ),
            const Text("Введите N", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18,)),
            TextField(
              controller: textController_Tn,
            ),
            const Text("Введите нач.температуру", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18,)),
            TextField(
              controller: textController_Tk,
            ),
            const Text("Введите конеч.температуру", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18,)),
            TextField(
              controller: textController_alfa,
            ),
            const Text("Введите альфа", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18,)),
            TextField(
              controller: textController_step,
            ),
            const Text("Введите число шагов", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18,)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ignore: deprecated_member_use
                RaisedButton(
                  child: Icon(Icons.input),
                  onPressed: () {
                    onSave(context);
                  },
                ),

              ],
            )
          ],
        ),
      ),
    );
  }

  void onSave(BuildContext context) {
    var ControllerList = [];

    int ToSendBack_N = int.parse(textController_N.text);
    double ToSendBack_Tn = double.parse(textController_Tn.text);
    double ToSendBack_Tk = double.parse(textController_Tk.text);
    double ToSendBack_alfa = double.parse(textController_alfa.text);
    int ToSendBack_step = int.parse(textController_step.text);

    ControllerList.add(ToSendBack_N);
    ControllerList.add(ToSendBack_Tn);
    ControllerList.add(ToSendBack_Tk);
    ControllerList.add(ToSendBack_alfa);
    ControllerList.add(ToSendBack_step);

    Navigator.pop(context, ControllerList);
  }
}
import 'dart:ffi';
import 'dart:math';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'initDartFile.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class TMember{     // решение
  var Plan ;
  var Energy = 0;
  TMember() {
    Plan = [];
    Energy = 0;
  }
}

class AnnealingMethod {

  int N = 8;
  double Tn = 30.0;
  double Tk = 0.1;
  double Alfa = 0.98;
  int St = 100;

  AnnealingMethod(){
    N = 8;
    Tn = 30.0;
    Tk = 0.1;
    Alfa = 0.98;
    St = 100;
  }

  TMember Current = TMember(); // текущее решение
  TMember Working = TMember(); // рабочее решение
  TMember Best = TMember(); // лучшее решение
  late double T; // температура
  late int Delta; // разница энергий
  late double P; // вероятность допуска
  late bool fNew; // флаг нового решения
  late bool fBest; // флаг лучшего решения
  late int Time; // этап поиска
  late int Step; // шаг на этапе поиска
  late int Accepted; // число новых решений
  Map Tmap =({0.0 : 0});
  Map EnergyMap =({0 : 0});
  Map AcceptMap =({0 : 0});

  void Swap(TMember M) {
    // модификация решения
    int x, y, v;
    var rnd = Random();
    x = rnd.nextInt(N);
    do {
      y = rnd.nextInt(N) ;
    }
    while (x == y);

    v = M.Plan[x];
    M.Plan[x] = M.Plan[y];
    M.Plan[y] = v;
  }

  void New(TMember M) {
    // инициализация решения
    int i;
    M.Plan.clear();

    for (i = 0; i < N; i++) {
      M.Plan.add(i);
    }

    for (i = 0; i < N; i++) {
      Swap(M);
    }
  }

  void CalcEnergy(TMember M) {
    // расчет энергии
    final List dx = [-1, 1, -1, 1];
    final List dy = [-1, 1, 1, -1];
    var tx, ty;
    int j, x;
    int error;
    error = 0;
    for (x = 0; x < N; x++) {
      for (int j = 0; j < 4; j++) {
        tx = x + dx[j];
        ty = M.Plan[x] + dy[j];
        while ((tx >= 0) && (tx < N) && (ty >= 0) && (ty < N)) {
          if (M.Plan[tx] == ty) {
            error++;
          }
          tx += dx[j];
          ty += dy[j];
        }
      }
    }
    M.Energy = error;
  }

  void Copy(TMember MD, MS) {
    // копирование решения

    MD.Plan.clear();
    MD.Plan.addAll(MS.Plan);
    MD.Energy = MS.Energy;
  }

  getRes(TMember M) {
    var  locStr = "";
    var strRes = [];
    print("Решение");
    for (int y = 0; y < N; y++) {
      for (int x = 0; x < N; x++) {
        if (M.Plan[x] == y) {
          locStr += "  Q  ";
        } else {
          locStr += "  #  ";
        }
      }
      strRes.add(locStr);

      locStr ="";
    }

    return strRes;
  }

  startWorking() {
    T = Tn;
    fBest = false;
    Time = 0;
    List strRes = [];
    Best.Energy = 100;
    New(Current);
    CalcEnergy(Current);
    Copy(Working, Current);
    var rnd = Random();
    while (T > Tk) {
      Accepted = 0;
      for (Step = 0; Step <= St; Step++) {
        fNew = false;
        Swap(Working);
        CalcEnergy(Working);
        if (Working.Energy <= Current.Energy) {
          fNew = true;
        } else {
          Delta = (Working.Energy - Current.Energy);
          P = exp(-Delta / T);
          if (P > 0 + rnd.nextDouble() * (1)) {
            Accepted++;
            fNew = true;
          }
        }
        if (fNew) {
          fNew = false;
          Copy(Current, Working);
          if (Current.Energy < Best.Energy) {
            Copy(Best, Current);
            EnergyMap.addAll({Best.Energy : Time});
            fBest = true;
          }
        }
        else {
          Copy(Working, Current);
        }
      }
      AcceptMap.addAll({Accepted: Time});
      T *= Alfa;
      Time++;
      Tmap.addAll({T : Time});
    }
    if (fBest) {
      strRes = getRes(Best);
    }
    return strRes;
  }
}

class TempData{
  final int time;
  final double temp;

  TempData(this.time, this.temp);

}

class IntData{
  final int intVal;
  final int time;

  IntData(this.time, this.intVal);

}

class AccData{
  final int intVal;
  final int time;

  AccData(this.time, this.intVal);

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  void _setState(List res) {
    res.clear();
    setState(() {
    });
  }

  AnnealingMethod  myObj = AnnealingMethod();

  List<TempData> dataTemp = [TempData(0,0.0)];
  List<IntData> energyData = [IntData(0,0)];
  List<AccData> acceptData = [AccData(0,0)];

  @override
  Widget build(BuildContext context) {
    List res = [];
    res = myObj.startWorking();

    dataTemp.clear();
    energyData.clear();
    acceptData.clear();

    dataTemp = [
      for(var item in myObj.Tmap.entries)
        TempData(item.value, item.key)
    ];

    energyData = [
      for(var item in myObj.EnergyMap.entries)
        IntData(item.value, item.key)
    ];

    acceptData = [
      for(var item in myObj.AcceptMap.entries)
        AccData(item.value, item.key)
    ];

    myObj.Tmap.clear();
    myObj.EnergyMap.clear();
    myObj.AcceptMap.clear();

    return Scaffold(
      appBar: AppBar(
        title: Text('Метод отжига'),
      ),
      body: Container(
        child: ListView(
            children: [

              for(final oneStr in res)
                Text('$oneStr',
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 7.5)
                ),
              SfCartesianChart(   // график темературы
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: 'График темературы'),
                legend: Legend(isVisible: true,),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<TempData, int>>[
                  LineSeries<TempData, int>(
                    dataSource: dataTemp,
                    xValueMapper: (TempData sales, _) => sales.time,
                    yValueMapper: (TempData sales, _) => sales.temp,
                    name: 'Температура',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: 'График лучшей энергии'),
                legend: Legend(isVisible: true,),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<IntData, int>>[
                  LineSeries<IntData, int>(
                    dataSource: energyData,
                    xValueMapper: (IntData sales, _) => sales.time,
                    yValueMapper: (IntData sales, _) => sales.intVal,
                    name: 'Лучшая энергия',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),  SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: '\nГрафик изменения принятых плохих решений'),
                legend: Legend(isVisible: true,),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<AccData, int>>[
                  LineSeries<AccData, int>(
                    dataSource: acceptData,
                    xValueMapper: (AccData sales, _) => sales.time,
                    yValueMapper: (AccData sales, _) => sales.intVal,
                    name: '\n Изменения принятых плохих решений',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),

              Text("N = " + '${myObj.N}',  style: const TextStyle(fontSize: 15,)),
              Text("Tn = " + '${myObj.Tn}', style: const TextStyle(fontSize: 15,)),
              Text("Tk = " + '${myObj.Tk}', style: const TextStyle(fontSize: 15,)),
              Text("Alfa = " + '${myObj.Alfa}', style: const TextStyle(fontSize: 15,)),
              Text("Step = " + '${myObj.St}', style: const TextStyle(fontSize: 15,)),

              RaisedButton(
                onPressed: () {_setState(res);},
                child: const Icon(Icons.update),
              ),
            ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {_ValueFromSecondScreen(context); },
        child: const Icon(Icons.next_week_outlined),
      ),
    );
  }

  void _ValueFromSecondScreen(BuildContext context) async {

    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => initData(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      myObj.N = result[0];
      myObj.Tn = result[1];
      myObj.Tk = result[2];
      myObj.Alfa = result[3];
      myObj.St = result[4];

      // НАДО ОТПРАВИТЬ ОБЪЕКТ myObj

      result.clear();
    });
  }
}


void main() {

  runApp(MyApp());
  print("HELLO, WORLD!");

  print ("Goodbuy, WORLD!");
}

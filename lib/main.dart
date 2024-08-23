import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _gasolinaController = TextEditingController();
  final TextEditingController _alcoolController = TextEditingController();

  String _resultado = "Informe os valores!";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double _opacity = 0.0;
  double _gasolina = 0.0;
  double _alcool = 0.0;

  void limparCampos() {
    _gasolinaController.text = "";
    _alcoolController.text = "";
    setState(() {
      _resultado = "Informe os valores!";
      _opacity = 0.0;
      _gasolina = 0.0;
      _alcool = 0.0;
    });
  }

  void calcular() {
    double gasolina = double.parse(_gasolinaController.text);
    double alcool = double.parse(_alcoolController.text);

    double razao = gasolina / alcool;

    setState(() {
      bool isValidDouble(dynamic value) {
        return value is double && value > 0;
      }

      if (razao < 0.7) {
        _resultado = "Abasteça com Álcool";
      } else {
        if (isValidDouble(gasolina) && isValidDouble(alcool)) {
          if (alcool / gasolina < 0.7) {
            _resultado = "Abasteça com Álcool";
          } else {
            _resultado = "Abasteça com Gasolina";
          }
        } else {
          _resultado = "Valores inválidos para gasolina ou álcool";
        }
      }

      _opacity = 1.0;
      _gasolina = gasolina;
      _alcool = alcool;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Combustível'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            onPressed: limparCampos,
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Icon(
                  FontAwesomeIcons.gasPump,
                  size: 100.0,
                  color: Colors.black,
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Valor da Gasolina",
                  labelStyle: TextStyle(color: Colors.red, fontSize: 25.0),
                ),
                controller: _gasolinaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o valor da gasolina!';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Valor do Álcool",
                  labelStyle: TextStyle(color: Colors.red, fontSize: 25.0),
                ),
                controller: _alcoolController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o valor do álcool!';
                  }
                  return null;
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        calcular();
                      }
                    },
                    child: Text(
                      "Calcular",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      limparCampos();
                    },
                    child: Text(
                      "Limpar",
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    ),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(seconds: 1),
                child: Column(
                  children: [
                    Text(
                      _resultado,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    Container(
                      height: 300,
                      padding: EdgeInsets.all(20),
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    double total = _gasolina + _alcool;
    double gasolinaPercentage = (_gasolina / total) * 100;
    double alcoolPercentage = (_alcool / total) * 100;

    return [
      PieChartSectionData(
        color: Colors.blue,
        value: gasolinaPercentage,
        title: 'Gasolina\n${gasolinaPercentage.toStringAsFixed(1)}%',
        radius: 100,
      ),
      PieChartSectionData(
        color: Colors.green,
        value: alcoolPercentage,
        title: 'Álcool\n${alcoolPercentage.toStringAsFixed(1)}%',
        radius: 100,
      ),
    ];
  }
}

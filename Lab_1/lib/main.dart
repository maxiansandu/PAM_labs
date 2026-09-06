import 'package:flutter/material.dart';

void main() {
  runApp( MaterialApp(
    home: SalaryCalculatorApp(),
  ),);
}

class SalaryCalculatorApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState(){
    return _HomePageState();
  }
}

class _HomePageState extends State<SalaryCalculatorApp> {
  double tax = 0;
  double netSalary = 0;
  String? selectedType = null;
  final TextEditingController salaryController = TextEditingController();

  void calculateSalary() {

    if (selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Selectează tipul de angajat!"),
          duration: Duration(seconds: 3),
        ),
      );

      return;
    }
    double salary =
        double.tryParse(salaryController.text) ?? 0;

    double taxRate;

    if (selectedType == "standard") {
      taxRate = 0.20;
    } else {
      taxRate = 0.10;
    }

    setState(() {
      tax = salary * taxRate;
      netSalary = salary - tax;
    });
  }
  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Center(child: Text("Salary calculator app") ),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: salaryController,
              decoration: InputDecoration(
                  labelText: "Salariul brut",
                  border: OutlineInputBorder()
              ),
            ),
            DropdownButton<String>(value: selectedType, items: [
              DropdownMenuItem(value: "standard", child: Text("standard"),),
              DropdownMenuItem(value: "stagiar",child: Text("stagiar"))
            ],
              onChanged: (value){
                setState(() {
                  selectedType = value;
                });
              },),

            ElevatedButton(
              onPressed: calculateSalary,
              child: Text("CALCULEAZĂ"),
            ),
            Text(
              "Impozit: ${tax.toStringAsFixed(2)}",
            ),

            Text(
              "Salariu net: ${netSalary.toStringAsFixed(2)}",
            ),

          ],

        ),
      ),
    );
  }
}

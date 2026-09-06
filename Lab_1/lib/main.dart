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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: salaryController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Salariul brut",
                      hintText: "Introdu salariul",
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Tip angajat",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      DropdownButton<String>(
                        value: selectedType,
                        hint: Text("Selectează"),
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                            value: "standard",
                            child: Text("Standard"),
                          ),
                          DropdownMenuItem(
                            value: "stagiar",
                            child: Text("Stagiar"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedType = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: 180,
              height: 50,
              child: ElevatedButton(
                onPressed: calculateSalary,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "CALCULEAZĂ",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),

            Row(
              children: [

                Expanded(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [

                          Icon(
                            Icons.receipt_long,
                            size: 30,
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Impozit",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            "${tax.toStringAsFixed(2)} lei",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [

                          Icon(
                            Icons.account_balance_wallet,
                            size: 30,
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Salariu net",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            "${netSalary.toStringAsFixed(2)} lei",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/dollars_in_the_sky.jpg',
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

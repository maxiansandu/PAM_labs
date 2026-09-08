import 'package:flutter/material.dart';

import '../models/employee_type.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  double tax = 0;
  double netSalary = 0;

  EmployeeType? selectedType;

  List<EmployeeType> employeeTypes = [
    EmployeeType(
      name: "Standard",
      taxRate: 20,
    ),
    EmployeeType(
      name: "Stagiar",
      taxRate: 10,
    ),
  ];

  final TextEditingController salaryController =
  TextEditingController();

  void calculateSalary() {
    if (selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selectează tipul de angajat!"),
          duration: Duration(seconds: 3),
        ),
      );

      return;
    }

    double salary =
        double.tryParse(salaryController.text) ?? 0;

    double taxRate =
        selectedType!.taxRate / 100;

    setState(() {
      tax = salary * taxRate;
      netSalary = salary - tax;
    });
  }

  void openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          employeeTypes: employeeTypes,
          onChanged: (updatedTypes) {
            setState(() {
              employeeTypes = updatedTypes;

              if (selectedType != null &&
                  !employeeTypes.contains(selectedType)) {
                selectedType = null;
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: const Center(
          child: Text("Salary calculator app"),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: openSettings,
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Expanded(
                  flex: 2,

                  child: TextField(
                    controller: salaryController,
                    keyboardType:
                    TextInputType.number,

                    decoration: InputDecoration(
                      labelText: "Salariul brut",
                      hintText: "Introdu salariul",
                      prefixIcon:
                      const Icon(Icons.attach_money),

                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  flex: 1,

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      const Text(
                        "Tip angajat",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      DropdownButton<EmployeeType>(
                        value: selectedType,
                        hint: const Text("Selectează"),
                        isExpanded: true,

                        items: employeeTypes
                            .map((employee) {

                          return DropdownMenuItem<
                              EmployeeType>(
                            value: employee,
                            child:
                            Text(employee.name),
                          );
                        }).toList(),

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

                style:
                ElevatedButton.styleFrom(
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  "CALCULEAZĂ",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.bold,
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

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15),
                    ),

                    child: Padding(
                      padding:
                      const EdgeInsets.all(18),

                      child: Column(
                        children: [

                          const Icon(
                            Icons.receipt_long,
                            size: 30,
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            "Impozit",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            "${tax.toStringAsFixed(2)} lei",

                            style:
                            const TextStyle(
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

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15),
                    ),

                    child: Padding(
                      padding:
                      const EdgeInsets.all(18),

                      child: Column(
                        children: [

                          const Icon(
                            Icons
                                .account_balance_wallet,
                            size: 30,
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            "Salariu net",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            "${netSalary.toStringAsFixed(2)} lei",

                            style:
                            const TextStyle(
                              fontSize: 20,
                              fontWeight:
                              FontWeight.bold,
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
              borderRadius:
              BorderRadius.circular(15),

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
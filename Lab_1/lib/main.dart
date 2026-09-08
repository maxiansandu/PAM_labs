import 'package:flutter/material.dart';

void main() {
  runApp( MaterialApp(
    home: SalaryCalculatorApp(),
  ),);
}

class EmployeeType {
  String name;
  double taxRate;

  EmployeeType({
    required this.name,
    required this.taxRate,
  });
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
  EmployeeType? selectedType;

  List<EmployeeType> employeeTypes = [
    EmployeeType(name: "Standard", taxRate: 20),
    EmployeeType(name: "Stagiar", taxRate: 10),
  ];
  final TextEditingController salaryController = TextEditingController();

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

    double taxRate = selectedType!.taxRate / 100;

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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
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
            },
          ),
        ],
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

                      DropdownButton<EmployeeType>(
                        value: selectedType,
                        hint: const Text("Selectează"),
                        isExpanded: true,
                        items: employeeTypes.map((employee) {
                          return DropdownMenuItem<EmployeeType>(
                            value: employee,
                            child: Text(employee.name),
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

class SettingsPage extends StatefulWidget {
  final List<EmployeeType> employeeTypes;
  final Function(List<EmployeeType>) onChanged;

  const SettingsPage({
    super.key,
    required this.employeeTypes,
    required this.onChanged,
  });

  @override
  State<SettingsPage> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  late List<EmployeeType> employeeTypes;

  @override
  void initState() {
    super.initState();

    employeeTypes = List.from(widget.employeeTypes);
  }

  void addEmployeeType() {
    String name = "";
    String tax = "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adaugă tip angajat"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: "Nume",
                  hintText: "Ex: Manager",
                ),
                onChanged: (value) {
                  name = value;
                },
              ),

              const SizedBox(height: 15),

              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Impozit (%)",
                  hintText: "Ex: 15",
                ),
                onChanged: (value) {
                  tax = value;
                },
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Anulează"),
            ),

            ElevatedButton(
              onPressed: () {
                double? taxRate = double.tryParse(tax);

                if (name.trim().isEmpty ||
                    taxRate == null ||
                    taxRate < 0 ||
                    taxRate > 100) {
                  return;
                }

                setState(() {
                  employeeTypes.add(
                    EmployeeType(
                      name: name.trim(),
                      taxRate: taxRate,
                    ),
                  );
                });

                widget.onChanged(employeeTypes);

                Navigator.pop(context);
              },
              child: const Text("Adaugă"),
            ),
          ],
        );
      },
    );
  }

  void editEmployeeType(int index) {
    String name = employeeTypes[index].name;
    String tax = employeeTypes[index].taxRate.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editează tip angajat"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: name),
                decoration: const InputDecoration(
                  labelText: "Nume",
                ),
                onChanged: (value) {
                  name = value;
                },
              ),

              const SizedBox(height: 15),

              TextField(
                controller: TextEditingController(text: tax),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Impozit (%)",
                ),
                onChanged: (value) {
                  tax = value;
                },
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Anulează"),
            ),

            ElevatedButton(
              onPressed: () {
                double? taxRate = double.tryParse(tax);

                if (name.trim().isEmpty ||
                    taxRate == null ||
                    taxRate < 0 ||
                    taxRate > 100) {
                  return;
                }

                setState(() {
                  employeeTypes[index] = EmployeeType(
                    name: name.trim(),
                    taxRate: taxRate,
                  );
                });

                widget.onChanged(employeeTypes);

                Navigator.pop(context);
              },
              child: const Text("Salvează"),
            ),
          ],
        );
      },
    );
  }

  void deleteEmployeeType(int index) {
    setState(() {
      employeeTypes.removeAt(index);
    });

    widget.onChanged(employeeTypes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setări"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Tipuri de angajați",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: employeeTypes.length,

                itemBuilder: (context, index) {
                  final employee = employeeTypes[index];

                  return Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.person,
                      ),

                      title: Text(
                        employee.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        "Impozit: ${employee.taxRate}%",
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              editEmployeeType(index);
                            },
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteEmployeeType(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton.icon(
                onPressed: addEmployeeType,

                icon: const Icon(Icons.add),

                label: const Text(
                  "ADAUGĂ TIP DE ANGAJAT",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
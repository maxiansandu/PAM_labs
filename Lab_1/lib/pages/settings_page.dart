import 'package:flutter/material.dart';

import '../models/employee_type.dart';

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
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Thêm gói intl
import 'package:test_2/custome_form_container.dart';
import 'package:test_2/transaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giao Dịch Cửa Hàng Bán Xăng',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;

  // Declare the TextEditingController
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _revenueController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _pump; // Variable to save base
  final List<Transaction> _transactions = []; // List of stored transactions

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Update the value for the controller in the format dd/MM/yyyy HH:mm
        _dateController.text = DateFormat('dd/MM/yyyy HH:mm').format(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Save data to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('date', _selectedDate.toString());
      await prefs.setString('quantity', _quantityController.text);
      await prefs.setString('pump', _pump ?? '');
      await prefs.setString('revenue', _revenueController.text);
      await prefs.setString('unitPrice', _unitPriceController.text);

      // Add transactions to the list
      setState(() {
        _transactions.add(Transaction(
          date: _selectedDate,
          quantity: _quantityController.text,
          pump: _pump,
          revenue: _revenueController.text,
          unitPrice: _unitPriceController.text,
        ));
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công!')),
      );

      // Reset the form
      _formKey.currentState?.reset();
      setState(() {
        _selectedDate = null;
        _quantityController.clear();
        _revenueController.clear();
        _unitPriceController.clear();
        _dateController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng kiểm tra lại thông tin!')),
      );
    }
  }

  @override
  void dispose() {
    // Release controllers when no longer in use
    _quantityController.dispose();
    _revenueController.dispose();
    _unitPriceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập Giao Dịch'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                CustomFormContainer(
                  child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Thời gian',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                    validator: (value) {
                      if (_selectedDate == null) {
                        return 'Vui lòng chọn ngày';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CustomFormContainer(
                  child: TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Số lượng',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số lượng';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Vui lòng nhập số hợp lệ';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CustomFormContainer(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Trụ',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    items: ['Trụ 1', 'Trụ 2', 'Trụ 3']
                        .map((pump) => DropdownMenuItem(
                              value: pump,
                              child: Text(pump),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _pump = value; // Update pillar value
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng chọn trụ';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CustomFormContainer(
                  child: TextFormField(
                    controller: _revenueController,
                    decoration: const InputDecoration(
                      labelText: 'Doanh thu',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập doanh thu';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Vui lòng nhập số hợp lệ';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CustomFormContainer(
                  child: TextFormField(
                    controller: _unitPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Đơn giá',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập đơn giá';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Vui lòng nhập số hợp lệ';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20)),
                  ),
                  child: const Text('Cập nhật'),
                ),
                const SizedBox(height: 20),
                // Display transaction table in SingleChildScrollView
                SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal, // Horizontal scrolling for table
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Thời gian')),
                      DataColumn(label: Text('Số lượng')),
                      DataColumn(label: Text('Trụ')),
                      DataColumn(label: Text('Doanh thu')),
                      DataColumn(label: Text('Đơn giá')),
                    ],
                    rows: _transactions.map((transaction) {
                      return DataRow(cells: [
                        DataCell(Text(DateFormat('dd/MM/yyyy HH:mm')
                            .format(transaction.date!))),
                        DataCell(Text(transaction.quantity)),
                        DataCell(Text(transaction.pump ?? '')),
                        DataCell(Text(transaction.revenue)),
                        DataCell(Text(transaction.unitPrice)),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

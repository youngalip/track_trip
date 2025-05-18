import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_trip/providers/expense_provider.dart';
import 'package:track_trip/constants/app_colors.dart';
import 'package:track_trip/constants/app_strings.dart';
import 'package:track_trip/widgets/common/custom_button.dart';
import 'package:track_trip/widgets/common/custom_text_field.dart';
import 'package:track_trip/utils/validators.dart';
import 'package:intl/intl.dart';

class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Makanan';
  bool _isLoading = false;

  final List<String> _categories = [
    'Makanan',
    'Transportasi',
    'Hiburan',
    'Belanja',
    'Pendidikan',
    'Kesehatan',
    'Lainnya',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await Provider.of<ExpenseProvider>(context, listen: false).addExpense(
          _titleController.text,
          double.parse(_amountController.text),
          _selectedDate,
          _selectedCategory,
          _noteController.text.isEmpty ? null : _noteController.text,
        );
        
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (error) {
        // Tampilkan error dialog
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                        title: const Text('Error'),
            content: const Text('Terjadi kesalahan saat menyimpan pengeluaran. Silakan coba lagi.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addExpense),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: _titleController,
                  labelText: AppStrings.expenseTitle,
                  validator: Validators.required,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _amountController,
                  labelText: AppStrings.amount,
                  keyboardType: TextInputType.number,
                  validator: Validators.amount,
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: AppStrings.category,
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: AppStrings.date,
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _noteController,
                  labelText: AppStrings.note,
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        onPressed: _saveExpense,
                        text: AppStrings.save,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


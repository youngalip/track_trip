import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_trip/providers/budget_provider.dart';
import 'package:track_trip/models/budget.dart';
import 'package:track_trip/constants/app_colors.dart';
import 'package:track_trip/constants/app_strings.dart';
import 'package:track_trip/constants/app_styles.dart';
import 'package:track_trip/widgets/common/custom_button.dart';
import 'package:track_trip/widgets/common/custom_text_field.dart';
import 'package:track_trip/utils/validators.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BudgetFormScreen extends StatefulWidget {
  final Budget? budget; // Null jika menambah anggaran baru

  const BudgetFormScreen({super.key, this.budget});

  @override
  State<BudgetFormScreen> createState() => _BudgetFormScreenState();
}

class _BudgetFormScreenState extends State<BudgetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  BudgetType _selectedType = BudgetType.monthly;
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
  void initState() {
    super.initState();
    if (widget.budget != null) {
      // Edit mode - pre-fill form with existing data
      _titleController.text = widget.budget!.title;
      _amountController.text = widget.budget!.amount.toString();
      _selectedType = widget.budget!.type;
      _selectedCategory = widget.budget!.category;
      _startDate = widget.budget!.startDate;
      _endDate = widget.budget!.endDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        // If end date is before start date, reset it
        if (_endDate != null && _endDate!.isBefore(_startDate)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate.add(const Duration(days: 30)),
      firstDate: _startDate,
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _saveBudget() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
        
        if (widget.budget == null) {
          // Add new budget
          await budgetProvider.addBudget(
            _titleController.text,
            double.parse(_amountController.text),
            _selectedType,
            _selectedCategory,
            _startDate,
            _endDate,
          );
        } else {
          // Update existing budget
          final updatedBudget = Budget(
            id: widget.budget!.id,
            userId: FirebaseAuth.instance.currentUser?.uid ?? 'anonymous', // Tambahkan ini
            title: _titleController.text,
            amount: double.parse(_amountController.text),
            type: _selectedType,
            category: _selectedCategory,
            startDate: _startDate,
            endDate: _endDate,
          );
          await budgetProvider.updateBudget(updatedBudget);
        }
        
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (error) {
        // Show error dialog
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Terjadi kesalahan saat menyimpan anggaran. Silakan coba lagi.'),
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
        title: Text(widget.budget == null ? AppStrings.addBudget : AppStrings.editBudget),
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
                  labelText: AppStrings.budgetTitle,
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
                DropdownButtonFormField<BudgetType>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: AppStrings.budgetType,
                    border: OutlineInputBorder(),
                  ),
                  items: BudgetType.values.map((type) {
                    String label;
                    switch (type) {
                      case BudgetType.daily:
                        label = 'Harian';
                        break;
                      case BudgetType.weekly:
                        label = 'Mingguan';
                        break;
                      case BudgetType.monthly:
                        label = 'Bulanan';
                        break;
                    }
                    return DropdownMenuItem(
                      value: type,
                      child: Text(label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
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
                  onTap: () => _selectStartDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: AppStrings.startDate,
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('dd MMM yyyy').format(_startDate)),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectEndDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: AppStrings.endDate,
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _endDate == null
                            ? const Text('Tidak ditentukan')
                            : Text(DateFormat('dd MMM yyyy').format(_endDate!)),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        onPressed: _saveBudget,
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


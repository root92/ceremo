import 'package:flutter/material.dart';
import 'package:ceremo/l10n/app_localizations.dart';
import 'package:ceremo/services/project_service.dart';
import 'package:ceremo/theme/app_colors.dart';

class AddExpenseScreen extends StatefulWidget {
  final String projectId;
  final String? projectCurrency;

  const AddExpenseScreen({
    super.key,
    required this.projectId,
    this.projectCurrency,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _receiptUrlController = TextEditingController();
  
  String _selectedCategory = '';
  bool _isLoading = false;

  final List<String> _expenseCategories = [
    'venue',
    'food',
    'transport',
    'decoration',
    'entertainment',
    'utilities',
    'clothing',
    'gifts',
    'ceremony_items',
    'security',
    'photography',
    'miscellaneous',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _receiptUrlController.dispose();
    super.dispose();
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'venue':
        return AppLocalizations.of(context)!.venue;
      case 'food':
        return AppLocalizations.of(context)!.food;
      case 'transport':
        return AppLocalizations.of(context)!.transport;
      case 'decoration':
        return AppLocalizations.of(context)!.decoration;
      case 'entertainment':
        return AppLocalizations.of(context)!.entertainment;
      case 'utilities':
        return AppLocalizations.of(context)!.utilities;
      case 'clothing':
        return AppLocalizations.of(context)!.clothing;
      case 'gifts':
        return AppLocalizations.of(context)!.gifts;
      case 'ceremony_items':
        return AppLocalizations.of(context)!.ceremonyItems;
      case 'security':
        return AppLocalizations.of(context)!.security;
      case 'photography':
        return AppLocalizations.of(context)!.photography;
      case 'miscellaneous':
        return AppLocalizations.of(context)!.miscellaneous;
      default:
        return category;
    }
  }

  Future<void> _addExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ProjectService.createExpense(
        projectId: widget.projectId,
        amount: double.parse(_amountController.text),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        receiptUrl: _receiptUrlController.text.trim().isEmpty 
            ? null 
            : _receiptUrlController.text.trim(),
        currency: widget.projectCurrency,
        status: 'pending',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.expenseAdded),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      print('Add expense error: $e');
      print('Error type: ${e.runtimeType}');
      if (e.toString().contains('GraphQL')) {
        print('GraphQL error details: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.addExpenseError}: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
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
        title: Text(AppLocalizations.of(context)!.addExpense),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Field
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.amount,
                  hintText: AppLocalizations.of(context)!.enterAmount,
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.amountRequired;
                  }
                  if (double.tryParse(value) == null) {
                    return AppLocalizations.of(context)!.invalidAmount;
                  }
                  if (double.parse(value) <= 0) {
                    return AppLocalizations.of(context)!.invalidAmount;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.description,
                  hintText: AppLocalizations.of(context)!.enterDescription,
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLocalizations.of(context)!.descriptionRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory.isEmpty ? null : _selectedCategory,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.category,
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                items: _expenseCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(_getCategoryLabel(category)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.categoryRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Receipt URL Field (Optional)
              TextFormField(
                controller: _receiptUrlController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.receiptUrl,
                  hintText: AppLocalizations.of(context)!.enterReceiptUrl,
                  prefixIcon: const Icon(Icons.receipt),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),

              // Add Expense Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          AppLocalizations.of(context)!.addExpense,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

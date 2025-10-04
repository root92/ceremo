import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/projects_provider.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetAmountController = TextEditingController();
  
  String _selectedType = 'ceremony';
  String? _selectedCountry;
  String? _selectedCurrency;

  final List<String> _projectTypes = [
    'ceremony',
    'wedding',
    'funeral',
    'birthday',
    'anniversary',
    'graduation',
    'other',
  ];

  final List<String> _countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'France',
    'Germany',
    'Spain',
    'Italy',
    'Australia',
    'Japan',
    'Brazil',
    'India',
    'Nigeria',
    'South Africa',
    'Kenya',
    'Ghana',
  ];

  final List<String> _currencies = [
    'USD',
    'EUR',
    'GBP',
    'CAD',
    'AUD',
    'JPY',
    'NGN',
    'ZAR',
    'KES',
    'GHS',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateProject() async {
    if (!_formKey.currentState!.validate()) return;

    final projectsProvider = context.read<ProjectsProvider>();
    final success = await projectsProvider.createProject(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      type: _selectedType,
      targetAmount: _targetAmountController.text.isNotEmpty 
          ? double.tryParse(_targetAmountController.text) 
          : null,
      country: _selectedCountry,
      currency: _selectedCurrency,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.projectCreatedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(projectsProvider.error ?? AppLocalizations.of(context)!.projectCreationFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createProject),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Project Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.projectName,
                  hintText: AppLocalizations.of(context)!.enterProjectName,
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.pleaseEnterProjectName;
                  }
                  if (value.length < 3) {
                    return AppLocalizations.of(context)!.projectNameMinLength;
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Project Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.projectDescription,
                  hintText: AppLocalizations.of(context)!.enterProjectDescription,
                  prefixIcon: const Icon(Icons.description),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Project Type
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.projectType,
                  prefixIcon: const Icon(Icons.category),
                ),
                items: _projectTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type.toUpperCase()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Target Amount
              TextFormField(
                controller: _targetAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.targetAmount,
                  hintText: AppLocalizations.of(context)!.enterTargetAmount,
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return AppLocalizations.of(context)!.pleaseEnterValidAmount;
                    }
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Country
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.country,
                  prefixIcon: const Icon(Icons.public),
                ),
                items: _countries.map((String country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCountry = newValue;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Currency
              DropdownButtonFormField<String>(
                value: _selectedCurrency,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.currency,
                  prefixIcon: const Icon(Icons.monetization_on),
                ),
                items: _currencies.map((String currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCurrency = newValue;
                  });
                },
              ),
              
              const SizedBox(height: 32),
              
              // Create Button
              Consumer<ProjectsProvider>(
                builder: (context, projectsProvider, child) {
                  return SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: projectsProvider.isLoading ? null : _handleCreateProject,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: projectsProvider.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context)!.createProject,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

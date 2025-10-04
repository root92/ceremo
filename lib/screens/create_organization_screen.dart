import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/organizations_provider.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

class CreateOrganizationScreen extends StatefulWidget {
  const CreateOrganizationScreen({super.key});

  @override
  State<CreateOrganizationScreen> createState() => _CreateOrganizationScreenState();
}

class _CreateOrganizationScreenState extends State<CreateOrganizationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _slugController = TextEditingController();
  String _selectedOrgType = 'personal';

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _slugController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateOrganization() async {
    if (!_formKey.currentState!.validate()) return;

    final organizationsProvider = context.read<OrganizationsProvider>();
    final success = await organizationsProvider.createOrganization(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      slug: _slugController.text.trim().isEmpty 
          ? null 
          : _slugController.text.trim(),
      orgType: _selectedOrgType,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.organizationCreatedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(organizationsProvider.error ?? AppLocalizations.of(context)!.organizationCreationFailed),
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
        title: Text(AppLocalizations.of(context)!.createOrganization),
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
              // Organization Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.organizationName,
                  hintText: AppLocalizations.of(context)!.enterOrganizationName,
                  prefixIcon: const Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.pleaseEnterOrganizationName;
                  }
                  if (value.length < 3) {
                    return AppLocalizations.of(context)!.organizationNameMinLength;
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Organization Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.organizationDescription,
                  hintText: AppLocalizations.of(context)!.enterOrganizationDescription,
                  prefixIcon: const Icon(Icons.description),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Organization Type
              DropdownButtonFormField<String>(
                value: _selectedOrgType,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.organizationType,
                  prefixIcon: const Icon(Icons.category),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'personal',
                    child: Text('Personal'),
                  ),
                  DropdownMenuItem(
                    value: 'business',
                    child: Text('Business'),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOrgType = newValue!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Organization Slug
              TextFormField(
                controller: _slugController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.organizationSlug,
                  hintText: AppLocalizations.of(context)!.enterOrganizationSlug,
                  prefixIcon: const Icon(Icons.link),
                  helperText: AppLocalizations.of(context)!.slugHelperText,
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^[a-z0-9-]+$').hasMatch(value)) {
                      return AppLocalizations.of(context)!.invalidSlugFormat;
                    }
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 32),
              
              // Create Button
              Consumer<OrganizationsProvider>(
                builder: (context, organizationsProvider, child) {
                  return SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: organizationsProvider.isLoading ? null : _handleCreateOrganization,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: organizationsProvider.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context)!.createOrganization,
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

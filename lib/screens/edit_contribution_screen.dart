import 'package:flutter/material.dart';
import 'package:ceremo/l10n/app_localizations.dart';
import 'package:ceremo/services/project_service.dart';

class EditContributionScreen extends StatefulWidget {
  final String contributionId;
  final String projectId;
  final Map<String, dynamic> contribution;

  const EditContributionScreen({
    Key? key,
    required this.contributionId,
    required this.projectId,
    required this.contribution,
  }) : super(key: key);

  @override
  State<EditContributionScreen> createState() => _EditContributionScreenState();
}

class _EditContributionScreenState extends State<EditContributionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _transactionIdController = TextEditingController();
  final _noteController = TextEditingController();

  String? _selectedMemberId;
  String? _selectedPaymentMethod;
  bool _isLoading = false;
  List<Map<String, dynamic>> _members = [];

  // Payment method options
  final List<String> _paymentMethods = [
    'cash',
    'mpesa',
    'orange_money',
    'mtn_momo',
    'moov_money',
    'bank',
    'check',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _loadMembers();
  }

  void _initializeForm() {
    final contribution = widget.contribution;
    _amountController.text = contribution['amount']?.toString() ?? '';
    _transactionIdController.text = contribution['transactionId']?.toString() ?? '';
    _noteController.text = contribution['note']?.toString() ?? '';
    _selectedMemberId = contribution['member']?['id']?.toString();
    
    // Normalize payment method value to match our dropdown options
    final paymentMethodValue = contribution['paymentMethod']?.toString();
    if (paymentMethodValue != null) {
      final paymentMethod = paymentMethodValue.toLowerCase();
      if (_paymentMethods.contains(paymentMethod)) {
        _selectedPaymentMethod = paymentMethod;
      } else {
        // If the payment method doesn't match our options, default to 'other'
        _selectedPaymentMethod = 'other';
      }
    } else {
      _selectedPaymentMethod = 'other';
    }
  }

  Future<void> _loadMembers() async {
    try {
      final members = await ProjectService.getProjectMembers(
        projectId: widget.projectId,
      );
      
      setState(() {
        _members = members.map((member) => {
          'id': member['id'],
          'name': member['user']?['name'],
          'email': member['user']?['email'],
          'role': member['role'],
        }).toList();
      });
      
      // Ensure the selected member is still valid after loading
      if (_selectedMemberId != null) {
        final memberExists = _members.any((member) => member['id']?.toString() == _selectedMemberId);
        if (!memberExists) {
          // If the selected member is not in the list, add it as a fallback
          final currentMember = widget.contribution['member'];
          if (currentMember != null) {
            setState(() {
              _members.insert(0, {
                'id': currentMember['id'],
                'name': currentMember['name'],
                'email': currentMember['email'],
                'role': currentMember['role'],
              });
            });
          }
        }
      } else {
        // If no member is selected, try to select the first one
        if (_members.isNotEmpty) {
          _selectedMemberId = _members.first['id']?.toString();
        }
      }
    } catch (e) {
      print('Error loading members: $e');
      // Fallback to current member if loading fails
      setState(() {
        _members = [
          {
            'id': widget.contribution['member']?['id'],
            'name': widget.contribution['member']?['name'],
            'email': widget.contribution['member']?['email'],
          }
        ];
      });
    }
  }

  String _getPaymentMethodLabel(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return 'Cash';
      case 'mpesa':
        return 'M-Pesa';
      case 'orange_money':
        return 'Orange Money';
      case 'mtn_momo':
        return 'MTN MoMo';
      case 'moov_money':
        return 'Moov Money';
      case 'bank':
        return 'Bank Transfer';
      case 'check':
        return 'Check';
      case 'other':
        return 'Other';
      default:
        return method;
    }
  }

  String _getMemberName(Map<String, dynamic> member) {
    return member['name'] ?? member['email'] ?? 'Unknown Member';
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedMemberId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.memberRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.paymentMethodRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      
      await ProjectService.updateContribution(
        contributionId: widget.contributionId,
        memberId: _selectedMemberId!,
        amount: amount,
        paymentMethod: _selectedPaymentMethod!,
        transactionId: _transactionIdController.text.isNotEmpty ? _transactionIdController.text : null,
        note: _noteController.text.isNotEmpty ? _noteController.text : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.contributionUpdated),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.updateContributionError),
            backgroundColor: Colors.red,
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
  void dispose() {
    _amountController.dispose();
    _transactionIdController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editContribution),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
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
              // Member Selection
              Text(
                AppLocalizations.of(context)!.member,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedMemberId,
                    hint: Text(
                      AppLocalizations.of(context)!.selectMember,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    isExpanded: true,
                    style: Theme.of(context).textTheme.bodyMedium,
                    items: _members.map((member) {
                      return DropdownMenuItem<String>(
                        value: member['id']?.toString(),
                        child: Text(
                          _getMemberName(member),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMemberId = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Amount
              Text(
                AppLocalizations.of(context)!.amount,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enterAmount,
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  prefixText: '${widget.contribution['currency'] ?? 'GNF'} ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.amountRequired;
                  }
                  if (double.tryParse(value) == null) {
                    return AppLocalizations.of(context)!.invalidAmount;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Payment Method
              Text(
                AppLocalizations.of(context)!.paymentMethod,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPaymentMethod,
                    hint: Text(
                      AppLocalizations.of(context)!.selectPaymentMethod,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    isExpanded: true,
                    style: Theme.of(context).textTheme.bodyMedium,
                    items: _paymentMethods.map((method) {
                      return DropdownMenuItem<String>(
                        value: method,
                        child: Text(
                          _getPaymentMethodLabel(method),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Transaction ID
              Text(
                AppLocalizations.of(context)!.transactionId,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _transactionIdController,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enterTransactionId,
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 24),

              // Note
              Text(
                AppLocalizations.of(context)!.note,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enterNote,
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
                          : Text(AppLocalizations.of(context)!.saveChanges),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

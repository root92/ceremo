import 'package:flutter/material.dart';
import 'package:ceremo/l10n/app_localizations.dart';
import 'package:ceremo/services/project_service.dart';
import 'package:ceremo/utils/formatters.dart';
import 'package:ceremo/theme/app_colors.dart';
import 'edit_expense_screen.dart';

class ExpenseDetailsScreen extends StatefulWidget {
  final String expenseId;
  final String projectId;

  const ExpenseDetailsScreen({
    super.key,
    required this.expenseId,
    required this.projectId,
  });

  @override
  State<ExpenseDetailsScreen> createState() => _ExpenseDetailsScreenState();
}

class _ExpenseDetailsScreenState extends State<ExpenseDetailsScreen> {
  Map<String, dynamic>? _expense;
  bool _isLoading = true;
  String? _error;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadExpense();
  }

  Future<void> _loadExpense() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get the expense from the project's expenses list
      final expenses = await ProjectService.getProjectExpenses(
        projectId: widget.projectId,
        limit: 100, // Get more expenses to find the specific one
      );
      
      final expense = expenses.firstWhere(
        (e) => e['id'] == widget.expenseId,
        orElse: () => throw Exception('Expense not found'),
      );

      if (mounted) {
        setState(() {
          _expense = expense;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(_hasChanges),
        ),
        title: Text(
          AppLocalizations.of(context)!.expenseDetails,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _editExpense();
                  break;
                case 'share':
                  _shareExpense();
                  break;
                case 'delete':
                  _deleteExpense();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit, size: 20),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.edit),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    const Icon(Icons.share, size: 20),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.share),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.delete,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.error,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadExpense,
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      );
    }

    if (_expense == null) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.expenseNotFound,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            context,
            title: AppLocalizations.of(context)!.expenseInformation,
            children: [
              _buildInfoRow(
                context,
                label: AppLocalizations.of(context)!.amount,
                value: Formatters.formatAmount(
                  _expense!['amount'],
                  currency: _expense!['currency'],
                ),
                color: Colors.red,
              ),
              _buildInfoRow(
                context,
                label: AppLocalizations.of(context)!.reference,
                value: _expense!['reference'] ?? AppLocalizations.of(context)!.notAvailable,
              ),
              _buildInfoRow(
                context,
                label: AppLocalizations.of(context)!.category,
                value: _expense!['category'] ?? AppLocalizations.of(context)!.notAvailable,
              ),
              _buildInfoRow(
                context,
                label: 'Description',
                value: _expense!['description'] ?? AppLocalizations.of(context)!.notAvailable,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          _buildInfoCard(
            context,
            title: AppLocalizations.of(context)!.expenseDetails,
            children: [
              _buildInfoRow(
                context,
                label: AppLocalizations.of(context)!.createdAt,
                value: Formatters.formatDate(
                  _expense!['createdAt'],
                  context: context,
                ),
              ),
              if (_expense!['receiptUrl'] != null)
                _buildInfoRow(
                  context,
                  label: AppLocalizations.of(context)!.receiptUrl,
                  value: _expense!['receiptUrl'],
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Actions
          Text(
            AppLocalizations.of(context)!.actions,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final String currentStatus = (_expense?['status'] ?? '').toString().toLowerCase();

    final bool canApprove = currentStatus == 'pending' || currentStatus == 'rejected';
    final bool canReject = currentStatus == 'pending' || currentStatus == 'approved';
    final bool canEdit = currentStatus == 'pending';
    final bool canDelete = currentStatus == 'pending';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: canApprove ? _approveExpense : null,
                icon: const Icon(Icons.check_circle),
                label: Text(AppLocalizations.of(context)!.approve),
                style: ElevatedButton.styleFrom(
                  backgroundColor: canApprove ? Colors.green : Colors.grey[300],
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(44),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: canReject ? _rejectExpense : null,
                icon: const Icon(Icons.cancel),
                label: Text(AppLocalizations.of(context)!.reject),
                style: ElevatedButton.styleFrom(
                  backgroundColor: canReject ? Colors.orange : Colors.grey[300],
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(44),
                ),
              ),
            ),
          ],
        ),
        if (canEdit || canDelete) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              if (canEdit) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _editExpense,
                    icon: const Icon(Icons.edit),
                    label: Text(AppLocalizations.of(context)!.edit),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                    ),
                  ),
                ),
                if (canDelete) const SizedBox(width: 12),
              ],
              if (canDelete)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _deleteExpense,
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: Text(
                      AppLocalizations.of(context)!.delete,
                      style: const TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  void _approveExpense() {
    _showConfirmation(
      title: AppLocalizations.of(context)!.approve,
      message: 'Approve this expense?',
      onConfirm: () async {
        try {
          await ProjectService.updateExpense(
            expenseId: _expense!['id'],
            amount: _expense!['amount'] is String 
                ? double.parse(_expense!['amount']) 
                : _expense!['amount'].toDouble(),
            description: _expense!['description'] ?? '',
            category: _expense!['category'] ?? '',
            status: 'approved',
          );
          
          setState(() {
            _expense = {
              ...?_expense,
              'status': 'approved',
            };
            _hasChanges = true;
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Expense approved')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to approve expense: $e')),
            );
          }
        }
      },
    );
  }

  void _rejectExpense() {
    _showConfirmation(
      title: AppLocalizations.of(context)!.reject,
      message: 'Reject this expense?',
      onConfirm: () async {
        try {
          await ProjectService.updateExpense(
            expenseId: _expense!['id'],
            amount: _expense!['amount'] is String 
                ? double.parse(_expense!['amount']) 
                : _expense!['amount'].toDouble(),
            description: _expense!['description'] ?? '',
            category: _expense!['category'] ?? '',
            status: 'rejected',
          );
          
          setState(() {
            _expense = {
              ...?_expense,
              'status': 'rejected',
            };
            _hasChanges = true;
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Expense rejected')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to reject expense: $e')),
            );
          }
        }
      },
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color ?? Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editExpense() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditExpenseScreen(
          expenseId: widget.expenseId,
          projectId: widget.projectId,
          expense: _expense!,
        ),
      ),
    ).then((result) {
      if (result == true) {
        // Refresh the expense data
        _loadExpense();
        _hasChanges = true;
      }
    });
  }

  void _shareExpense() {
    // TODO: Implement share expense functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share expense functionality coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _deleteExpense() {
    _showConfirmation(
      title: AppLocalizations.of(context)!.delete,
      message: 'Delete this expense? This action cannot be undone.',
      destructive: true,
      onConfirm: () async {
        try {
          await ProjectService.deleteExpense(
            expenseId: _expense!['id'],
          );
          
          _hasChanges = true;
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Expense deleted')),
            );
            Navigator.of(context).pop(true);
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to delete expense: $e')),
            );
          }
        }
      },
    );
  }

  void _showConfirmation({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    bool destructive = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: destructive ? Colors.red : AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );
  }
}

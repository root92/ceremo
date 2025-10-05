import 'package:flutter/material.dart';
import '../services/project_service.dart';
import '../theme/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../utils/formatters.dart';

class ContributionDetailsScreen extends StatefulWidget {
  final String contributionId;
  final String projectId;
  
  const ContributionDetailsScreen({
    super.key,
    required this.contributionId,
    required this.projectId,
  });

  @override
  State<ContributionDetailsScreen> createState() => _ContributionDetailsScreenState();
}

class _ContributionDetailsScreenState extends State<ContributionDetailsScreen> {
  Map<String, dynamic>? _contribution;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContribution();
  }

  Future<void> _loadContribution() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get the contribution from the project's contributions list
      final contributions = await ProjectService.getProjectContributions(
        projectId: widget.projectId,
        limit: 100, // Get more contributions to find the specific one
      );
      
      final contribution = contributions.firstWhere(
        (c) => c['id'] == widget.contributionId,
        orElse: () => throw Exception('Contribution not found'),
      );
      
      setState(() {
        _contribution = contribution;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.contributionDetails,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () => _showOptionsMenu(context),
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadContribution,
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      );
    }

    if (_contribution == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.contributionNotFound,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContributionHeader(),
          const SizedBox(height: 24),
          _buildContributionInfo(),
          const SizedBox(height: 24),
          _buildContributorInfo(),
          const SizedBox(height: 24),
          _buildPaymentInfo(),
          const SizedBox(height: 24),
          _buildStatusInfo(),
          if (_contribution!['note'] != null) ...[
            const SizedBox(height: 24),
            _buildNotesSection(),
          ],
          const SizedBox(height: 24),
          _buildContributionActions(),
        ],
      ),
    );
  }

  Widget _buildContributionHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getContributionStatusColor(_contribution!['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.people,
                  color: _getContributionStatusColor(_contribution!['status']),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Formatters.formatAmount(
                        _contribution!['amount'],
                        currency: _contribution!['currency'],
                      ),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _contribution!['reference'] ?? 'No Reference',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getContributionStatusColor(_contribution!['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _contribution!['status'] ?? 'Unknown',
                  style: TextStyle(
                    color: _getContributionStatusColor(_contribution!['status']),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            Formatters.formatDate(_contribution!['createdAt'], context: context),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContributionInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.contributionInfo,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            label: AppLocalizations.of(context)!.amount,
            value: Formatters.formatAmount(
              _contribution!['amount'],
              currency: _contribution!['currency'],
            ),
            icon: Icons.attach_money,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            label: AppLocalizations.of(context)!.reference,
            value: _contribution!['reference'] ?? AppLocalizations.of(context)!.notAvailable,
            icon: Icons.tag,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            label: AppLocalizations.of(context)!.status,
            value: _contribution!['status'] ?? 'Unknown',
            icon: Icons.info_outline,
            valueColor: _getContributionStatusColor(_contribution!['status']),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            label: AppLocalizations.of(context)!.createdAt,
            value: Formatters.formatDate(_contribution!['createdAt'], context: context),
            icon: Icons.calendar_today,
          ),
        ],
      ),
    );
  }

  Widget _buildContributorInfo() {
    final member = _contribution!['member'];
    final user = member?['user'];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.contributor,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  (user?['name'] ?? 'U').substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?['name'] ?? 'Unknown User',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?['email'] ?? 'No email',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    if (member?['role'] != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          member!['role'],
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.paymentInfo,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (_contribution!['paymentMethod'] != null)
            _buildInfoRow(
              context,
              label: AppLocalizations.of(context)!.paymentMethod,
              value: _contribution!['paymentMethod'],
              icon: Icons.payment,
            ),
          if (_contribution!['paymentMethod'] != null) const SizedBox(height: 12),
          if (_contribution!['transactionId'] != null)
            _buildInfoRow(
              context,
              label: AppLocalizations.of(context)!.transactionId,
              value: _contribution!['transactionId'],
              icon: Icons.receipt_long,
            ),
        ],
      ),
    );
  }

  Widget _buildStatusInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.status,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getContributionStatusColor(_contribution!['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getContributionStatusIcon(_contribution!['status']),
                  color: _getContributionStatusColor(_contribution!['status']),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _contribution!['status'] ?? 'Unknown',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _getContributionStatusColor(_contribution!['status']),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getContributionStatusDescription(_contribution!['status']),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.notes,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _contribution!['note'],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContributionActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.contributionActions,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final currentStatus = _contribution!['status']?.toLowerCase();
    
    // Business logic: Only pending contributions can be confirmed, edited, or deleted
    // Only confirmed contributions can be marked as received or pending
    final canConfirm = currentStatus == 'pending';
    final canEdit = currentStatus == 'pending';
    final canDelete = currentStatus == 'pending';
    final canMarkReceived = currentStatus == 'confirmed';
    final canMarkPending = currentStatus == 'confirmed';
    
    return Column(
      children: [
        // Primary actions row - only for pending contributions
        if (canConfirm || canEdit) ...[
          Row(
            children: [
              if (canConfirm) ...[
                Expanded(
                  child: _buildActionButton(
                    context,
                    label: AppLocalizations.of(context)!.confirm,
                    icon: Icons.check_circle,
                    color: Colors.green,
                    onPressed: _confirmContribution,
                    semanticLabel: 'Confirm this pending contribution',
                  ),
                ),
                if (canEdit) const SizedBox(width: 12),
              ],
              if (canEdit) ...[
                Expanded(
                  child: _buildActionButton(
                    context,
                    label: AppLocalizations.of(context)!.edit,
                    icon: Icons.edit,
                    color: AppColors.primary,
                    onPressed: _editContribution,
                    semanticLabel: 'Edit this pending contribution',
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
        ],
        
        // Secondary actions row - only for confirmed contributions
        if (canMarkReceived || canMarkPending) ...[
          Row(
            children: [
              if (canMarkReceived) ...[
                Expanded(
                  child: _buildActionButton(
                    context,
                    label: AppLocalizations.of(context)!.markReceived,
                    icon: Icons.done_all,
                    color: Colors.blue,
                    onPressed: _markAsReceived,
                    semanticLabel: 'Mark this confirmed contribution as received',
                  ),
                ),
                if (canMarkPending) const SizedBox(width: 12),
              ],
              if (canMarkPending) ...[
                Expanded(
                  child: _buildActionButton(
                    context,
                    label: AppLocalizations.of(context)!.markPending,
                    icon: Icons.schedule,
                    color: Colors.orange,
                    onPressed: _markAsPending,
                    semanticLabel: 'Mark this confirmed contribution as pending',
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
        ],
        
        // Delete action - only for pending contributions
        if (canDelete) ...[
          _buildActionButton(
            context,
            label: AppLocalizations.of(context)!.delete,
            icon: Icons.delete,
            color: Colors.red,
            onPressed: _deleteContribution,
            isFullWidth: true,
            semanticLabel: 'Delete this pending contribution',
          ),
        ],
        
        // Show message when no actions are available
        if (!canConfirm && !canEdit && !canMarkReceived && !canMarkPending && !canDelete) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.noActionsAvailable,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
    bool isFullWidth = false,
    String? semanticLabel,
  }) {
    final isEnabled = onPressed != null;
    
    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      enabled: isEnabled,
      child: SizedBox(
        width: isFullWidth ? double.infinity : null,
        child: ElevatedButton.icon(
          onPressed: isEnabled ? onPressed : null,
          icon: Icon(icon, size: 18),
          label: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? color : Colors.grey[300],
            foregroundColor: isEnabled ? Colors.white : Colors.grey[600],
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: isEnabled ? 2 : 0,
            minimumSize: const Size(120, 44), // Minimum touch target size
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: valueColor ?? Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.primary),
              title: Text(AppLocalizations.of(context)!.edit),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to edit contribution screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: AppColors.primary),
              title: Text(AppLocalizations.of(context)!.share),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement share functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(
                AppLocalizations.of(context)!.delete,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteContribution),
        content: Text(AppLocalizations.of(context)!.deleteContributionConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete functionality
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Color _getContributionStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'received':
        return Colors.green;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getContributionStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'confirmed':
        return Icons.check_circle;
      case 'received':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _getContributionStatusDescription(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return 'Contribution is pending approval';
      case 'confirmed':
        return 'Contribution has been confirmed';
      case 'received':
        return 'Contribution has been received';
      case 'cancelled':
        return 'Contribution was cancelled';
      default:
        return 'Unknown status';
    }
  }

  // Action methods
  void _confirmContribution() {
    _showConfirmationDialog(
      title: AppLocalizations.of(context)!.confirm,
      message: 'Are you sure you want to confirm this contribution?',
      onConfirm: () async {
        await _updateContributionStatus('confirmed');
      },
    );
  }

  void _editContribution() {
    // TODO: Navigate to edit contribution screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit contribution functionality coming soon'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _markAsReceived() {
    _showConfirmationDialog(
      title: AppLocalizations.of(context)!.markReceived,
      message: 'Mark this contribution as received?',
      onConfirm: () async {
        await _updateContributionStatus('received');
      },
    );
  }

  void _markAsPending() {
    _showConfirmationDialog(
      title: AppLocalizations.of(context)!.markPending,
      message: 'Mark this contribution as pending?',
      onConfirm: () async {
        await _updateContributionStatus('pending');
      },
    );
  }

  void _deleteContribution() {
    _showConfirmationDialog(
      title: AppLocalizations.of(context)!.deleteContribution,
      message: AppLocalizations.of(context)!.deleteContributionConfirmation,
      onConfirm: () async {
        await _performDeleteContribution();
      },
      isDestructive: true,
    );
  }

  void _showConfirmationDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text(
              isDestructive ? AppLocalizations.of(context)!.delete : AppLocalizations.of(context)!.confirm,
              style: TextStyle(
                color: isDestructive ? Colors.red : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateContributionStatus(String status) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );

      // Call the actual GraphQL mutation
      final updatedContribution = await ProjectService.updateContribution(
        contributionId: _contribution!['id'],
        memberId: _contribution!['member']['id'],
        amount: _contribution!['amount'] is String 
            ? double.parse(_contribution!['amount']) 
            : _contribution!['amount'].toDouble(),
        status: status,
      );

      // Close loading dialog
      Navigator.pop(context);

      // Update local state with the updated contribution data
      setState(() {
        _contribution = updatedContribution;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contribution status updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Close loading dialog if still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update contribution: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _performDeleteContribution() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );

      // Call the actual GraphQL mutation
      await ProjectService.deleteContribution(
        contributionId: _contribution!['id'],
      );

      // Close loading dialog
      Navigator.pop(context);

      // Navigate back to project details
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contribution deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Close loading dialog if still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete contribution: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

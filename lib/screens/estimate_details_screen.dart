import 'package:flutter/material.dart';
import 'package:ceremo/l10n/app_localizations.dart';
import 'package:ceremo/services/project_service.dart';
import 'package:ceremo/utils/formatters.dart';
import 'package:ceremo/theme/app_colors.dart';

class EstimateDetailsScreen extends StatefulWidget {
  final String estimateId;
  final String projectId;

  const EstimateDetailsScreen({
    super.key,
    required this.estimateId,
    required this.projectId,
  });

  @override
  State<EstimateDetailsScreen> createState() => _EstimateDetailsScreenState();
}

class _EstimateDetailsScreenState extends State<EstimateDetailsScreen> {
  Map<String, dynamic>? _estimate;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEstimate();
  }

  Future<void> _loadEstimate() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load all estimates for the project and find the specific one
      final estimates = await ProjectService.getProjectEstimates(
        projectId: widget.projectId,
        limit: 100,
      );
      
      final estimate = estimates.firstWhere(
        (e) => e['id'] == widget.estimateId,
        orElse: () => <String, dynamic>{},
      );

      if (mounted) {
        if (estimate.isEmpty) {
          setState(() {
            _error = 'Estimate not found';
            _isLoading = false;
          });
        } else {
          setState(() {
            _estimate = estimate;
            _isLoading = false;
          });
        }
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
        title: Text(AppLocalizations.of(context)!.estimateDetails),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
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
              onPressed: _loadEstimate,
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      );
    }

    if (_estimate == null) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.estimateNotFound,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estimate Information Card
          Container(
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
                  AppLocalizations.of(context)!.estimateInformation,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoRow(
                  context,
                  label: AppLocalizations.of(context)!.estimatedAmount,
                  value: Formatters.formatAmount(
                    _estimate!['estimatedAmount'],
                    currency: _estimate!['currency'],
                  ),
                  color: AppColors.primary,
                ),
                _buildInfoRow(
                  context,
                  label: AppLocalizations.of(context)!.description,
                  value: _estimate!['description'] ?? AppLocalizations.of(context)!.notAvailable,
                ),
                _buildInfoRow(
                  context,
                  label: AppLocalizations.of(context)!.category,
                  value: _estimate!['category'] ?? AppLocalizations.of(context)!.notAvailable,
                ),
                _buildInfoRow(
                  context,
                  label: AppLocalizations.of(context)!.priority,
                  value: _estimate!['priority'] ?? AppLocalizations.of(context)!.notAvailable,
                ),
                _buildInfoRow(
                  context,
                  label: AppLocalizations.of(context)!.status,
                  value: _estimate!['status'] ?? AppLocalizations.of(context)!.notAvailable,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Timestamps Card
          Container(
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
                  'Timestamps',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  context,
                  label: AppLocalizations.of(context)!.estimatedAt,
                  value: Formatters.formatDate(
                    _estimate!['createdAt'],
                    context: context,
                  ),
                ),
                if (_estimate!['updatedAt'] != null)
                  _buildInfoRow(
                    context,
                    label: 'Updated At',
                    value: Formatters.formatDate(
                      _estimate!['updatedAt'],
                      context: context,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
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
}

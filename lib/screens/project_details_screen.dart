import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/projects_provider.dart';
import '../services/project_service.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';
import 'contribution_details_screen.dart';
import 'add_contribution_screen.dart';
import 'add_expense_screen.dart';
import 'expense_details_screen.dart';
import 'estimate_details_screen.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String projectId;
  
  const ProjectDetailsScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  Map<String, dynamic>? _project;
  bool _isLoading = true;
  String? _error;
  late TabController _tabController;
  
  // Data for each tab
  List<Map<String, dynamic>> _contributions = [];
  List<Map<String, dynamic>> _expenses = [];
  List<Map<String, dynamic>> _estimates = [];
  
  // Loading states for each tab
  bool _contributionsLoading = false;
  bool _expensesLoading = false;
  bool _estimatesLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addObserver(this);
    _loadProjectDetails();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Refresh all data when app resumes
      _refreshAllData();
    }
  }


  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      // Trigger rebuild to update FAB per active tab
      setState(() {});
      _loadTabData(_tabController.index);
    }
  }

  void _refreshAllData() {
    // Refresh project details and all tab data
    _loadProjectDetails();
    _loadContributions();
    _loadExpenses();
    _loadEstimates();
  }

  Future<void> _loadTabData(int tabIndex) async {
    if (_project == null) return;

    switch (tabIndex) {
      case 1: // Contributions tab
        if (!_contributionsLoading) {
          await _loadContributions();
        }
        break;
      case 2: // Expenses tab
        if (!_expensesLoading) {
          await _loadExpenses();
        }
        break;
      case 3: // Estimates tab
        if (!_estimatesLoading) {
          await _loadEstimates();
        }
        break;
    }
  }

  Future<void> _loadContributions() async {
    setState(() {
      _contributionsLoading = true;
    });

    try {
      final contributions = await ProjectService.getProjectContributions(
        projectId: widget.projectId,
        limit: 50,
      );
      
      if (mounted) {
        setState(() {
          _contributions = contributions;
          _contributionsLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _contributionsLoading = false;
        });
      }
    }
  }

  Future<void> _loadExpenses() async {
    setState(() {
      _expensesLoading = true;
    });

    try {
      final expenses = await ProjectService.getProjectExpenses(
        projectId: widget.projectId,
        limit: 50,
      );
      
      if (mounted) {
        setState(() {
          _expenses = expenses;
          _expensesLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _expensesLoading = false;
        });
      }
    }
  }

  Future<void> _loadEstimates() async {
    setState(() {
      _estimatesLoading = true;
    });

    try {
      final estimates = await ProjectService.getProjectEstimates(
        projectId: widget.projectId,
        limit: 50,
      );
      
      if (mounted) {
        setState(() {
          _estimates = estimates;
          _estimatesLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _estimatesLoading = false;
        });
      }
    }
  }

  @override

  Future<void> _loadProjectDetails() async {
    try {
      final projectsProvider = context.read<ProjectsProvider>();
      final project = await projectsProvider.getProjectDetails(widget.projectId);
      
      if (mounted) {
        setState(() {
          _project = project;
          _isLoading = false;
          _error = null;
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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.projectDetails),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.projectDetails),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProjectDetails,
                child: Text(AppLocalizations.of(context)!.tryAgain),
              ),
            ],
          ),
        ),
      );
    }

    if (_project == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.projectDetails),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
        ),
        body: Center(
          child: Text(
            AppLocalizations.of(context)!.projectNotFound,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          _project!['name'] ?? AppLocalizations.of(context)!.projectDetails,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.grey[600],
            ),
            onPressed: () {
              // TODO: Navigate to edit project
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey[500],
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: [
                Tab(text: AppLocalizations.of(context)!.home),
                Tab(text: AppLocalizations.of(context)!.contributions),
                Tab(text: AppLocalizations.of(context)!.expenses),
                Tab(text: AppLocalizations.of(context)!.estimate),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHomeTab(context),
          _buildContributionsTab(context),
          _buildExpensesTab(context),
          _buildEstimateTab(context),
        ],
      ),
      floatingActionButton: _buildFabForTab(_tabController.index),
    );
  }

  Widget? _buildFabForTab(int tabIndex) {
    switch (tabIndex) {
      case 1: // Contributions
        return FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => AddContributionScreen(
                      projectId: widget.projectId,
                      projectCurrency: _project!['currency'] ?? 'GNF',
                    ),
                  ),
                )
                .then((success) {
              if (success == true) {
                _loadProjectDetails();
                _loadContributions();
              }
            });
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        );
      case 2: // Expenses
        return FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => AddExpenseScreen(
                      projectId: widget.projectId,
                      projectCurrency: _project!['currency'] ?? 'GNF',
                    ),
                  ),
                )
                .then((_) {
                  // Refresh expenses when returning from add expense
                  _loadExpenses();
                });
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        );
      case 3: // Estimates
        return null; // No FAB for estimates tab
      default:
        return null; // No FAB on Home tab
    }
  }

  // Tab Builders
  Widget _buildHomeTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Header Card
          Container(
            width: double.infinity,
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
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _getProjectTypeColor(_project!['type']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getProjectTypeIcon(_project!['type']),
                        color: _getProjectTypeColor(_project!['type']),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _project!['name'] ?? 'Untitled Project',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_project!['type'] ?? 'Project'} • ${_getStatusText(_project!['status'])}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(_project!['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(_project!['status']),
                        style: TextStyle(
                          color: _getStatusColor(_project!['status']),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_project!['description'] != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _project!['description'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Progress Section
          Text(
            AppLocalizations.of(context)!.progress,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Container(
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.progress,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${(_project!['progressPercentage'] ?? 0.0).toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: (_project!['progressPercentage'] ?? 0.0) / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Financial Information
          Text(
            AppLocalizations.of(context)!.financialInfo,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  context,
                  title: AppLocalizations.of(context)!.targetAmount,
                  value: '${(_project!['targetAmount'] ?? 0.0).toStringAsFixed(0)} ${_project!['currency'] ?? 'USD'}',
                  icon: Icons.flag,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  context,
                  title: AppLocalizations.of(context)!.currentBalance,
                  value: '${(_project!['currentBalance'] ?? 0.0).toStringAsFixed(0)} ${_project!['currency'] ?? 'USD'}',
                  icon: Icons.account_balance_wallet,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Project Information
          Text(
            AppLocalizations.of(context)!.projectInfo,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Container(
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
              children: [
                _buildInfoRow(
                  context,
                  label: AppLocalizations.of(context)!.createdAt,
                  value: Formatters.formatDate(_project!['createdAt'], context: context),
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  context,
                  label: AppLocalizations.of(context)!.updatedAt,
                  value: Formatters.formatDate(_project!['updatedAt'], context: context),
                  icon: Icons.update,
                ),
                if (_project!['country'] != null) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    context,
                    label: AppLocalizations.of(context)!.country,
                    value: _project!['country'],
                    icon: Icons.public,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContributionsTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _loadContributions();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
            AppLocalizations.of(context)!.contributions,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          if (_contributionsLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_contributions.isEmpty)
            _buildEmptyState(
              context,
              icon: Icons.people_outline,
              title: AppLocalizations.of(context)!.noContributions,
              subtitle: AppLocalizations.of(context)!.noContributionsSubtitle,
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _contributions.length,
              itemBuilder: (context, index) {
                final contribution = _contributions[index];
                return _buildContributionCard(context, contribution);
              },
            ),
        ],
      ),
    ),
    );
  }

  Widget _buildExpensesTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _loadExpenses();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
            AppLocalizations.of(context)!.expenses,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          if (_expensesLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_expenses.isEmpty)
            _buildEmptyState(
              context,
              icon: Icons.receipt_long_outlined,
              title: AppLocalizations.of(context)!.noExpenses,
              subtitle: AppLocalizations.of(context)!.noExpensesSubtitle,
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final expense = _expenses[index];
                return _buildExpenseCard(context, expense);
              },
            ),
        ],
      ),
    ),
    );
  }

  Widget _buildEstimateTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _loadEstimates();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
            AppLocalizations.of(context)!.estimate,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Financial Summary
          Container(
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
              children: [
                _buildEstimateRow(
                  context,
                  label: AppLocalizations.of(context)!.totalContributions,
                  value: '${(_project!['totalContributions'] ?? 0.0).toStringAsFixed(0)} ${_project!['currency'] ?? 'USD'}',
                  color: Colors.green,
                ),
                const SizedBox(height: 12),
                _buildEstimateRow(
                  context,
                  label: AppLocalizations.of(context)!.totalExpenses,
                  value: '${(_project!['totalExpenses'] ?? 0.0).toStringAsFixed(0)} ${_project!['currency'] ?? 'USD'}',
                  color: Colors.red,
                ),
                const SizedBox(height: 12),
                _buildEstimateRow(
                  context,
                  label: AppLocalizations.of(context)!.netBalance,
                  value: '${((_project!['totalContributions'] ?? 0.0) - (_project!['totalExpenses'] ?? 0.0)).toStringAsFixed(0)} ${_project!['currency'] ?? 'USD'}',
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Estimates List
          Text(
            'Project Estimates',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          if (_estimatesLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_estimates.isEmpty)
            _buildEmptyState(
              context,
              icon: Icons.analytics_outlined,
              title: 'No Estimates',
              subtitle: 'No estimates have been created for this project yet.',
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _estimates.length,
              itemBuilder: (context, index) {
                final estimate = _estimates[index];
                return _buildEstimateCard(context, estimate);
              },
            ),
        ],
      ),
    ),
    );
  }

  // Helper Widgets
  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
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
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContributionCard(BuildContext context, Map<String, dynamic> contribution) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContributionDetailsScreen(
              contributionId: contribution['id'],
              projectId: widget.projectId,
            ),
          ),
        ).then((success) {
          if (success == true) {
            // Refresh the contributions list when returning from contribution details
            _loadContributions();
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Amount section
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Formatters.formatAmount(
                      contribution['amount'],
                      currency: contribution['currency'],
                      projectCurrency: _project?['currency'],
                    ),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contribution['member']?['user']?['name'] ?? 'Unknown',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Status section
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getContributionStatusColor(contribution['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      contribution['status'] ?? 'Unknown',
                      style: TextStyle(
                        color: _getContributionStatusColor(contribution['status']),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.formatDate(contribution['createdAt'], context: context),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseCard(BuildContext context, Map<String, dynamic> expense) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExpenseDetailsScreen(
              expenseId: expense['id'],
              projectId: widget.projectId,
            ),
          ),
        ).then((success) {
          if (success == true) {
            // Refresh the expenses list when returning from expense details
            _loadExpenses();
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
        children: [
          // Amount section
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Formatters.formatAmount(
                    expense['amount'],
                    currency: expense['currency'],
                    projectCurrency: _project?['currency'],
                  ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  expense['description'] ?? expense['category'] ?? 'Expense',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Status section
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getExpenseStatusColor(expense['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    expense['status'] ?? 'Unknown',
                    style: TextStyle(
                      color: _getExpenseStatusColor(expense['status']),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Formatters.formatDate(expense['createdAt'], context: context),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildEstimateRow(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // Helper Methods
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'paused':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return AppLocalizations.of(context)!.active;
      case 'completed':
        return AppLocalizations.of(context)!.completed;
      case 'paused':
        return AppLocalizations.of(context)!.paused;
      case 'cancelled':
        return AppLocalizations.of(context)!.cancelled;
      default:
        return status ?? '';
    }
  }

  Color _getContributionStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getExpenseStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }


  Color _getProjectTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'wedding':
        return AppColors.wedding;
      case 'birthday':
        return AppColors.birthday;
      case 'corporate':
        return AppColors.corporate;
      case 'religious':
        return AppColors.religious;
      default:
        return Colors.grey;
    }
  }

  IconData _getProjectTypeIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'wedding':
        return Icons.favorite;
      case 'birthday':
        return Icons.cake;
      case 'corporate':
        return Icons.business;
      case 'religious':
        return Icons.church;
      default:
        return Icons.event;
    }
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstimateCard(BuildContext context, Map<String, dynamic> estimate) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EstimateDetailsScreen(
              estimateId: estimate['id'],
              projectId: widget.projectId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
        children: [
          // Amount section
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Formatters.formatAmount(
                    estimate['estimatedAmount'],
                    currency: estimate['currency'],
                    projectCurrency: _project?['currency'],
                  ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  estimate['description'] ?? estimate['category'] ?? 'Estimate',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Status section
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(estimate['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    estimate['status'] ?? 'Unknown',
                    style: TextStyle(
                      color: _getStatusColor(estimate['status']),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Formatters.formatDate(estimate['createdAt'], context: context),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

}

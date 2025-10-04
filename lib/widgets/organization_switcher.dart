import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/organization_context_provider.dart';
import '../theme/app_colors.dart';

class OrganizationSwitcher extends StatelessWidget {
  const OrganizationSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrganizationContextProvider>(
      builder: (context, orgProvider, child) {
        if (orgProvider.isLoading) {
          return const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        if (!orgProvider.hasCurrentOrganization) {
          return IconButton(
            icon: const Icon(Icons.business_outlined),
            onPressed: () {
              _showOrganizationSelector(context, orgProvider);
            },
            tooltip: 'Select Organization',
          );
        }

        final currentOrg = orgProvider.currentOrganization!;
        
        return PopupMenuButton<Map<String, dynamic>>(
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  _getOrgTypeIcon(currentOrg['orgType']),
                  color: AppColors.primary,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  currentOrg['name'] ?? 'Organization',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, size: 16),
            ],
          ),
          onSelected: (Map<String, dynamic> organization) {
            orgProvider.switchOrganization(organization);
          },
          itemBuilder: (BuildContext context) {
            return orgProvider.organizations.map((organization) {
              final isSelected = organization['id'] == currentOrg['id'];
              
              return PopupMenuItem<Map<String, dynamic>>(
                value: organization,
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        _getOrgTypeIcon(organization['orgType']),
                        color: AppColors.primary,
                        size: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            organization['name'] ?? 'Organization',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          if (organization['orgType'] != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              _getOrgTypeLabel(organization['orgType']),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.check,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ],
                  ],
                ),
              );
            }).toList()
              ..add(
                const PopupMenuItem<Map<String, dynamic>>(
                  enabled: false,
                  child: Divider(),
                ),
              )
              ..add(
                PopupMenuItem<Map<String, dynamic>>(
                  value: null,
                  child: Row(
                    children: [
                      const Icon(Icons.add, size: 20),
                      const SizedBox(width: 12),
                      const Text('Create Organization'),
                    ],
                  ),
                ),
              );
          },
        );
      },
    );
  }

  void _showOrganizationSelector(BuildContext context, OrganizationContextProvider orgProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Organization'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: orgProvider.organizations.length,
              itemBuilder: (context, index) {
                final organization = orgProvider.organizations[index];
                return ListTile(
                  leading: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getOrgTypeIcon(organization['orgType']),
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                  title: Text(organization['name'] ?? 'Organization'),
                  subtitle: Text(_getOrgTypeLabel(organization['orgType'])),
                  onTap: () {
                    orgProvider.switchOrganization(organization);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  IconData _getOrgTypeIcon(String? orgType) {
    switch (orgType) {
      case 'personal':
        return Icons.person;
      case 'business':
      case 'ngo':
      case 'government':
        return Icons.business;
      default:
        return Icons.business_outlined;
    }
  }

  String _getOrgTypeLabel(String? orgType) {
    switch (orgType) {
      case 'personal':
        return 'Personal';
      case 'business':
        return 'Business';
      case 'ngo':
        return 'NGO';
      case 'government':
        return 'Government';
      default:
        return 'Organization';
    }
  }
}

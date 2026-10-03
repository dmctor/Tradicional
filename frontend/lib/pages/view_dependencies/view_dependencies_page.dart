import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/custom_nav_bar.dart';
import 'package:helloworld/pages/view_dependencies/view_dependencies_controller.dart';


class ViewDependenciesPage extends StatelessWidget {
  final String companyId;
  final String companyName;

  const ViewDependenciesPage({
    Key? key,
    required this.companyId,
    required this.companyName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewDependenciesController());
    controller.loadDependencies(companyId);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
          child: AppBar(
            title: Text(
              '$companyName',
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.87),
                fontSize: 20,
              ),
            ),
            backgroundColor: colorScheme.surface,
            elevation: 0,
            iconTheme: IconThemeData(
              color: colorScheme.onSurface.withOpacity(0.87),
            ),
            centerTitle: true,
          ),
        ),
      ),
      backgroundColor: colorScheme.surface,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: colorScheme.primary,
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.dependencies.length,
          itemBuilder: (context, index) {
            final dep = controller.dependencies[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: colorScheme.surfaceContainerHighest,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dep.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(context, 'Firma:', _formatDate(dep.signDate)),
                    _buildInfoRow(context, 'Vigencia:', dep.validityTime),
                    _buildInfoRow(context, 'Fin contrato:', _formatDate(dep.terminationDate)),
                    _buildInfoRow(context, 'Aniversario:', dep.anniversary),
                    const SizedBox(height: 12),
                    Text(
                      'Equipos:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    ...dep.equipment.split(', ').map((e) => Text(
                      '• $e',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    )).toList(),
                    const SizedBox(height: 16),
Center(
  child: ElevatedButton(
    onPressed: () {
  Navigator.pushNamed(
    context,
    '/view-contacts',
    arguments: {
      'dependency': dep,
    },
  );
},
    style: ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24, vertical: 12),
    ),
    child: const Text('Contactos'),
  ),
),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: const CustomNavBar(selectedIndex: 1),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
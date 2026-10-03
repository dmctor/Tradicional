import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view_companies_controller.dart';
import '../../components/custom_nav_bar.dart';
import '../../models/entities/company.dart';
import '../../models/entities/address.dart';

class ViewCompaniesPage extends StatelessWidget {
  final ViewCompaniesController controller = Get.put(ViewCompaniesController());

  Widget _buildCompanyCard(BuildContext context, Company company, Address? address) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/view-dependencies',
          arguments: {
            'companyId': company.id.toString(),
            'companyName': company.name,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('RUC: ${company.ruc}', 
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        )),
                    Text('Dirección: ${address?.address ?? 'N/A'}', 
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        )),
                    Text('Distrito: ${address?.district ?? 'N/A'}', 
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        )),
                    Text('Provincia: ${address?.province ?? 'N/A'}', 
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        )),
                    Text('Departamento: ${address?.department ?? 'N/A'}', 
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        )),
                    const SizedBox(height: 8),
                    Text(
                      'Sector: ${address?.sector ?? 'N/A'}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, 
                  size: 16, 
                  color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar empresas...',
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              suffixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 50, bottom: 20),
          alignment: Alignment.center,
          child: Text(
            'Empresas',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
        _buildSearchSection(context),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                ),
              );
            }
            
            if (controller.companies.isEmpty) {
              return Center(
                child: Text(
                  'No se encontraron empresas',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              );
            }
            
            return RefreshIndicator(
              color: colorScheme.primary,
              onRefresh: () => controller.loadCompaniesAndAddresses(),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: controller.companies.length,
                itemBuilder: (context, index) {
                  final company = controller.companies[index];
                  final address = controller.getAddressForCompany(company.addressId);
                  return _buildCompanyCard(context, company, address);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      resizeToAvoidBottomInset: false,
      appBar: null,
      bottomNavigationBar: const CustomNavBar(selectedIndex: 1),
      body: _buildBody(context),
    );
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'financial_statement_controller.dart';
import '../../components/custom_nav_bar.dart';

class FinancialStatementPage extends StatelessWidget {
  FinancialStatementPage({super.key});

  final FinancialStatementController control =
      Get.put(FinancialStatementController());

  /// Aquí va el contenido principal de la pantalla
  Widget _buildBody(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Título
            Text(
              'Estado Financiero',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            // Contenido principal
            Expanded(
              child: Obx(() {
                if (control.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sección Ingresos
                      _buildSectionTitle('Ingresos', colorScheme, textTheme),
                      const SizedBox(height: 10),
                      // Botón de filtro para Ingresos
                      _buildFilterButton(
                        context,
                        'Filtrar Ingresos',
                        Icons.filter_list,
                        () => _showIngresosFilterDialog(context),
                        colorScheme,
                        textTheme,
                        isIngresos: true,
                      ),
                      const SizedBox(height: 10),
                      _buildIngresosTable(colorScheme, textTheme),
                      const SizedBox(height: 20),
                      // Sección Egresos
                      _buildSectionTitle('Egresos', colorScheme, textTheme),
                      const SizedBox(height: 10),
                      // Botón de filtro para Egresos
                      _buildFilterButton(
                        context,
                        'Filtrar Egresos',
                        Icons.filter_list,
                        () => _showEgresosFilterDialog(context),
                        colorScheme,
                        textTheme,
                        isIngresos: false,
                      ),
                      const SizedBox(height: 10),
                      _buildEgresosTable(colorScheme, textTheme),
                      const SizedBox(height: 20),
                      // Sección Resumen
                      _buildSummaryCard(colorScheme, textTheme),
                      const SizedBox(height: 20),
                      // Botón "Limpiar todos los filtros"
                      _buildClearAllFiltersButton(colorScheme, textTheme),
                    ],
                  ),
                );
              }),
            ),
            // Botón EXPORTAR / COMPARTIR
            Center(
              child: ElevatedButton(
                onPressed: () => showExportDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('EXPORTAR Y COMPARTIR'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildClearAllFiltersButton(
      ColorScheme colorScheme, TextTheme textTheme) {
    return Obx(() {
      final hayFiltros =
          control.hayFiltrosIngresosActivos || control.hayFiltrosEgresosActivos;

      if (!hayFiltros) return const SizedBox.shrink();

      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ElevatedButton.icon(
            onPressed: () {
              control.limpiarFiltrosIngresos();
              control.limpiarFiltrosEgresos();
            },
            icon: const Icon(Icons.clear_all),
            label: const Text('Limpiar todos los filtros'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.errorContainer,
              foregroundColor: colorScheme.onErrorContainer,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFilterButton(BuildContext context, String text, IconData icon,
      VoidCallback onPressed, ColorScheme colorScheme, TextTheme textTheme,
      {bool isIngresos = true}) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 18),
            label: Text(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Indicador de filtros activos
          Obx(() {
            final hayFiltros = isIngresos
                ? control.hayFiltrosIngresosActivos
                : control.hayFiltrosEgresosActivos;

            if (!hayFiltros) return const SizedBox.shrink();

            final resumen = isIngresos
                ? control.resumenFiltrosIngresos
                : control.resumenFiltrosEgresos;

            return Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.filter_list,
                    size: 12,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    resumen,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      if (isIngresos) {
                        control.limpiarFiltrosIngresos();
                      } else {
                        control.limpiarFiltrosEgresos();
                      }
                    },
                    child: Icon(
                      Icons.close,
                      size: 12,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
      String title, ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  Widget _buildIngresosTable(ColorScheme colorScheme, TextTheme textTheme) {
    return Obx(() {
      if (control.ingresos.isEmpty) {
        return _buildEmptyState(
            'No hay ingresos registrados', colorScheme, textTheme);
      }

      return Card(
        elevation: 2,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text('Nombre',
                          style: textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 2,
                      child: Text('RUC',
                          style: textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 2,
                      child: Text('Fecha',
                          style: textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 2,
                      child: Text('Dep.',
                          style: textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 2,
                      child: Text('Monto',
                          style: textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            // Datos
            ...control.ingresos.map((item) => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: colorScheme.outline.withOpacity(0.2))),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Text(item.name, style: textTheme.bodySmall)),
                      Expanded(
                          flex: 2,
                          child: Text(item.ruc, style: textTheme.bodySmall)),
                      Expanded(
                          flex: 2,
                          child: Text(item.date, style: textTheme.bodySmall)),
                      Expanded(
                          flex: 2,
                          child: Text(item.dependency,
                              style: textTheme.bodySmall)),
                      Expanded(
                          flex: 2,
                          child: Text(item.amount,
                              style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green))),
                    ],
                  ),
                )),
            // Total
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 9,
                      child: Text('Total Ingresos',
                          style: textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 2,
                      child: Text(
                          'S/ ${control.totalIngresos.value.toStringAsFixed(2)}',
                          style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green))),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildEgresosTable(ColorScheme colorScheme, TextTheme textTheme) {
    return Obx(() {
      if (control.egresos.isEmpty) {
        return _buildEmptyState(
            'No hay egresos registrados', colorScheme, textTheme);
      }

      return Card(
        elevation: 2,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text('Nombre',
                          style: textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 2,
                      child: Text('RUC',
                          style: textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 2,
                      child: Text('Fecha',
                          style: textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 2,
                      child: Text('ISP',
                          style: textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 2,
                      child: Text('Monto',
                          style: textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            // Datos
            ...control.egresos.map((item) => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: colorScheme.outline.withOpacity(0.2))),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Text(item.name, style: textTheme.bodySmall)),
                      Expanded(
                          flex: 2,
                          child: Text(item.ruc, style: textTheme.bodySmall)),
                      Expanded(
                          flex: 2,
                          child: Text(item.date, style: textTheme.bodySmall)),
                      Expanded(
                          flex: 2,
                          child: Text(item.ispName ?? '',
                              style: textTheme.bodySmall)),
                      Expanded(
                          flex: 2,
                          child: Text(item.amount,
                              style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red))),
                    ],
                  ),
                )),
            // Total
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 9,
                      child: Text('Total Egresos',
                          style: textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 2,
                      child: Text(
                          'S/ ${control.totalEgresos.value.toStringAsFixed(2)}',
                          style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.red))),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryCard(ColorScheme colorScheme, TextTheme textTheme) {
    return Obx(() {
      final saldo = control.saldoTotal.value;
      final isPositive = saldo >= 0;

      return Card(
        elevation: 4,
        color: isPositive
            ? colorScheme.primaryContainer
            : colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Resumen Financiero',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isPositive
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onErrorContainer,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Ingresos:', style: textTheme.bodyLarge),
                  Text('S/ ${control.totalIngresos.value.toStringAsFixed(2)}',
                      style: textTheme.bodyLarge?.copyWith(
                          color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Egresos:', style: textTheme.bodyLarge),
                  Text('S/ ${control.totalEgresos.value.toStringAsFixed(2)}',
                      style: textTheme.bodyLarge?.copyWith(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Utilidad Total:',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text('S/ ${saldo.toStringAsFixed(2)}',
                      style: textTheme.titleMedium?.copyWith(
                        color: isPositive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState(
      String message, ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
  void _showIngresosFilterDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Variables para filtros específicos de INGRESOS (solo 5 campos)
    RxBool nombreEnabled = false.obs;
    RxString nombreText = ''.obs;
    TextEditingController nombreController = TextEditingController();

    RxBool rucEnabled = false.obs;
    RxString rucText = ''.obs;
    TextEditingController rucController = TextEditingController();

    RxBool dependenciaEnabled = false.obs;
    RxString dependenciaText = ''.obs;
    TextEditingController dependenciaController = TextEditingController();

    // Rango de fechas
    Rx<DateTime?> fechaInicio = Rx(null);
    Rx<DateTime?> fechaFin = Rx(null);

    // Rango de montos
    RxDouble montoMin = 0.0.obs;
    RxDouble montoMax = 10000.0.obs;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: const Color(0xFFF3E5F5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  'Filtrar Ingresos',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                // Contenido scrollable
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filtros específicos para INGRESOS (3 campos de texto)
                        _buildFilterWithTextField(
                          'Nombre',
                          nombreEnabled,
                          nombreController,
                          nombreText,
                          textTheme,
                        ),
                        const SizedBox(height: 12),
                        _buildFilterWithTextField(
                          'RUC',
                          rucEnabled,
                          rucController,
                          rucText,
                          textTheme,
                        ),
                        const SizedBox(height: 12),
                        _buildFilterWithTextField(
                          'Dependencia',
                          dependenciaEnabled,
                          dependenciaController,
                          dependenciaText,
                          textTheme,
                        ),
                        const SizedBox(height: 20),

                        // Sección de rango de fechas
                        Text(
                          'Rango de fechas',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildDateRangeSection(
                          context,
                          fechaInicio,
                          fechaFin,
                          textTheme,
                          colorScheme,
                        ),
                        const SizedBox(height: 20),

                        // Sección de rango de montos
                        Text(
                          'Rango de montos',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildMontoRangeSection(
                          montoMin,
                          montoMax,
                          textTheme,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Botón de filtrar
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6A1B9A),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Aplicar filtros de INGRESOS
                        _applyIngresosFilters(
                          nombreEnabled.value,
                          nombreText.value,
                          rucEnabled.value,
                          rucText.value,
                          dependenciaEnabled.value,
                          dependenciaText.value,
                          fechaInicio.value,
                          fechaFin.value,
                          montoMin.value,
                          montoMax.value,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A1B9A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'FILTRAR INGRESOS',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// FILTRO DE EGRESOS CORREGIDO - Solo 5 campos
  void _showEgresosFilterDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Variables para filtros específicos de EGRESOS (solo 5 campos)
    RxBool nombreEnabled = false.obs;
    RxString nombreText = ''.obs;
    TextEditingController nombreController = TextEditingController();

    RxBool rucEnabled = false.obs;
    RxString rucText = ''.obs;
    TextEditingController rucController = TextEditingController();

    RxBool ispEnabled = false.obs;
    RxString ispText = ''.obs;
    TextEditingController ispController = TextEditingController();

    // Rango de fechas
    Rx<DateTime?> fechaInicio = Rx(null);
    Rx<DateTime?> fechaFin = Rx(null);

    // Rango de montos
    RxDouble montoMin = 0.0.obs;
    RxDouble montoMax = 10000.0.obs;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: const Color(0xFFF3E5F5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  'Filtrar Egresos',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                // Contenido scrollable
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filtros específicos para EGRESOS (3 campos de texto)
                        _buildFilterWithTextField(
                          'Nombre',
                          nombreEnabled,
                          nombreController,
                          nombreText,
                          textTheme,
                        ),
                        const SizedBox(height: 12),
                        _buildFilterWithTextField(
                          'RUC',
                          rucEnabled,
                          rucController,
                          rucText,
                          textTheme,
                        ),
                        const SizedBox(height: 12),
                        _buildFilterWithTextField(
                          'ISP',
                          ispEnabled,
                          ispController,
                          ispText,
                          textTheme,
                        ),
                        const SizedBox(height: 20),

                        // Sección de rango de fechas
                        Text(
                          'Rango de fechas',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildDateRangeSection(
                          context,
                          fechaInicio,
                          fechaFin,
                          textTheme,
                          colorScheme,
                        ),
                        const SizedBox(height: 20),

                        // Sección de rango de montos
                        Text(
                          'Rango de montos',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildMontoRangeSection(
                          montoMin,
                          montoMax,
                          textTheme,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Botón de filtrar
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6A1B9A),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Aplicar filtros de EGRESOS
                        _applyEgresosFilters(
                          nombreEnabled.value,
                          nombreText.value,
                          rucEnabled.value,
                          rucText.value,
                          ispEnabled.value,
                          ispText.value,
                          fechaInicio.value,
                          fechaFin.value,
                          montoMin.value,
                          montoMax.value,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A1B9A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'FILTRAR EGRESOS',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterWithTextField(
    String title,
    RxBool isEnabled,
    TextEditingController controller,
    RxString textValue,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila con checkbox y título
          Row(
            children: [
              // Checkbox
              Obx(() => Checkbox(
                    value: isEnabled.value,
                    onChanged: (bool? newValue) {
                      isEnabled.value = newValue ?? false;
                      if (!isEnabled.value) {
                        controller.clear();
                        textValue.value = '';
                      }
                    },
                    activeColor: const Color(0xFF6A1B9A),
                    checkColor: Colors.white,
                  )),
              const SizedBox(width: 8),
              // Título
              Expanded(
                child: Text(
                  title,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // TextField (siempre visible pero habilitado/deshabilitado según checkbox)
          Obx(() => TextField(
                controller: controller,
                enabled: isEnabled.value,
                decoration: InputDecoration(
                  hintText: 'Ingresar...',
                  hintStyle: textTheme.bodySmall?.copyWith(
                    color: isEnabled.value
                        ? Colors.grey.shade600
                        : Colors.grey.shade400,
                  ),
                  filled: true,
                  fillColor:
                      isEnabled.value ? Colors.white : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFF6A1B9A),
                      width: 2,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isEnabled.value
                        ? Colors.grey.shade600
                        : Colors.grey.shade400,
                    size: 20,
                  ),
                ),
                style: textTheme.bodyMedium?.copyWith(
                  color:
                      isEnabled.value ? Colors.black87 : Colors.grey.shade400,
                ),
                onChanged: (value) {
                  if (isEnabled.value) {
                    textValue.value = value;
                  }
                },
              )),
        ],
      ),
    );
  }

  Widget _buildDateRangeSection(
    BuildContext context,
    Rx<DateTime?> fechaInicio,
    Rx<DateTime?> fechaFin,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Fecha de inicio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'D',
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate:
                                    fechaInicio.value ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                fechaInicio.value = date;
                              }
                            },
                            child: Center(
                              child: Text(
                                fechaInicio.value?.day
                                        .toString()
                                        .padLeft(2, '0') ??
                                    'DD',
                                style: textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Mes de inicio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'M',
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              fechaInicio.value?.month
                                      .toString()
                                      .padLeft(2, '0') ??
                                  'MM',
                              style: textTheme.bodyMedium,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Año de inicio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A',
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              fechaInicio.value?.year.toString() ?? 'AAAA',
                              style: textTheme.bodyMedium,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Separador
              Container(
                width: 20,
                height: 2,
                color: Colors.black,
              ),
              const SizedBox(width: 16),
              // Fecha de fin
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'D',
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: fechaFin.value ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                fechaFin.value = date;
                              }
                            },
                            child: Center(
                              child: Text(
                                fechaFin.value?.day
                                        .toString()
                                        .padLeft(2, '0') ??
                                    'DD',
                                style: textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Mes de fin
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'M',
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              fechaFin.value?.month
                                      .toString()
                                      .padLeft(2, '0') ??
                                  'MM',
                              style: textTheme.bodyMedium,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Año de fin
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A',
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              fechaFin.value?.year.toString() ?? 'AAAA',
                              style: textTheme.bodyMedium,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMontoRangeSection(
    RxDouble montoMin,
    RxDouble montoMax,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monto Mín',
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(() => TextField(
                            controller: TextEditingController(
                              text: montoMin.value.toStringAsFixed(0),
                            ),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onChanged: (value) {
                              montoMin.value = double.tryParse(value) ?? 0.0;
                            },
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Separador
              Container(
                width: 20,
                height: 2,
                color: Colors.black,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monto Max',
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(() => TextField(
                            controller: TextEditingController(
                              text: montoMax.value.toStringAsFixed(0),
                            ),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onChanged: (value) {
                              montoMax.value =
                                  double.tryParse(value) ?? 10000.0;
                            },
                          )),
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

  void _applyIngresosFilters(
    bool nombreEnabled,
    String nombreText,
    bool rucEnabled,
    String rucText,
    bool dependenciaEnabled,
    String dependenciaText,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    double montoMin,
    double montoMax,
  ) {
    control.aplicarFiltrosIngresos(
      nombreEnabled: nombreEnabled,
      nombreText: nombreText,
      rucEnabled: rucEnabled,
      rucText: rucText,
      dependenciaEnabled: dependenciaEnabled,
      dependenciaText: dependenciaText,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
      montoMin: montoMin,
      montoMax: montoMax,
    );
  }

  void _applyEgresosFilters(
    bool nombreEnabled,
    String nombreText,
    bool rucEnabled,
    String rucText,
    bool ispEnabled,
    String ispText,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    double montoMin,
    double montoMax,
  ) {
    control.aplicarFiltrosEgresos(
      nombreEnabled: nombreEnabled,
      nombreText: nombreText,
      rucEnabled: rucEnabled,
      rucText: rucText,
      ispEnabled: ispEnabled,
      ispText: ispText,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
      montoMin: montoMin,
      montoMax: montoMax,
    );
  }

  void showExportDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    String selected = 'excel';

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: colorScheme.tertiaryContainer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => selected = 'excel'),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: selected == 'excel'
                                      ? colorScheme.primaryContainer
                                      : Colors.transparent,
                                ),
                                child: Column(
                                  children: [
                                    Image.asset('assets/images/excel.png',
                                        width: 64),
                                    const SizedBox(height: 8),
                                    Text('Excel', style: textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => selected = 'pdf'),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: selected == 'pdf'
                                      ? colorScheme.primaryContainer
                                      : Colors.transparent,
                                ),
                                child: Column(
                                  children: [
                                    Image.asset('assets/images/pdf.png',
                                        width: 64),
                                    const SizedBox(height: 8),
                                    Text('PDF', style: textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  // Línea horizontal más visible
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: colorScheme.outline,
                  ),
                  // Botones ocupan toda la parte inferior
                  SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              foregroundColor: colorScheme.primary,
                            ),
                            child:
                                Text('Cancelar', style: textTheme.labelLarge),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: double.infinity,
                          color: colorScheme.outline,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context); // cerrar modal
                              Future.microtask(
                                  () => _exportWithLoader(context, selected));
                            },
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20)),
                              ),
                              foregroundColor: colorScheme.primary,
                            ),
                            child:
                                Text('Exportar', style: textTheme.labelLarge),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _exportWithLoader(BuildContext context, String selected) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final navigator =
        Navigator.of(context, rootNavigator: true); // ✅ guardado válido
    final messenger = ScaffoldMessenger.of(context);

    // Mostrar loader
    navigator.push(
      DialogRoute(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: colorScheme.surface,
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text('Generando archivo...', style: textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );

    try {
      File file;
      if (selected == 'excel') {
        file = await control.exportToExcel();
      } else {
        file = await control.exportToPdf();
      }

      navigator.pop(); // ✅ cerrar loader con navigator seguro
      await Future.delayed(
          const Duration(milliseconds: 100)); // evitar conflicto visual

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Estado financiero generado con Proveedify',
      );
    } catch (e) {
      navigator.pop(); // cerrar loader
      messenger.showSnackBar(
        const SnackBar(content: Text('Error al exportar archivo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, '/select-company');
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: null,
        bottomNavigationBar: const CustomNavBar(selectedIndex: 0),
        body: _buildBody(context),
      ),
    );
  }
}

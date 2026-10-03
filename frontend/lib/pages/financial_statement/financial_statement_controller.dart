import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart'; // Esto es necesario para usar PdfColors
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
// Importar los services y entities necesarios
import '../../services/provider_service_service.dart';
import '../../services/isp_service_service.dart';
import '../../services/invoice_service.dart';
import '../../services/dependency_service.dart';
import '../../services/company_service.dart';
import '../../services/isp_service.dart' as isp_svc;
import '../../models/entities/provider.dart';
import '../../models/entities/provider_service.dart';
import '../../models/entities/isp_service.dart';
import '../../models/entities/invoice.dart';
import '../../models/entities/dependency.dart';
import '../../models/entities/isp.dart';
import '../../selected_provider_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinancialItem {
  final String name;
  final String ruc;
  final String date;
  final String dependency;
  final String amount;
  final String? ispName;
  final DateTime originalDate; // Para filtrado por fechas
  final double originalAmount; // Para filtrado por montos

  FinancialItem({
    required this.name,
    required this.ruc,
    required this.date,
    required this.dependency,
    required this.amount,
    this.ispName,
    required this.originalDate,
    required this.originalAmount,
  });
}

class FinancialStatementController extends GetxController {
  final ProviderServiceService providerServiceService =
      ProviderServiceService();
  final IspServiceService ispServiceService = IspServiceService();
  final InvoiceService invoiceService = InvoiceService();
  final DependencyService dependencyService = DependencyService();
  final CompanyService companyService = CompanyService();
  final isp_svc.IspService ispService = isp_svc.IspService();

  // Listas originales (sin filtrar)
  var _originalIngresos = <FinancialItem>[].obs;
  var _originalEgresos = <FinancialItem>[].obs;

  // Listas filtradas (las que se muestran en la UI)
  var ingresos = <FinancialItem>[].obs;
  var egresos = <FinancialItem>[].obs;

  var isLoading = false.obs;
  var totalIngresos = 0.0.obs;
  var totalEgresos = 0.0.obs;
  var saldoTotal = 0.0.obs;

  // Estados de filtros - INGRESOS
  var filtrosIngresosActivos = false.obs;
  var filtroNombreIngreso = ''.obs;
  var filtroRucIngreso = ''.obs;
  var filtroDependenciaIngreso = ''.obs;
  var filtroFechaInicioIngreso = Rx<DateTime?>(null);
  var filtroFechaFinIngreso = Rx<DateTime?>(null);
  var filtroMontoMinIngreso = 0.0.obs;
  var filtroMontoMaxIngreso = 999999.0.obs;

  // Estados de filtros - EGRESOS
  var filtrosEgresosActivos = false.obs;
  var filtroNombreEgreso = ''.obs;
  var filtroRucEgreso = ''.obs;
  var filtroIspEgreso = ''.obs;
  var filtroFechaInicioEgreso = Rx<DateTime?>(null);
  var filtroFechaFinEgreso = Rx<DateTime?>(null);
  var filtroMontoMinEgreso = 0.0.obs;
  var filtroMontoMaxEgreso = 999999.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadFinancialData();
  }

  Future<void> loadFinancialData() async {
    try {
      isLoading.value = true;
      final selectedProviderController = Get.find<SelectedProviderController>();
      final provider = selectedProviderController.provider;

      print('=== INICIO CARGA DE DATOS ===');
      print('Provider seleccionado: ID=${provider.id}, Name=${provider.name}');

      await _loadIngresos(provider);
      await _loadEgresos(provider);

      // Aplicar filtros si están activos
      if (filtrosIngresosActivos.value) {
        _aplicarFiltrosIngresos();
      } else {
        ingresos.value = List.from(_originalIngresos);
      }

      if (filtrosEgresosActivos.value) {
        _aplicarFiltrosEgresos();
      } else {
        egresos.value = List.from(_originalEgresos);
      }

      _calculateTotals();
      print('=== FIN CARGA DE DATOS ===');
    } catch (e) {
      print('ERROR EN loadFinancialData: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadIngresos(Provider provider) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');
      print('Cargando ingresos para provider ID: ${provider.id}');
      final providerServicesResponse =
          await providerServiceService.fetchByProvider(token!, provider.id!);
      if (providerServicesResponse.status == 200) {
        final List<ProviderService> providerServices =
            providerServicesResponse.body;

        if (providerServices.isEmpty) {
          print(
              'No hay servicios de provider para el provider ID: ${provider.id}');
          return;
        }

        final invoicesResponse =
            await invoiceService.getProviderInvoice(token, providerServices);
        if (invoicesResponse.status == 200) {
          final List<Invoice> invoices = invoicesResponse.body;
          List<FinancialItem> ingresosTemp = [];

          for (Invoice invoice in invoices) {
            try {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? token = prefs.getString('jwt_token');

              final service = providerServices.firstWhereOrNull(
                (s) => s.id == invoice.serviceId,
              );
              if (service == null) continue;

              final dependencyResponse = await dependencyService
                  .getDependencyById(service.dependencyId, token!);
              String dependencyName = '';
              String companyRuc = '';

              if (dependencyResponse.status == 200) {
                final Dependency dependency = dependencyResponse.body;
                dependencyName = dependency.name;

                final companyResponse = await companyService
                    .getCompanyRucById(dependency.companyId,token);
                    
                if (companyResponse?.status == 200) {
                  companyRuc = companyResponse!.body;
                }
              }

              ingresosTemp.add(FinancialItem(
                name: service.description,
                ruc: companyRuc,
                date: _formatDate(invoice.issueDate),
                dependency: dependencyName,
                amount: 'S/ ${service.price.toStringAsFixed(2)}',
                originalDate: invoice.issueDate,
                originalAmount: service.price,
              ));
            } catch (e) {
              print('Error procesando factura ${invoice.id}: $e');
            }
          }

          _originalIngresos.value = ingresosTemp;
          print('Total ingresos cargados: ${ingresosTemp.length}');
        }
      }
    } catch (e) {
      print('Error loading ingresos: $e');
    }
  }

  Future<void> _loadEgresos(Provider provider) async {
    try {
      print('Cargando egresos para provider ID: ${provider.id}');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      final ispServicesResponse =
          await ispServiceService.fetchByProvider(provider, token!);
      if (ispServicesResponse.status == 200) {
        final List<IspService> ispServices = ispServicesResponse.body;

        if (ispServices.isEmpty) {
          print('No hay servicios ISP para el provider ID: ${provider.id}');
          return;
        }

        final invoicesResponse =
            await invoiceService.getIspInvoice(token, ispServices);
        if (invoicesResponse.status == 200) {
          final List<Invoice> invoices = invoicesResponse.body;
          List<FinancialItem> egresosTemp = [];

          for (Invoice invoice in invoices) {
            try {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? token = prefs.getString('jwt_token');

              final service = ispServices.firstWhereOrNull(
                (s) => s.id == invoice.serviceId,
              );
              if (service == null) continue;

              final ispResponse = await ispService.getIspById(service.ispId);
              String ispName = '';
              String ispRuc = '';

              if (ispResponse?.status == 200) {
                final Isp isp = ispResponse!.body;
                ispName = isp.name;
                ispRuc = isp.ruc ?? '';
              }

              final dependencyResponse = await dependencyService
                  .getDependencyById(service.providerId, token!);
              String dependencyName = '';
              if (dependencyResponse.status == 200) {
                final Dependency dependency = dependencyResponse.body;
                dependencyName = dependency.name;
              }

              egresosTemp.add(FinancialItem(
                name: service.description,
                ruc: ispRuc,
                date: _formatDate(invoice.issueDate),
                dependency: dependencyName,
                amount: 'S/ ${service.cost.toStringAsFixed(2)}',
                ispName: ispName,
                originalDate: invoice.issueDate,
                originalAmount: service.cost,
              ));
            } catch (e) {
              print('Error procesando factura ISP ${invoice.id}: $e');
            }
          }

          _originalEgresos.value = egresosTemp;
          print('Total egresos cargados: ${egresosTemp.length}');
        }
      }
    } catch (e) {
      print('Error loading egresos: $e');
    }
  }

  // MÉTODOS DE FILTRADO - INGRESOS
  void aplicarFiltrosIngresos({
    bool nombreEnabled = false,
    String nombreText = '',
    bool rucEnabled = false,
    String rucText = '',
    bool dependenciaEnabled = false,
    String dependenciaText = '',
    DateTime? fechaInicio,
    DateTime? fechaFin,
    double montoMin = 0.0,
    double montoMax = 999999.0,
  }) {
    // Actualizar estados de filtros
    filtrosIngresosActivos.value = nombreEnabled ||
        rucEnabled ||
        dependenciaEnabled ||
        fechaInicio != null ||
        fechaFin != null ||
        montoMin > 0 ||
        montoMax < 999999.0;

    if (nombreEnabled) filtroNombreIngreso.value = nombreText.toLowerCase();
    if (rucEnabled) filtroRucIngreso.value = rucText.toLowerCase();
    if (dependenciaEnabled)
      filtroDependenciaIngreso.value = dependenciaText.toLowerCase();

    filtroFechaInicioIngreso.value = fechaInicio;
    filtroFechaFinIngreso.value = fechaFin;
    filtroMontoMinIngreso.value = montoMin;
    filtroMontoMaxIngreso.value = montoMax;

    print('=== APLICANDO FILTROS DE INGRESOS ===');
    print('Nombre: $nombreEnabled - "$nombreText"');
    print('RUC: $rucEnabled - "$rucText"');
    print('Dependencia: $dependenciaEnabled - "$dependenciaText"');
    print('Fecha Inicio: $fechaInicio');
    print('Fecha Fin: $fechaFin');
    print('Monto Min: $montoMin, Max: $montoMax');

    _aplicarFiltrosIngresos();
  }

  void _aplicarFiltrosIngresos() {
    if (!filtrosIngresosActivos.value) {
      ingresos.value = List.from(_originalIngresos);
      _calculateTotals();
      return;
    }

    List<FinancialItem> filtrados = _originalIngresos.where((item) {
      // Filtro por nombre
      if (filtroNombreIngreso.value.isNotEmpty) {
        if (!item.name.toLowerCase().contains(filtroNombreIngreso.value)) {
          return false;
        }
      }

      // Filtro por RUC
      if (filtroRucIngreso.value.isNotEmpty) {
        if (!item.ruc.toLowerCase().contains(filtroRucIngreso.value)) {
          return false;
        }
      }

      // Filtro por dependencia
      if (filtroDependenciaIngreso.value.isNotEmpty) {
        if (!item.dependency
            .toLowerCase()
            .contains(filtroDependenciaIngreso.value)) {
          return false;
        }
      }

      // Filtro por fecha inicio
      if (filtroFechaInicioIngreso.value != null) {
        if (item.originalDate.isBefore(filtroFechaInicioIngreso.value!)) {
          return false;
        }
      }

      // Filtro por fecha fin
      if (filtroFechaFinIngreso.value != null) {
        if (item.originalDate.isAfter(filtroFechaFinIngreso.value!)) {
          return false;
        }
      }

      // Filtro por monto
      if (item.originalAmount < filtroMontoMinIngreso.value ||
          item.originalAmount > filtroMontoMaxIngreso.value) {
        return false;
      }

      return true;
    }).toList();

    ingresos.value = filtrados;
    _calculateTotals();

    print(
        'Ingresos filtrados: ${filtrados.length} de ${_originalIngresos.length}');
  }

  // MÉTODOS DE FILTRADO - EGRESOS
  void aplicarFiltrosEgresos({
    bool nombreEnabled = false,
    String nombreText = '',
    bool rucEnabled = false,
    String rucText = '',
    bool ispEnabled = false,
    String ispText = '',
    DateTime? fechaInicio,
    DateTime? fechaFin,
    double montoMin = 0.0,
    double montoMax = 999999.0,
  }) {
    // Actualizar estados de filtros
    filtrosEgresosActivos.value = nombreEnabled ||
        rucEnabled ||
        ispEnabled ||
        fechaInicio != null ||
        fechaFin != null ||
        montoMin > 0 ||
        montoMax < 999999.0;

    if (nombreEnabled) filtroNombreEgreso.value = nombreText.toLowerCase();
    if (rucEnabled) filtroRucEgreso.value = rucText.toLowerCase();
    if (ispEnabled) filtroIspEgreso.value = ispText.toLowerCase();

    filtroFechaInicioEgreso.value = fechaInicio;
    filtroFechaFinEgreso.value = fechaFin;
    filtroMontoMinEgreso.value = montoMin;
    filtroMontoMaxEgreso.value = montoMax;

    print('=== APLICANDO FILTROS DE EGRESOS ===');
    print('Nombre: $nombreEnabled - "$nombreText"');
    print('RUC: $rucEnabled - "$rucText"');
    print('ISP: $ispEnabled - "$ispText"');
    print('Fecha Inicio: $fechaInicio');
    print('Fecha Fin: $fechaFin');
    print('Monto Min: $montoMin, Max: $montoMax');

    _aplicarFiltrosEgresos();
  }

  void _aplicarFiltrosEgresos() {
    if (!filtrosEgresosActivos.value) {
      egresos.value = List.from(_originalEgresos);
      _calculateTotals();
      return;
    }

    List<FinancialItem> filtrados = _originalEgresos.where((item) {
      // Filtro por nombre
      if (filtroNombreEgreso.value.isNotEmpty) {
        if (!item.name.toLowerCase().contains(filtroNombreEgreso.value)) {
          return false;
        }
      }

      // Filtro por RUC
      if (filtroRucEgreso.value.isNotEmpty) {
        if (!item.ruc.toLowerCase().contains(filtroRucEgreso.value)) {
          return false;
        }
      }

      // Filtro por ISP
      if (filtroIspEgreso.value.isNotEmpty && item.ispName != null) {
        if (!item.ispName!.toLowerCase().contains(filtroIspEgreso.value)) {
          return false;
        }
      }

      // Filtro por fecha inicio
      if (filtroFechaInicioEgreso.value != null) {
        if (item.originalDate.isBefore(filtroFechaInicioEgreso.value!)) {
          return false;
        }
      }

      // Filtro por fecha fin
      if (filtroFechaFinEgreso.value != null) {
        if (item.originalDate.isAfter(filtroFechaFinEgreso.value!)) {
          return false;
        }
      }

      // Filtro por monto
      if (item.originalAmount < filtroMontoMinEgreso.value ||
          item.originalAmount > filtroMontoMaxEgreso.value) {
        return false;
      }

      return true;
    }).toList();

    egresos.value = filtrados;
    _calculateTotals();

    print(
        'Egresos filtrados: ${filtrados.length} de ${_originalEgresos.length}');
  }

  // MÉTODOS PARA LIMPIAR FILTROS
  void limpiarFiltrosIngresos() {
    filtrosIngresosActivos.value = false;
    filtroNombreIngreso.value = '';
    filtroRucIngreso.value = '';
    filtroDependenciaIngreso.value = '';
    filtroFechaInicioIngreso.value = null;
    filtroFechaFinIngreso.value = null;
    filtroMontoMinIngreso.value = 0.0;
    filtroMontoMaxIngreso.value = 999999.0;

    ingresos.value = List.from(_originalIngresos);
    _calculateTotals();

    print('Filtros de ingresos limpiados');
  }

  void limpiarFiltrosEgresos() {
    filtrosEgresosActivos.value = false;
    filtroNombreEgreso.value = '';
    filtroRucEgreso.value = '';
    filtroIspEgreso.value = '';
    filtroFechaInicioEgreso.value = null;
    filtroFechaFinEgreso.value = null;
    filtroMontoMinEgreso.value = 0.0;
    filtroMontoMaxEgreso.value = 999999.0;

    egresos.value = List.from(_originalEgresos);
    _calculateTotals();

    print('Filtros de egresos limpiados');
  }

  void _calculateTotals() {
    // Calcular total de ingresos (filtrados)
    double totalIng = 0.0;
    for (var item in ingresos) {
      totalIng += item.originalAmount;
    }
    totalIngresos.value = totalIng;

    // Calcular total de egresos (filtrados)
    double totalEgr = 0.0;
    for (var item in egresos) {
      totalEgr += item.originalAmount;
    }
    totalEgresos.value = totalEgr;

    // Calcular saldo total
    saldoTotal.value = totalIngresos.value - totalEgresos.value;

    print('Totales calculados (con filtros):');
    print('- Ingresos: S/ ${totalIngresos.value}');
    print('- Egresos: S/ ${totalEgresos.value}');
    print('- Saldo: S/ ${saldoTotal.value}');
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Métodos para obtener estados de filtros (para mostrar en UI)
  bool get hayFiltrosIngresosActivos => filtrosIngresosActivos.value;
  bool get hayFiltrosEgresosActivos => filtrosEgresosActivos.value;

  String get resumenFiltrosIngresos {
    if (!filtrosIngresosActivos.value) return '';

    List<String> filtros = [];
    if (filtroNombreIngreso.value.isNotEmpty) filtros.add('Nombre');
    if (filtroRucIngreso.value.isNotEmpty) filtros.add('RUC');
    if (filtroDependenciaIngreso.value.isNotEmpty) filtros.add('Dependencia');
    if (filtroFechaInicioIngreso.value != null ||
        filtroFechaFinIngreso.value != null) filtros.add('Fechas');
    if (filtroMontoMinIngreso.value > 0 ||
        filtroMontoMaxIngreso.value < 999999.0) filtros.add('Montos');

    return 'Filtros: ${filtros.join(', ')}';
  }

  String get resumenFiltrosEgresos {
    if (!filtrosEgresosActivos.value) return '';

    List<String> filtros = [];
    if (filtroNombreEgreso.value.isNotEmpty) filtros.add('Nombre');
    if (filtroRucEgreso.value.isNotEmpty) filtros.add('RUC');
    if (filtroIspEgreso.value.isNotEmpty) filtros.add('ISP');
    if (filtroFechaInicioEgreso.value != null ||
        filtroFechaFinEgreso.value != null) filtros.add('Fechas');
    if (filtroMontoMinEgreso.value > 0 || filtroMontoMaxEgreso.value < 999999.0)
      filtros.add('Montos');

    return 'Filtros: ${filtros.join(', ')}';
  }

  Future exportToPdf() async {
    final pdf = pw.Document();

    // Cargar fuente Roboto
    final fontData = await rootBundle.load("assets/fonts/roboto.ttf");
    final roboto = pw.Font.ttf(fontData);

    // Cargar logo
    final ByteData logoData =
        await rootBundle.load('assets/images/logo_proveedify.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final logoImage = pw.MemoryImage(logoBytes);

    // Preparar datos de ingresos para PDF
    List<List<String>> ingresosData = ingresos
        .map((item) => [
              item.name,
              item.ruc,
              item.date,
              item.dependency,
              item.amount,
            ])
        .toList();
    ingresosData.add([
      'Total ingresos',
      '',
      '',
      '',
      'S/ ${totalIngresos.value.toStringAsFixed(2)}'
    ]);

    // Preparar datos de egresos para PDF
    List<List<String>> egresosData = egresos
        .map((item) => [
              item.name,
              item.ruc,
              item.date,
              item.ispName ?? '',
              item.amount,
            ])
        .toList();
    egresosData.add([
      'Total egresos',
      '',
      '',
      '',
      'S/ ${totalEgresos.value.toStringAsFixed(2)}'
    ]);

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          // Encabezado con logo y título
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(logoImage, width: 100),
              pw.Text(
                'Reporte Financiero',
                style: pw.TextStyle(
                  font: roboto,
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          // Sección Ingresos
          pw.Text('Ingresos', style: pw.TextStyle(font: roboto, fontSize: 16)),
          pw.TableHelper.fromTextArray(
            headers: ['Nombre', 'RUC', 'Fecha', 'Dep.', 'Monto'],
            data: ingresosData,
            headerStyle:
                pw.TextStyle(font: roboto, fontWeight: pw.FontWeight.bold),
            cellStyle: pw.TextStyle(font: roboto),
            border: pw.TableBorder.all(
              width: 0.5,
              color: PdfColors.black,
              style: pw.BorderStyle.solid,
            ),
            columnWidths: {
              0: pw.FixedColumnWidth(85), // Ajustar el ancho de la columna
              1: pw.FixedColumnWidth(65),
              2: pw.FixedColumnWidth(50),
              3: pw.FixedColumnWidth(70),
              4: pw.FixedColumnWidth(60),
            },
          ),
          pw.SizedBox(height: 20),
          // Sección Egresos
          pw.Text('Egresos', style: pw.TextStyle(font: roboto, fontSize: 16)),
          pw.TableHelper.fromTextArray(
            headers: ['Nombre', 'RUC', 'Fecha', 'ISP', 'Monto'],
            data: egresosData,
            headerStyle:
                pw.TextStyle(font: roboto, fontWeight: pw.FontWeight.bold),
            cellStyle: pw.TextStyle(font: roboto),
            border: pw.TableBorder.all(
              width: 0.5,
              color: PdfColors.black,
              style: pw.BorderStyle.solid,
            ),
            columnWidths: {
              0: pw.FixedColumnWidth(85), // Ajustar el ancho de la columna
              1: pw.FixedColumnWidth(65),
              2: pw.FixedColumnWidth(50),
              3: pw.FixedColumnWidth(70),
              4: pw.FixedColumnWidth(60),
            },
          ),
          pw.SizedBox(height: 20),
          // Sección Saldo
          pw.Text('Saldo actual',
              style: pw.TextStyle(font: roboto, fontSize: 16)),
          pw.TableHelper.fromTextArray(
            headers: ['Utilidad Total'],
            data: [
              ['S/ ${saldoTotal.value.toStringAsFixed(2)}']
            ],
            headerStyle:
                pw.TextStyle(font: roboto, fontWeight: pw.FontWeight.bold),
            cellStyle: pw.TextStyle(font: roboto),
          ),
        ],
      ),
    );

    // Guardar archivo
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/estado_financiero.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future exportToExcel() async {
    final excel = Excel.createExcel();
    final sheet =
        excel['Reporte']; // Aseguramos que la primera hoja sea la de "Reporte"

    // Aseguramos que las celdas sean más anchas para acomodar el contenido
    sheet.setColWidth(0, 35); // Nombre
    sheet.setColWidth(1, 15); // RUC
    sheet.setColWidth(2, 15); // Fecha
    sheet.setColWidth(3, 25); // Dependencia
    sheet.setColWidth(4, 15); // Monto

    // Cabeceras Ingresos
    sheet.appendRow(['Ingresos']);
    sheet.appendRow(['Nombre', 'RUC', 'Fecha', 'Dep.', 'Monto']);

    // Datos de ingresos
    for (var item in ingresos) {
      sheet.appendRow(
          [item.name, item.ruc, item.date, item.dependency, item.amount]);
    }
    sheet.appendRow([
      'Total ingresos',
      '',
      '',
      '',
      'S/ ${totalIngresos.value.toStringAsFixed(2)}'
    ]);

    sheet.appendRow([]);

    // Cabeceras Egresos
    sheet.appendRow(['Egresos']);
    sheet.appendRow(['Nombre', 'RUC', 'Fecha', 'ISP', 'Monto']);

    // Datos de egresos
    for (var item in egresos) {
      sheet.appendRow(
          [item.name, item.ruc, item.date, item.ispName ?? '', item.amount]);
    }
    sheet.appendRow([
      'Total egresos',
      '',
      '',
      '',
      'S/ ${totalEgresos.value.toStringAsFixed(2)}'
    ]);

    sheet.appendRow([]);
    sheet.appendRow(['Saldo']);
    sheet.appendRow([
      'Utilidad Total',
      '',
      '',
      '',
      'S/ ${saldoTotal.value.toStringAsFixed(2)}'
    ]);

    // Guardar archivo
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/estado_financiero.xlsx';
    final file = File(path);
    await file.writeAsBytes(excel.encode()!);
    return file;
  }
}

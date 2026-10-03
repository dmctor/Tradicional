import 'package:flutter/material.dart';
import 'package:helloworld/configs/theme_1.dart';
import 'package:helloworld/configs/util.dart';
import 'package:helloworld/pages/add_service/add_service_page.dart';
import 'package:helloworld/pages/financial_statement/financial_statement_page.dart';
import 'package:helloworld/pages/invoices/invoices_page.dart';
import 'package:helloworld/pages/register_service/register_service_page.dart';
import 'package:helloworld/pages/select_company/select_company_page.dart';
import 'package:helloworld/pages/view_companies/view_companies_page.dart';
import 'package:helloworld/pages/view_contacts/view_contacts_page.dart';
import 'package:helloworld/pages/view_dependencies/view_dependencies_page.dart';
import 'package:helloworld/selected_provider_controller.dart';
import 'package:helloworld/services/contact_service.dart';
import './pages/sign_in/sign_in_page.dart';
import 'package:get/get.dart';

import 'services/storage_service.dart' show StorageService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize controllers and services
  Get.put(SelectedProviderController()); // controlador global
  Get.put(ContactService()); // servicio de contactos
    // Inicializa el servicio de almacenamiento
  final storageService = StorageService();
  await storageService.init();

  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme =
        createTextTheme(context, 'Abril Fatface', 'Allerta');
    final MaterialTheme materialTheme = MaterialTheme(textTheme);

    return GetMaterialApp(  // Changed from MaterialApp to GetMaterialApp
      title: 'Flutter Hello World',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      initialRoute: '/sign-in',
      routes: {
        '/sign-in': (context) => SignInPage(),
        '/select-company': (context) => SelectCompanyPage(),
        '/financial-statement': (context) => FinancialStatementPage(),
        '/invoices': (context) => InvoicesPage(),
        '/addService': (context) => AddServicePage(),
        '/registerService': (context) => RegisterServicePage(),
        '/view-companies': (context) => ViewCompaniesPage(),
        '/view-contacts': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ViewContactsPage(
            dependency: args['dependency'],
          );
        },
        '/view-dependencies': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ViewDependenciesPage(
            companyId: args['companyId']!,
            companyName: args['companyName'] ?? 'Empresa',
          );
        },
      },
    );
  }
}

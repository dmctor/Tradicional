import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'select_company_controller.dart';

class SelectCompanyPage extends StatelessWidget {
  final SelectCompanyController controller = Get.put(SelectCompanyController());

  SelectCompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    final providerIds = arguments?['providerIds'] ?? [];

    controller.loadProvidersByIds(providerIds);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, '/sign-in');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const BackButton(),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            'Seleccione su empresa',
            style: TextStyle(color: Color(0xFF2E3281), fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Obx(() => Column(
                children: controller.companies.map((company) {
                  final isSelected = controller.selectedCompany.value == company;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? const Color(0xFFE7C5F8)
                            : const Color(0xFFF5E6FF),
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.apartment),
                      label: Text(
                        company,
                        style: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () => controller.setSelectedCompany(company),
                    ),
                  );
                }).toList(),
              )),
              const Spacer(),
              SizedBox(
                height: 45,
                child: Obx(() {
                  final enabled = controller.selectedCompany.value != null;
                  return ElevatedButton(
                    onPressed: enabled
                        ? () => controller.continueToInvoices(context)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBBCFFC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'CONTINUAR',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helloworld/models/entities/dependency.dart';
import 'package:helloworld/pages/view_contacts/view_contacts_controller.dart';
import '../../components/custom_nav_bar.dart';

class ViewContactsPage extends StatelessWidget {
  final Dependency dependency;
  
  const ViewContactsPage({Key? key, required this.dependency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewContactsController());
    controller.loadContacts(dependency);
    
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
          child: AppBar(
            title: Text(
              'Contactos - ${dependency.name}',
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
      body: _buildBody(context),
      bottomNavigationBar: const CustomNavBar(selectedIndex: 1),
    );
  }

  Widget _buildBody(BuildContext context) {
    final controller = Get.find<ViewContactsController>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      
      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Text(
            controller.errorMessage.value,
            style: TextStyle(color: colorScheme.error),
          ),
        );
      }
      
      if (controller.contacts.isEmpty) {
        return Center(
          child: Text(
            'No hay contactos para esta dependencia',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        );
      }
      
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header similar to your image
            Text(
              'Contactos',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Contacts list
            Column(
              children: controller.contacts.map((contact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contact name as header
                    Text(
                      '${contact.name} ${contact.lastName}',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Contact details
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nombre: ${contact.name}'),
                          Text('Apellido: ${contact.lastName}'),
                          Text('Teléfono: ${contact.cellphone}'),
                          Text('Cumpleaños: ${_formatBirthday(contact.birthday)}'),
                          Text('Rango: ${contact.rank}'),
                          Text('Cargo: ${contact.position}'),
                        ],
                      ),
                    ),
                    
                    // Divider between contacts
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }

  String _formatBirthday(String birthday) {
    // Convert from "MM-DD" to "DD/MM" format
    final parts = birthday.split('-');
    if (parts.length == 2) {
      return '${parts[1]}/${parts[0]}';
    }
    return birthday;
  }
}
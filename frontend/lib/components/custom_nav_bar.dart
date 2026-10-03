import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;

  const CustomNavBar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  void _handleNavigation(BuildContext context, int index) {
    final routes = [
      '/financial-statement',
      '/view-companies',
      '/invoices',
      '/registerService',
    ];

    if (index != selectedIndex) {
      Navigator.pushReplacementNamed(context, routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => _handleNavigation(context, index),
      backgroundColor: Colors.white,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Finanzas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Empresas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Facturar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Servicios',
        ),
      ],
    );
  }
}

import 'package:get/get.dart';
import '../../models/entities/company.dart';
import '../../models/entities/address.dart';
import '../../services/company_service.dart';
import '../../services/address_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/service_http_response.dart';

class ViewCompaniesController extends GetxController {
  final CompanyService _companyService = CompanyService();
  final AddressService _addressService = AddressService();

  var companies = <Company>[].obs;
  var addresses = <Address>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadCompaniesAndAddresses();
  }

  Future<void> loadCompaniesAndAddresses() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');
      // Obtener empresas
      final companyResponse = await _companyService.fetchAll(token!);
      if (companyResponse != null && companyResponse.status == 200) {
        companies.assignAll(companyResponse.body as List<Company>);
      }

      // Obtener direcciones de cada empresa
      List<Address> loadedAddresses = [];
      for (var company in companies) {
        final ServiceHttpResponse? addressResponse =
            await _addressService.getAddress(company, token);

        // Primero comprueba que no sea null
        if (addressResponse != null &&
            addressResponse.status == 200 &&
            addressResponse.body != null) {
          loadedAddresses.add(addressResponse.body as Address);
        }
      }
      addresses.assignAll(loadedAddresses);


    } catch (e) {
      print('Error loading data: $e');
    } finally {
      isLoading(false);
    }
  }

  Address? getAddressForCompany(int addressId) {
    return addresses.firstWhereOrNull((address) => address.id == addressId);
  }
}

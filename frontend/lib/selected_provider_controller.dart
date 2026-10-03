import 'package:get/get.dart';
import '../models/entities/provider.dart';

class SelectedProviderController extends GetxController {
  // Provider por defecto
  Rx<Provider> selectedProvider = Provider(
    id: 1,
    ruc: '20123456789',
    name: 'Proveedor Alpha SAC',
    logo: 'alpha_logo.png',
  ).obs;

  void setProvider(Provider provider) {
    selectedProvider.value = provider;
  }

  Provider get provider => selectedProvider.value;

  void clear() {
    selectedProvider.value = Provider(
      id: 1,
      ruc: '20123456789',
      name: 'Proveedor Alpha SAC',
      logo: 'alpha_logo.png',
    );
  }

  bool get isSelected => selectedProvider.value.id != null;
}

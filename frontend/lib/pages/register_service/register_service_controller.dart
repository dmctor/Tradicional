import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterServiceController extends GetxController {
  RxString view = ''.obs;

  void gotoaddService (BuildContext context , bool isp){
    Navigator.pushNamed(context, '/addService', arguments: isp);
  }

}





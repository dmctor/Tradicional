import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_service_controller.dart';
import '../../components/custom_nav_bar.dart';

class RegisterServicePage extends StatelessWidget {
  RegisterServiceController control = Get.put(RegisterServiceController());


  Widget _mainButton (BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              control.gotoaddService(context , true);

            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(300, 200),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: const Color.fromARGB(255, 157, 200, 236),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/ISP.png', 
                  width: 150,
                  height: 150,
                ),
                SizedBox(width: 10), 
                Text('ISP'),
              ],
            ),
          ),

          SizedBox(height: 30),


          ElevatedButton(
            onPressed: () {
              control.gotoaddService(context , false);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(300, 200),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: const Color.fromARGB(255, 157, 200, 236),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Propio.png',
                  width: 150,
                  height: 150,
                ),
                SizedBox(width: 10), 
                Text('Propios'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _layer1 (BuildContext context) {
    return SafeArea (
      child: Container(
        width: double.infinity,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.only(bottom: 40, left: 40) ,
            
            child: 
            Text(
              "Selecciona el tipo de \n servicio a agregar",
              style: TextStyle(
              fontFamily: 'Monserrat',
              fontSize: 25,
              color: Color.fromARGB(255, 13, 101, 216),
              
              ),
            ),
            decoration: BoxDecoration( 
              border: Border(
                bottom: BorderSide(
                color: const Color.fromARGB(255, 150, 149, 149),
                width: 1,
                
            )
         ),
        
        ),

          ),
          SizedBox(
            height: 60,
          ),
          
          _mainButton(context),
        ],
      ),
      ) 

  );

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      bottomNavigationBar: const CustomNavBar(
          selectedIndex: 3), // cambia el índice según la posición
      body: _layer1 (context),
    );
  }


}

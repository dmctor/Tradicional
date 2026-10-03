import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helloworld/pages/register_service/register_service_controller.dart';
import 'package:helloworld/selected_provider_controller.dart';
import 'add_service_controller.dart';
import '../../components/custom_nav_bar.dart';
import 'package:flutter/services.dart';




final TextEditingController descripcionController = TextEditingController();
final TextEditingController precioController = TextEditingController();
final TextEditingController codigoPago = TextEditingController();

final TextEditingController descripcion = TextEditingController();
final TextEditingController precio = TextEditingController();


class AddServicePage extends StatelessWidget {
  AddServiceController control = Get.put(AddServiceController());
  bool isp = false;
  final proveedor = Get.find<SelectedProviderController>().provider;

  RegisterServiceController controlBack = Get.put(RegisterServiceController());
  

Widget _botton(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(top: 30),
    child: Center(
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color.fromARGB(255, 240, 161, 225),
                title: Text(
                  '¿Estás seguro de que \n la información es \n correcta?',
                  textAlign: TextAlign.center,
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // Cierra modal de confirmación

                      // Ejecutar POST
                      await control.guardarNuevoProviderService(context, proveedor.id!, 2);

                      // Mostrar modal de "registrado correctamente"
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Color.fromARGB(255, 240, 161, 225),
                            title: Text(
                              'Información registrada \n correctamente',
                              textAlign: TextAlign.center,
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // Limpiar campos correctamente
                                      control.descripcion.clear();
                                      control.precio.clear();
                                    },
                                    child: Text('Registrar otro'),
                                  ),
                                  SizedBox(width: 20),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      control.gotoRegisterService(context, true);
                                    },
                                    child: Text('Volver'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Confirmar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                ],
              );
            },
          );
        },
        child: Text('CREAR'),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(250, 60),
          backgroundColor: Color.fromARGB(255, 157, 200, 236),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
  );
}


  Widget _Registro(BuildContext context) {
    return Container(
      height: 450,
      padding: EdgeInsets.only(top: 90 ),
      decoration: BoxDecoration( 
        border: Border(
          top: BorderSide(
          color: Color.fromARGB(255, 150, 149, 149),
          width: 1,
         ),
        bottom: BorderSide(
          color: Color.fromARGB(255, 150, 149, 149),
          width: 1,
        ),
      ),
    ),

      child: Column(
        children: [
          TextField(
            controller: descripcion,
            decoration: InputDecoration(
              labelText: 'Descripcion',
              border: OutlineInputBorder(
                borderRadius:BorderRadius.circular(12)
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 212, 210, 210),
            ),
          ),

          SizedBox(
            height: 60,
          ),

Obx(() {
  if (control.ispList.isEmpty) {
    return Text("No hay ISPs disponibles.");
  }

  return DropdownButtonFormField<int>(
    decoration: InputDecoration(
      labelText: 'ISP',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: const Color.fromARGB(255, 211, 210, 210),
    ),
    items: control.ispList.map((isp) {
      return DropdownMenuItem<int>(
        value: isp.id,
        child: Text(isp.name),
      );
    }).toList(),
    onChanged: (int? nuevoValor) {
      control.selectedIspId.value = nuevoValor;
      print('Seleccionaste ISP con ID: $nuevoValor');
    },
    value: control.selectedIspId.value,
  );
}),






                    SizedBox(
            height: 60,
          ),



          TextField(
            controller: precio,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Precio',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 212, 210, 210),
            ),
          ),


          
          SizedBox(
            height: 20,
          ),

          
        ],
      ),
    );

  }

  /// Aquí va el contenido principal de la pantalla
  Widget _buildBody(BuildContext context) {
    return  SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        margin: EdgeInsets.only(left: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,       // Aquí pones el ícono que quieras
                      color: Colors.grey,    // Color del ícono (opcional)
                      size: 24.0,           // Tamaño del ícono (opcional)
                    ),
                    label: Text(''), // Texto del botón
                  ),
                ],
              ),
            ),
            Container(
              //margin: EdgeInsets.only(left: 100),
              child: Column(
                children: [
                  
                  Text('Registra el nuevo \n servicio',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 13, 101, 216),
                    fontFamily: 'Monserrat'
                    ),
                  ),
                ],
              ),
          ),
          SizedBox(
           height: 50,
          ),
          _Registro(context),
          _botton(context),
          ],
          
        ),

      )
    );
  }

///////////////////////////////////////////////////////////////////////////////////





Widget _botton2(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(top: 30),
    child: Center(
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color.fromARGB(255, 240, 161, 225),
                title: Text(
                  '¿Estás seguro de que \n la información es \n correcta?',
                  textAlign: TextAlign.center,
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // Cierra modal de confirmación

                      // Ejecutar POST
                      await control.guardarNuevoServicio(context, proveedor.id!);


                      // Mostrar modal de "registrado correctamente"
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Color.fromARGB(255, 240, 161, 225),
                            title: Text(
                              'Información registrada \n correctamente',
                              textAlign: TextAlign.center,
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // Limpiar campos correctamente
                                      control.descripcionController.clear();
                                      control.precioController.clear();
                                      control.codigoPagoController.clear();

                                    },
                                    child: Text('Registrar otro'),
                                  ),
                                  SizedBox(width: 20),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      control.gotoRegisterService(context, true);
                                    },
                                    child: Text('Volver'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Confirmar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                ],
              );
            },
          );
        },
        child: Text('CREAR'),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(250, 60),
          backgroundColor: Color.fromARGB(255, 157, 200, 236),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
  );
}




  Widget _Registro2(BuildContext context){

    return Container(
      height: 450,
      padding: EdgeInsets.only(top: 50 ,bottom: 40 ),
      decoration: BoxDecoration( 
        border: Border(
          top: BorderSide(
          color: Color.fromARGB(255, 150, 149, 149),
          width: 1,
         ),
        bottom: BorderSide(
          color: Color.fromARGB(255, 150, 149, 149),
          width: 1,
        ),
      ),
    ),
      child: Column(
        children: [
          TextField(
            controller: control.descripcionController,
            decoration: InputDecoration(
              labelText: 'Descripcion',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 211, 210, 210)
            ),
          ),

          SizedBox(
            height: 30,
          ),

Obx(() {
  if (control.ispList.isEmpty) {
    return Text("No hay ISPs disponibles.");
  }

  return DropdownButtonFormField<int>(
    decoration: InputDecoration(
      labelText: 'ISP',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: const Color.fromARGB(255, 211, 210, 210),
    ),
    items: control.ispList.map((isp) {
      return DropdownMenuItem<int>(
        value: isp.id,
        child: Text(isp.name),
      );
    }).toList(),
    onChanged: (int? nuevoValor) {
      control.selectedIspId.value = nuevoValor;
      print('Seleccionaste ISP con ID: $nuevoValor');
    },
    value: control.selectedIspId.value,
  );
}),



                    SizedBox(
            height: 30,
          ),

          TextField(
            controller: control.precioController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Costo',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 211, 210, 210),
            ),
          ),

                    SizedBox(
            height: 30,
          ),

          TextField(
            controller: control.codigoPagoController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Codigo de pago',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 211, 210, 210),
            ),
          ),


        ],
      ),
    );
  }

   Widget _nuevoServicio(BuildContext context){
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: EdgeInsets.only(left: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,       // Aquí pones el ícono que quieras
                      color: Colors.grey,    // Color del ícono (opcional)
                      size: 24.0,           // Tamaño del ícono (opcional)
                    ),
                    label: Text(''), // Texto del botón
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),
            
            Container(
              child: Column(
                children: [


                  Text('Registrar el nuevo \n servicio',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Monserrat',
                      fontSize: 30,
                      color: const Color.fromARGB(255, 13, 101, 216),
                    ),
                  ),
                ],
              ),
              
  
            ),
                        
            SizedBox(
              height: 40,
            ),

            _Registro2(context),
            _botton2(context)
          ],
        ),
      ),);
   }

  @override
  Widget build(BuildContext context) {
    isp = ModalRoute.of(context)?.settings.arguments as bool? ?? false;
    print("ISP List length: ${control.ispList.length}");
    print("ISP List data: ${control.ispList}");

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, '/sign-in');
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: null,
        bottomNavigationBar: const CustomNavBar(selectedIndex: 3),
        body: isp?_nuevoServicio(context): _buildBody(context)
      ),
    );
  }
}

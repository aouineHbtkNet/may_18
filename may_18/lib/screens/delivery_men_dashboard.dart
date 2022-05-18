import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simo_v_7_0_1/apis/logout_user_api.dart';
import 'package:simo_v_7_0_1/widgets_utilities/multi_used_widgets.dart';

import 'admin_profile_screen.dart';
import 'delivery_men_profile_screen.dart';
import 'login_screen.dart';

class DeliveryMenDashboard extends StatefulWidget {
  static const String id = '/deliverymenDashboard';
  const DeliveryMenDashboard({Key? key}) : super(key: key);

  @override
  State<DeliveryMenDashboard> createState() => _DeliveryMenDashboardState();
}

class _DeliveryMenDashboardState extends State<DeliveryMenDashboard> {



bool  done = false;
bool iSLoading = false;





//grabeldadel@gmail.com
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [



                    IconButton(onPressed: () async {
                      Navigator.push(context, MaterialPageRoute(builder:
                          (context)=>DeliveryMenProfileScreen (),
                      ),);},
                      icon: Icon(Icons.account_circle_outlined,color: Colors.green,),
                    ),



                    IconButton(onPressed: () async {
                      setState(() {iSLoading =true;});
                      bool answer= await LogoutAdminUserDeliveryMen().logOutDeliveryMen(context);
                      print ('answeer    -------         $answer');
                      if(answer==true){
                        Navigator.pushNamed(context, LoginScreen.id);
                        UsedWidgets().showNotificationDialogue(context,'La sesión ha sido cerrada con éxito.');
                      } else{
                        UsedWidgets().showNotificationDialogue(context,'Algo salió mal');
                      }
                      setState(() {iSLoading == false;});
                    }, icon:  Icon(Icons.exit_to_app,color: Colors.red,),
                    ),],
                ),
              ),

              Divider(thickness: 6,),

              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('',style: TextStyle(fontSize: 20),),
                  )),
              Divider(thickness: 2,color: Colors.blueGrey,),





              done == true || iSLoading == true ? SpinKitWave(color: Colors.green, size: 50.0,) :
              Center(child: Text('Delivery Men Daqshboard',style: TextStyle(fontSize: 20),)),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simo_v_7_0_1/apis/get_user_info.dart';
import 'package:simo_v_7_0_1/constant_strings/constant_strings.dart';
import 'package:simo_v_7_0_1/modals/user_model.dart';
import 'package:simo_v_7_0_1/providers/shared_preferences_provider.dart';
import 'package:simo_v_7_0_1/providers/shopping_cart_provider.dart';
import 'package:simo_v_7_0_1/screens/cart_screen.dart';
import 'package:simo_v_7_0_1/screens/pagar_ahora_enLinea.dart';
import 'package:simo_v_7_0_1/screens/user-cataloge.dart';
import 'package:simo_v_7_0_1/screens/user_account_edit.dart';
import 'package:simo_v_7_0_1/screens/user_change_password.dart';
import 'package:simo_v_7_0_1/widgets_utilities/multi_used_widgets.dart';
import 'package:simo_v_7_0_1/widgets_utilities/pop_up_menu_admins.dart';
import 'package:simo_v_7_0_1/widgets_utilities/pop_up_menu_users.dart';
import 'package:simo_v_7_0_1/widgets_utilities/statefulWidget_textFormField.dart';

import 'admin_change_password.dart';
import 'admin_user_name_edit.dart';
import 'deleivery_admin_edit_account_info.dart';
import 'delivery_men_edit_password_screen.dart';

class DeliveryMenProfileScreen extends StatefulWidget {
  static const String id = '/DeliveryMenProfileScreen';

  @override
  State<DeliveryMenProfileScreen> createState() => _DeliveryMenProfileScreenState();
}

class _DeliveryMenProfileScreenState extends State<DeliveryMenProfileScreen> {
  UserModel? userModel;
  @override
  void initState() {
    GetUserOrAdminInfo().getDeliveryMenInfo().then((value){
      setState(() {userModel = value;});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: () async {
                        Navigator.of(context).pop();
                      }, icon: Icon(Icons.arrow_back,),),





                      IconButton(

                        onPressed: () async {
                        Navigator.of(context).pushNamed(DeliveryEditAccount.id);
                        },
                        icon: Icon(Icons.edit,color: Colors.green,),


                      ),


                      IconButton(onPressed: () async {

                       Navigator.of(context).pushNamed(DeliveryEditPassword.id);
                        }, icon: Icon(Icons.security,color: Colors.red,),),
                    ],
                  ),
                ),


                Divider(thickness: 4,color: Colors.blueGrey,),
                SizedBox(height: 20,),

                userModel==null?SpinKitWave(color: Colors.green, size: 50.0,): Container(child: Column(
                  children: [

                    UsedWidgets().UserAccountScreen(title: 'Nombre :', data:userModel?.name),
                    SizedBox(height: 20,),
                    UsedWidgets().UserAccountScreen(title: 'Nombre de usuario  ( tu email ):', data:userModel?.email,),
                    SizedBox(height:20 ,),
                    UsedWidgets().UserAccountScreen(title: 'celular :', data:userModel?.mobilePhone,),
                    SizedBox(height: 20,),
                    UsedWidgets().UserAccountScreen(title: 'Telefono fijo :', data:userModel?.fixedPhone),
                    SizedBox(height: 20,),
                    UsedWidgets().UserAccountScreen(title: 'Direcci??n :',data:userModel?.address,),
                    SizedBox(height: 20,),
                    UsedWidgets().UserAccountScreen(title: 'N.de identificaion :',data:userModel?.identificationId,),
                    SizedBox(height: 20,),
                    Divider(thickness: 4,color: Colors.blueGrey,),

                  ],

                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
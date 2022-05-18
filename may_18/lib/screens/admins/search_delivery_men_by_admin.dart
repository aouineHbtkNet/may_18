import 'package:flutter/cupertino.dart';
import 'package:simo_v_7_0_1/constant_strings/constant_strings.dart';
import 'package:simo_v_7_0_1/modals/get_all_admin_user_delivery_response.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchDetailsDeleteDEliveryMenScrn extends StatefulWidget {
  const SearchDetailsDeleteDEliveryMenScrn({Key? key}) : super(key: key);
  static const String id = '/SearchDetailsDeleteDEliveryMenScrn';
  @override
  State<SearchDetailsDeleteDEliveryMenScrn> createState() => _SearchDetailsDeleteDEliveryMenScrnState();
}
// Route::post('/admin/getAllDeliveryMen', [AdminController::class, 'getAllDeliveryMen']);
// Route::post('/admin/getAllUsers', [AdminController::class, 'getAllUsers']);
// Route::post('/admin/getAllAdmins', [AdminController::class, 'getAllAdmins']);

class _SearchDetailsDeleteDEliveryMenScrnState extends State<SearchDetailsDeleteDEliveryMenScrn> {

  Future <GetAllAdminsUsersDeliveryMenPg> getAdmins({String? name} ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? spToken = await prefs.getString('spToken');
    print ('spToken==================${spToken}');
    final Map<String, String> _userprofileHeader =
    {'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': 'Bearer $spToken',};
    Uri _tokenUrl = Uri.parse('https://hbtknet.com/admin/admin/getAllDeliveryMen?page=$page');
    Map<String, dynamic> body = {'name': name,};
    http.Response response = await http.post(_tokenUrl, headers: _userprofileHeader,body: jsonEncode(body));
    var  data = jsonDecode(response.body);
    GetAllAdminsUsersDeliveryMenPg getAllAdminsUsersDeliveryMenPg =GetAllAdminsUsersDeliveryMenPg();
    getAllAdminsUsersDeliveryMenPg =  GetAllAdminsUsersDeliveryMenPg.fromjson(data);
    print('list of memebers from function ===================${getAllAdminsUsersDeliveryMenPg.listOfMembers[0].email}');
    print(' total from function  ===================${getAllAdminsUsersDeliveryMenPg.total}');
    return getAllAdminsUsersDeliveryMenPg;
  }

  void showstuff(context, var myString) {
    showDialog(context: context, builder: (context) {return AlertDialog(
      content: myString == null ? ClipRect(child: Image.asset(Constants.ASSET_PLACE_HOLDER_IMAGE),) : ClipRect(child: Image.network('https://hbtknet.com/storage/notes/$myString'),),
      actions: [ElevatedButton(onPressed: () async {Navigator.of(context).pop();}, child: Center(child: Text('Ok')))],);});}


  int page =1;
  GetAllAdminsUsersDeliveryMenPg dataFromApi=GetAllAdminsUsersDeliveryMenPg();
  List<Member>  MemberList = [];
  String nameToBeSearched ='';
  ScrollController _scrollController =ScrollController();
  bool hasMore=true;
  String? selectedCategory;
  TextEditingController _nameController = TextEditingController(text: '');
  int totalFromApi =0;
  bool isDownloading=false;
  bool isSearching=false;
  bool  filteredList=false;
  bool onFetchingProcess =false;
  bool startLogingOut =false;

  initFetchData() async{
    setState(() {onFetchingProcess =true;page=1;totalFromApi=0;MemberList.clear();});
    dataFromApi = await getAdmins(name:nameToBeSearched);
    setState(() {
      totalFromApi =dataFromApi.total;
      MemberList=dataFromApi.listOfMembers;
      page++;
      onFetchingProcess =false;
      hasMore=false;});
  }

  loadMoreData() async{ if(onFetchingProcess){ return;}//if onFetchingProcess is true stop .don t do anything
  setState(() {onFetchingProcess =true;});//if onFetchingProcess is false  .turn it to tru and go ahead
  GetAllAdminsUsersDeliveryMenPg newData = await getAdmins(name:nameToBeSearched);
  setState(() {
    MemberList.addAll(newData.listOfMembers);// add a list to the end of another list :addAll([element1, element2, etc]) (list, set, map)
    page++;
    onFetchingProcess =false; // just tells when the function in process
  });
  }

  @override
  void initState()
  { super.initState(); initFetchData();

  _scrollController.addListener(() async{
    if(_scrollController.position.pixels ==_scrollController.position.maxScrollExtent) {
      if (MemberList.length  >= totalFromApi  ){setState(() { hasMore=false;});}
      //new items added to productList each time loadMoreData() runs .So as long as there is more data ,productList length
      // will be less to the total length of the data (totalFromApi).However if productList equals or bigger than the total
      //length coming from the api (totalFromApi)  loadMoreData() stops because there is no more,
      else{hasMore=true;loadMoreData();}}});
  }


  @override void  dispose(){_scrollController.dispose();super.dispose();}
  @override
  Widget build(BuildContext context) {

    return  startLogingOut==true?Scaffold(body: SpinKitWave(color: Colors.green, size: 50.0,),): Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(children: [IconButton(onPressed: () async {Navigator.of(context).pop();}, icon: Icon(Icons.arrow_back,color: Colors.green,),),],),
            Divider(thickness: 2,),

            SizedBox(height: 10,),
            Card(elevation: 20, child: TextField(controller: _nameController, onChanged: (value) {nameToBeSearched = value;setState(() {});},
              decoration: InputDecoration(hintText: 'Buscar un repartidor',
                suffixIcon: Padding(padding: const EdgeInsets.all(12.0),
                  child: Container(decoration: BoxDecoration(color: Colors.green,),
                    child: IconButton(onPressed:() async { await initFetchData();},
                      icon: Icon(Icons.search,size: 40,),),),),
                prefixIcon: nameToBeSearched != '' ?  IconButton(onPressed:(){
                  setState(() {_nameController = TextEditingController(text: '');nameToBeSearched='';});},
                  icon: Icon(Icons.clear),color: Colors.red,iconSize: 24,):SizedBox(height: 0,), // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),),),

            Divider(thickness: 6,),

            MemberList.isEmpty && onFetchingProcess==true  ? SpinKitWave(color: Colors.green, size: 50.0,)
                :MemberList.isEmpty && onFetchingProcess==false ? Container( decoration:
            BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10.0)),
                child: Padding(padding: const EdgeInsets.all(8.0),
                  child: Text('No hay productos',style: TextStyle(fontSize: 20,color: Colors.white),),))
                :  Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: MemberList.length +1  ,
                  itemBuilder: (BuildContext ctx, index) {
                    if (index < MemberList.length) {
                      //  SelectedProductDetails;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${MemberList[index].name}',
                                      style: TextStyle(fontSize: 20,color:Colors.blueGrey ),
                                    ),
                                  )
                              ),
                              SizedBox(height:10,),
                              Container(
                                width: double.infinity,
                                color: Colors.blueGrey,

                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Ver los detalles',
                                      style: TextStyle(fontSize: 20,color:Colors.white ),),
                                  ),
                                ),),
                            ],),
                        ),



                      );
                    }
                    else {
                      return hasMore ? SpinKitWave(color: Colors.green, size: 50.0,) : SizedBox(height: 0,);
                    }
                    // Else condition still have 2 further options : hasMore =>true that shows animation and hasMore =>false
                    //  that shows nothiong ( optional i can put no more admins)
                  }
              ),
            ) ,
          ],
        ),
      ),
    );
  }




}

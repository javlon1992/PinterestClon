import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:multi_network_api/models/unsplash_multi_model.dart';
import 'package:multi_network_api/pages/detail_page.dart';
import 'package:multi_network_api/pages/saerch_page.dart';
import 'package:multi_network_api/services/http_service.dart';
import 'package:multi_network_api/services/log_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  static String id = "/home_page";
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{

   List category = ["For you","Today","Football","Following","Health","Recipes","Car"];
   List<Unsplash> listSplash = [];
   String searching = "All";
   int selectedIndex = 0, page = 1, selected = 0;
   final ScrollController _scrollController = ScrollController();
   final PageController _pageController = PageController();
   double downloadPercent = 0;
   bool showDownloadIndicator = false, loadMoreData = false;

  @override
  void initState() {
    super.initState();
    _apiUnSplashSearch(searching);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if(listSplash.length <= 470) _apiUnSplashSearch(searching);
      }
    });
  }

   @override
   // TODO: implement wantKeepAlive
   bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _pageController.dispose();
  }

  void _apiUnSplashSearch(String search) async{

    if(searching != search) {searching = search; listSplash.clear(); page = 1;}
    if(listSplash.isNotEmpty) setState(() {loadMoreData = true;});
     await Network.GET(Network.API_SEARCH, Network.paramsSearch(search, page++)).then((response) {
      if(response != null){
         setState(() {
           listSplash.addAll(Network.parseUnSplashListSearch(response));
           loadMoreData = false;
         });
         Log.w("HomePage length: ${listSplash.length}");
      }
    });
  }


  void _downloadFile(String url,String filename) async {
     var permission = await _getPermission(Permission.storage);
     try{
       if(permission != false){

         var httpClient = http.Client();
         var request = http.Request('GET', Uri.parse(url));
         var res = httpClient.send(request);
         final response = await get(Uri.parse(url));
         Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
         List<List<int>> chunks = [];
         int downloaded = 0;

         res.asStream().listen((http.StreamedResponse r) {
           r.stream.listen((List<int> chunk) {
             // Display percentage of completion

             setState(() {
               chunks.add(chunk);
               downloaded += chunk.length;
               showDownloadIndicator = true;
               downloadPercent = (downloaded / r.contentLength!) * 100;
               debugPrint("${downloadPercent.floor()}");

             });
           }, onDone: () async {
             // Display percentage of completion
             debugPrint('downloadPercentage: $downloadPercent');
             //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Downloaded!"),));
             setState(() {
               downloadPercent = 0;
               showDownloadIndicator = false;
               showSnackBar("Downloaded!");
             });
             // Save the file
             File imageFile = File("${generalDownloadDir.path}/$filename.jpg");
             Log.w(generalDownloadDir.path);
             await imageFile.writeAsBytes(response.bodyBytes);
             return;
           });
         });
       }
       else {
         Log.i("Permission Denied");
       }
     }
     catch(e){
       Log.e(e.toString());
     }
   }

  Future<bool> _getPermission(Permission permission) async {
     if (await permission.isGranted) {
       return true;
     } else {
       var result = await permission.request();

       if (result == PermissionStatus.granted) {
         return true;
       } else {
         Log.w(result.toString());
         return false;
       }
     }
   }

  void showSnackBar(var str){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(str),
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.70,left: 15,right: 15),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
      /// #Category
        appBar:  selected == 0? buildCategory() : null,
      /// #Body
        body: PageView(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
             children: [
               /// #HomePage
               Column(
                 children: [
                   Visibility(
                       visible: listSplash.isEmpty,
                       child: LinearProgressIndicator(
                         backgroundColor: Colors.grey.shade100,
                         valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                       )),
                   Expanded(
                     child: MasonryGridView.count(
                       key: const PageStorageKey<String>("HomePage"),
                       controller: _scrollController,
                             padding: EdgeInsets.symmetric(horizontal: 5),
                             itemCount: listSplash.length,
                             crossAxisCount: 2,
                             mainAxisSpacing: 6,
                             crossAxisSpacing: 6,
                             itemBuilder: (context, index) {
                               return  buildBody(context, index);
                             },
                           ),
                   ),
                   Visibility(
                       visible: loadMoreData,
                       child: LinearProgressIndicator(
                         backgroundColor: Colors.grey.shade100,
                         valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                       )),
                 ],
               ),
               /// #SearchPage
               SearchPage(),
             ],
           ),
      /// #BottomNavigationBar
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white
          ),
          margin: EdgeInsets.only(left: 50,right: 50,bottom: 10),
          child: BottomNavigationBar(
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey.shade600,
            currentIndex: selected,
            onTap: (index){
              setState(() {
                selected = index;
                _pageController.animateToPage(selected, curve: Curves.easeInOut, duration: const Duration(milliseconds: 500));
              });
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
           type: BottomNavigationBarType.fixed,
           items: [
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.house_alt), label: "",),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), label: "",),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.chat_bubble), label: "",),
            BottomNavigationBarItem(icon: listSplash.isEmpty ?
            CircleAvatar(radius: 13,backgroundImage: AssetImage("assets/images/back_image.png")):
            CircleAvatar(radius: 13,backgroundImage: NetworkImage(listSplash.first.user!.profileImage!.medium!)),label: ""),
          ],
         ),
        ),
      ),
    );
  }

  PreferredSize buildCategory() {
    return PreferredSize(
        preferredSize: Size(double.infinity,55),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(7),
            itemCount: category.length,
            itemBuilder: (context,index){
              return InkWell(
                onTap: (){
                  setState(() {
                    selectedIndex = index;
                    _apiUnSplashSearch(index == 0 ? "All" : category[index]);
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: selectedIndex == index ? Colors.black : Colors.white,
                  ),
                  child: Center(
                      child: Text(category[index],style: TextStyle(color:selectedIndex == index ? Colors.white : Colors.black),)),
                ),
              );
            }
        ),
      );
  }

  Widget buildBody(BuildContext context, int index) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute (builder: (BuildContext context) => DetailPage(unsplash: listSplash[index],),
            ),);
          },
          child: Hero(
            transitionOnUserGestures: true,
            tag: listSplash[index],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: listSplash[index].urls!.regular!,
                placeholder: (context, url) => AspectRatio(
                    aspectRatio: listSplash[index].width!/listSplash[index].height!,
                child: ColoredBox(color: Color(int.parse(listSplash[index].color!.replaceFirst("#","0xFF"))),)),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
        ),
        Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              listSplash[index].description == null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                   child: CachedNetworkImage(
                    height: 30,width: 30, fit: BoxFit.cover,
                    imageUrl: listSplash[index].user!.profileImage!.medium!,
                    placeholder: (context, url) => AspectRatio(
                      aspectRatio: listSplash[index].width!/listSplash[index].height!,
                      child: ColoredBox(color: Color(int.parse(listSplash[index].color!.replaceFirst("#","0xFF"))),)),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                  )
                  : Flexible(
                  child: Text(listSplash[index].description!,maxLines: 2,overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
              ),
              //Spacer(),
              InkWell(
                child: Icon(Icons.more_horiz,color: Colors.black,),
                onTap: () {
                  //Log.e("BottomSheet");
                  showModalBottomSheet(context: context, builder: (context) {
                    return buildBottomSheet(context,index);
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildBottomSheet(var context,int index) {
    return Container(
      color: Colors.white,
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20,top: 10),
            child: Text("Share to",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 10,),
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                MaterialButton(onPressed: (){
                  launch("sms:?body=${listSplash[index].urls!.full!}");
                }, child: Image.asset("assets/images/message.png",height: 60,),
                ),
                MaterialButton(onPressed: (){
                  launch("https://t.me/share/url?url=${listSplash[index].urls!.full!}");
                }, child: Image.asset("assets/images/facebook.png",height: 60,),
                ),
                MaterialButton(onPressed: (){
                  launch("mailto:?body=${listSplash[index].urls!.full!}");
                }, child: Image.asset("assets/images/gmail.png",height: 60,),
                ),
                MaterialButton(onPressed: (){
                  launch("https://t.me/share/url?url=${listSplash[index].urls!.full!}");
                }, child: Image.asset("assets/images/telegram.png",height: 60,),
                ),
                MaterialButton(onPressed: (){
                  launch("https://api.whatsapp.com/send?text=${listSplash[index].urls!.full!}");
                }, child: Image.asset("assets/images/whatsapp.png",height: 60,),
                ),
                MaterialButton(onPressed: () async{
                  await Clipboard.setData(ClipboardData(text: listSplash[index].urls!.full!));
                  Navigator.of(context).pop();
                  showSnackBar("Link Copied!");

                }, child: Image.asset("assets/images/copy_link.png",height: 60,),),
              ],
            ),
          ),
          SizedBox(height: 20,),
          MaterialButton(onPressed: () {
            _downloadFile(listSplash[index].urls!.small!, DateTime.now().toString());
            Navigator.of(context).pop();
          },
              child: Text("Download image",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),

          MaterialButton(onPressed: () {
            setState(() {
              listSplash.removeAt(index);
              Navigator.of(context).pop();
            });
          },
              child: Text("Hide Pin",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),

          MaterialButton(onPressed: () {  },
              child: Text("Report Pin",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),

          Text("    This goes against Pinterest's community guidelines"),
        ],
      ),
    );

  }


}

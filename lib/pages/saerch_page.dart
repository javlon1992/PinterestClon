import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:multi_network_api/models/unsplash_multi_model.dart';
import 'package:multi_network_api/services/http_service.dart';
import 'package:multi_network_api/services/log_service.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  static String id="/search_page";
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin{
  List<Unsplash> listSplash = [];
  String searching = "";
  int selectedIndex = 0, page = 1;
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _apiUnSplashSearch(searching);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if(listSplash.length<=470){
          setState(() {_apiUnSplashSearch(searching);});}
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
  }

  void _apiUnSplashSearch(String search) async{

    if(searching != search) {searching = search; listSplash.clear(); page = 1;}
    await Network.GET(Network.API_SEARCH, Network.paramsSearch(search, page++)).then((response) {
      if(response != null){
        listSplash.addAll(Network.parseUnSplashListSearch(response));
        Log.w("SearchPage length: ${listSplash.length}");
        setState(() {});
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity,65),
          child: Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 15,),
            height: 65,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              textInputAction: TextInputAction.search,
              onSubmitted:(text) {
                setState(() {
                  _apiUnSplashSearch(text);
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search,color: Colors.black,),
                border: InputBorder.none,
                hintText: "Search",
                suffixIcon: Icon(Icons.camera_alt,color: Colors.black,)
              ),
            ),
          ),

        ),
        body: MasonryGridView.count(
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
    );
  }
  Widget buildBody(BuildContext context, int index) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute (builder: (BuildContext context) => DetailPage(unsplash:listSplash[index]),
              ),);
            },
            child: CachedNetworkImage(
              imageUrl: listSplash[index].urls!.regular!,
              placeholder: (context, url) => AspectRatio(
                  aspectRatio: listSplash[index].width!/listSplash[index].height!,
                  child: ColoredBox(color: Color(int.parse(listSplash[index].color!.replaceFirst("#", "0xFF"))),)),
              errorWidget: (context, url, error) => Icon(Icons.error),
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
                      child: ColoredBox(color: Color(int.parse(listSplash[index].color!.replaceFirst("#", "0xFF"))),)),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              )
                  : Flexible(
                child: Text(listSplash[index].description!,maxLines: 2,overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
              ),
              //Spacer(),
              Icon(Icons.more_horiz,color: Colors.black,),
            ],
          ),
        ),
      ],
    );
  }
}

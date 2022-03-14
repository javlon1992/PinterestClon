import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:multi_network_api/models/unsplash_multi_model.dart';
import 'package:multi_network_api/services/http_service.dart';
import 'package:multi_network_api/services/log_service.dart';

class DetailPage extends StatefulWidget {
  static String id = "/detail_page";
  Unsplash? unsplash;
  DetailPage({Key? key,this.unsplash}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with AutomaticKeepAliveClientMixin{
  List<Unsplash> listSplash = [];
  late String searching = widget.unsplash!.tags!.first.title!;
  int page = 1;
  bool loadMoreData = true;
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {

    setState(() {_apiUnSplashSearch(searching);});

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if(listSplash.length<=470){
          loadMoreData = true;
          setState(() {_apiUnSplashSearch(searching);});
        }
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
          setState(() {
            listSplash.addAll(Network.parseUnSplashListSearch(response));
            loadMoreData = false;
          });
          Log.w("DetailPage length: ${listSplash.length}");
        }
    });

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        body: Stack(
          children: [
            ListView(
              controller: _scrollController,
              children: [
                Hero(
                  tag: widget.unsplash!,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                    child: CachedNetworkImage(
                      imageUrl: widget.unsplash!.urls!.regular!,
                      placeholder: (context, url) => AspectRatio(
                          aspectRatio: widget.unsplash!.width!/widget.unsplash!.height!,
                          child: ColoredBox(color: Color(int.parse(widget.unsplash!.color!.replaceFirst("#","0xFF"))),)),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.unsplash!.user!.profileImage!.medium!),
                    ),
                    title: Text(widget.unsplash!.user!.name!),
                    subtitle: Text("${widget.unsplash!.likes} Followers"),
                    trailing: TextButton(onPressed: () {  },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: StadiumBorder(),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 18),
                      ),
                      child: Text("Follow",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                  )),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 30,),
                  width: double.infinity,
                  color: Colors.white,
                  child: Center(child: Text(widget.unsplash!.description ?? "")),
                ),
                /// #Save and Visit
                buildSaveVisit(),

                /// #Comments
                buildComments(),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25))
                  ),
                  padding: EdgeInsets.only(top: 20,bottom: 15),
                  child: Text("More like this",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 22),),),

                /// #GridView
                Container(
                      color: Colors.white,
                  child: MasonryGridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                Container(
                  color: Colors.white,
                  height: 50,width: MediaQuery.of(context).size.width,
                  child: Visibility(
                      visible: loadMoreData,
                      child: const Center(child: CupertinoActivityIndicator(radius: 20,))),
                ),
              ],
            ),

            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Icon(Icons.arrow_back_sharp,color: Colors.white,),
              style: TextButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.black.withOpacity(0.1),
              ),),
          ],
        ),
      ),
    );
  }

  Container buildSaveVisit() {
    return Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
            ),
            child: Row(
              children: [
                Icon(CupertinoIcons.chat_bubble_fill),
                Spacer(),
                TextButton(onPressed: () {  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 25,vertical: 18),
                  ),
                  child: Text("Visit",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                ),
                SizedBox(width: 20,),
                TextButton(onPressed: () {  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 25,vertical: 18),
                  ),
                  child: Text("Save",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                ),
                Spacer(),
                Icon(Icons.share),
              ],
            ),
          );
  }

  Container buildComments() {
    return Container(
            margin: EdgeInsets.only(bottom: 4,top: 4),
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                Text("Comments",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                SizedBox(height: 15),
                Text("Love this Pin? Let ${widget.unsplash!.user!.name!} know!"),
                SizedBox(height: 15),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      child: Text("N",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.black),),
                    ),
                    SizedBox(width: 15,),
                    Text("Add a comment"),
                  ],
                ),
              ],
            ),
          );
  }

  Widget buildBody(BuildContext context, int index) {
    return Column(
      children: [
        InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute (builder: (BuildContext context) => DetailPage(unsplash:listSplash[index]),
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
              Icon(Icons.more_horiz,color: Colors.black,),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flikipedia/model/recents.model.dart';
import 'package:flikipedia/provider/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class RecentHistory extends StatefulWidget {
  final SearchProvider searchProvider;
  final List<Recents> recentList;
  final Function removeRecent;
  final Function loadList;

  const RecentHistory(
      {Key key,
      this.searchProvider,
      this.loadList,
      this.recentList,
      this.removeRecent})
      : super(key: key);
  @override
  _RecentHistoryState createState() => _RecentHistoryState();
}

class _RecentHistoryState extends State<RecentHistory> {
  List<Recents> list = new List<Recents>();

  @override
  void initState() {
    widget.loadList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 25.0,
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
          ),
        ),
        height: screenHeight * 0.22,
        width: screenWidth * 0.9,
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Your recent history...",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5), fontSize: 17),
                    ),
                  ),
                  if (widget.recentList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: OutlineButton(
                        borderSide: BorderSide(color: Colors.red),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                        onPressed: () async {
                          HapticFeedback.heavyImpact();
                          setState(() {
                            widget.removeRecent();
                            widget.loadList();
                            widget.recentList.clear();
                            widget.searchProvider.deleteAllCache();
                          });
                        },
                        child: Text(
                          "Clear All",
                          style: TextStyle(color: Colors.red, fontSize: 17),
                        ),
                      ),
                    ),
                ],
              ),
              if (widget.recentList.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Text("Search something...",
                      style: TextStyle(color: Colors.white, fontSize: 17)),
                ),
              Container(
                height: 53,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: (widget.recentList != null &&
                            widget.recentList.isNotEmpty)
                        ? (widget.recentList.length >= 5)
                            ? 5
                            : widget.recentList.length
                        : 0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            widget.searchProvider.searchApi(
                                widget.recentList[index].title, context);
                          },
                          child: NeumorphicButton(
                            style: NeumorphicStyle(
                                color: Colors.white,
                                shape: NeumorphicShape.convex,
                                border: NeumorphicBorder()),
                            onPressed: () {
                              widget.searchProvider.searchApi(
                                  widget.recentList[index].title, context);
                            },
                            child: Text(
                              widget.recentList[index].title,
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

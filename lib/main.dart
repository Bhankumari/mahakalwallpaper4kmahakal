import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabbar_gradient_indicator/tabbar_gradient_indicator.dart';
import 'ProviderClass.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ClassProvider())],
    child: MaterialApp(
      title: "Mahakal Wallpaper 2023",
      home: Categories(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}

class Categories extends StatefulWidget {
  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  void initState() {
    context.read<ClassProvider>().LoadBannerad();
    context.read<ClassProvider>().LoadInterTialAds();
    context.read<ClassProvider>().FechApi();
    context.read<ClassProvider>().LoadAd();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassProvider>(builder: (context, todo, child) {
      return Scaffold(
        bottomSheet: (todo.images.length == 0)
            ? LinearProgressIndicator()
            : PreferredSize(
                preferredSize: const Size(double.infinity, 40),
                child: DefaultTabController(
                  length: todo.images.length,
                  child: TabBar(
                    onTap: (value) {
                      todo.SelectedMode(value);
                      todo.LengthPattalaune(todo.images[value]);
                    },
                    automaticIndicatorColorAdjustment: true,
                    enableFeedback: true,
                    tabs: todo.images.map((e) => Tab(text: e)).toList(),
                    labelColor: Colors.black,
                    indicator: const TabBarGradientIndicator(
                        gradientColor: [Color(0xff579CFA), Color(0xff2FDEE7)],
                        indicatorWidth: 4),
                    indicatorSize: TabBarIndicatorSize.label,
                    isScrollable: true,
                  ),
                ),
              ),
        drawer: Drawer(
          backgroundColor: Colors.black,
          child: Center(
              child: Text(
            "Mahakal Wallpaper 2023",
            style: TextStyle(color: Colors.white),
          )),
        ),
        backgroundColor: Colors.black,
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0,right: 10),
              child: (todo.progressString=="100%")?Text(""): Text(todo.progressString,
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
          centerTitle: true,
          backgroundColor: Colors.black,
          title: (todo.images.length == 0)
              ? Text("Mahakal Wallpaper")
              : Text(
                  todo.images[todo.selectedmode],
                ),
        ),
        body: (todo.images.length == 0)
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Scrollbar(
                          child: ListView.builder(
                              shrinkWrap: true,
                              controller: todo.controller,
                              itemCount: todo.selectedmodeindex,
                              itemBuilder: (BuildContext, index) {
                                return Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.75,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  fit: BoxFit.fitWidth,
                                                  image: NetworkImage(todo
                                                          .result[todo
                                                              .images[
                                                          todo.selectedmode]]
                                                      [index]["image"]))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              (todo.selectedindex == index)
                                                  ? Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 8.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            todo.amimate =
                                                                "False";
                                                            todo.Circular =
                                                                "True";
                                                            todo.ImageSaver(
                                                                todo.result[todo
                                                                            .images[
                                                                        todo.selectedmode]]
                                                                    [
                                                                    index]["image"],
                                                                context);
                                                          },
                                                          child:
                                                              AnimatedContainer(
                                                            height: (todo
                                                                        .amimate ==
                                                                    "True")
                                                                ? MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.04
                                                                : MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0,
                                                            curve:
                                                                Curves.linear,
                                                            duration: Duration(
                                                                seconds: 1),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.04,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.4,
                                                              child: Center(
                                                                  child: Text(
                                                                "Download Image",
                                                                style: GoogleFonts
                                                                    .outfit(),
                                                              )),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Text(""),
                                              Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      todo.Animate();
                                                      todo.SelectedIndex(index);
                                                    },
                                                    child: Container(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        Icons.more_vert_rounded,
                                                        color: Colors.white,
                                                      ),
                                                    )),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: todo.bannerAd.size.height.toDouble(),
                        child: todo.adWidget),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.07,
                    )
                  ],
                ),
              ),
      );
    });
  }
}

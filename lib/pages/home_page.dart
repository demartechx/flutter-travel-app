import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/cubit/app_cubit.dart';
import 'package:travel/cubit/app_cubit_states.dart';
import 'package:travel/misc/colors.dart';
import 'package:travel/widgets/app_large_text.dart';
import 'package:travel/widgets/app_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  var images = {
    "balloning.png": "Balloning",
    "hiking.png": "Hiking",
    "kayaking.png": "Kayaking",
    "snorkling.png": "snorkling",
  };

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
        body: BlocBuilder<AppCubits, CubitStates>(builder: (context, state) {
      if (state is LoadedState) {
        var info = state.places;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //menu text
            Container(
              padding: const EdgeInsets.only(top: 70, left: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.menu,
                    size: 30,
                    color: Colors.black54,
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            //discover text
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: AppLargeText(text: "Discover"),
            ),
            const SizedBox(
              height: 40,
            ),
            //tab bar
            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                    labelPadding: const EdgeInsets.only(left: 20, right: 20),
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: CircleTabIndicator(
                        color: AppColors.mainColor, radius: 4),
                    tabs: const [
                      Tab(text: "Places"),
                      Tab(text: "Inspiration"),
                      Tab(text: "Emotions"),
                    ]),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, top: 20),
              height: 300,
              width: double.maxFinite,
              child: TabBarView(controller: _tabController, children: [
                ListView.builder(
                  itemCount: info.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          BlocProvider.of<AppCubits>(context)
                              .detailsPage(info[index]);
                        },
                        child: Container(
                        margin: const EdgeInsets.only(right: 15),
                        width: 200,
                        height: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            image: DecorationImage(
                                image: NetworkImage('http://mark.bslmeiyu.com/uploads/${info[index].img}'),
                                fit: BoxFit.cover)),
                      ),
                    );
                  },
                ),
                const Text("There"),
                const Text("Bye"),
              ]),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppLargeText(
                    text: "Explore more",
                    size: 22,
                  ),
                  AppText(
                    text: "See all",
                    color: AppColors.textColor1,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 120,
              width: double.maxFinite,
              margin: const EdgeInsets.only(left: 20),
              child: ListView.builder(
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 30),
                      child: Column(
                        children: [
                          Container(
                            //margin: const EdgeInsets.only(right: 50),
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                image: DecorationImage(
                                    image: AssetImage(
                                        "img/" + images.keys.elementAt(index)),
                                    fit: BoxFit.cover)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppText(
                            text: images.values.elementAt(index),
                            color: AppColors.textColor2,
                          )
                        ],
                      ),
                    );
                  }),
            )
          ],
        );
      } else {
        return Container();
      }
    }));
  }
}

class CircleTabIndicator extends Decoration {
  final Color color;
  double radius;
  CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final Color color;
  double radius;
  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint _paint = Paint();
    _paint.color = color;
    _paint.isAntiAlias = true;
    final Offset circleOffset = Offset(
        configuration.size!.width / 2 - radius / 2,
        configuration.size!.height - radius);
    canvas.drawCircle(offset + circleOffset, radius, _paint);
  }
}

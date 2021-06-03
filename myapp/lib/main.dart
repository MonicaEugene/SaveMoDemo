import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/scroll_physics.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/src/rendering/object.dart';

void main() {
  runApp(MaterialApp(
    routes: {'/': (context) => MyApp(), '/card': (context) => Card()},
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Widget cardSection;
  late ScrollController _scrollController;
  GlobalKey _key1 = GlobalKey();
  GlobalKey _key2 = GlobalKey();
  GlobalKey _key3 = GlobalKey();

  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    cardSection = createCardSection(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Layout Demo',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [cardTitle, cardSection],
        ),
      ),
    );
  }

  Widget cardTitle = Container(
    padding: const EdgeInsets.only(left: 40, top: 40, bottom: 15),
    child: new Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Cards',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white),
              )
            ],
          ),
        )
      ],
    ),
  );

  Offset _getPositions(GlobalKey _k) {
    final RenderBox renderBoxRed = _k.currentContext!.findRenderObject() as RenderBox;
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    return positionRed;
  }

  Widget createCardSection(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: Row(
            children: [
              GestureDetector(
                key: _key1,
                onTap: () {
                  Navigator.pushNamed(context, '/card',
                      arguments: ScreenArguments(Colors.deepOrange, 'Card 1',
                          _getPositions(_key1)));
                },
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.deepOrange,
                    ),
                    height: 300,
                    width: 200,
                    child: Center(
                        child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Card 1',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ))),
              ),
              SizedBox(width: 10, height: 300),
              GestureDetector(
                key: _key2,
                onTap: () {
                  Navigator.pushNamed(context, '/card',
                      arguments: ScreenArguments(Colors.amber, 'Card 2',
                          _getPositions(_key2)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.amber,
                  ),
                  height: 300,
                  width: 200,
                ),
              ),
              SizedBox(width: 10, height: 300),
              GestureDetector(
                key: _key3,
                  onTap: () {
                    Navigator.pushNamed(context, '/card',
                        arguments: ScreenArguments(Colors.deepOrange, 'Card 3',
                            _getPositions(_key3)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.deepOrange,
                    ),
                    height: 300,
                    width: 200,
                  )),
            ],
          ),
        ));
  }
}

class ScreenArguments {
  final MaterialColor cardColor;
  final String cardText;
  final Offset cardPosition;

  ScreenArguments(this.cardColor, this.cardText, this.cardPosition);
}

class Card extends StatefulWidget {
  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<Card> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    final _curvedAnimation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCubic);
    _animation = Tween<double>(begin: 0, end: pi / 2).animate(_curvedAnimation)
      ..addListener(() {
        setState(() {});
      });

    _offset = Tween<Offset>(begin: Offset(0.0, 2.0), end: Offset.zero)
        .animate(_animationController);
    _animationController.forward();
  }

  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  SheetController _sheetController = SheetController();
  double _progerssHeight = 200;


  double getSheetProgress(SheetState state) {
    setState(() {
      _progerssHeight = 200 - (state.progress * 200);
    });
    return _progerssHeight;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SlideTransition(
              position: _offset,
              child: SlidingSheet(
                listener: getSheetProgress,
                controller: _sheetController,
                cornerRadius: 16,
                color: Colors.grey,
                snapSpec: const SnapSpec(
                  snap: true,
                  snappings: [0.65, 0.7, 1.0],
                  positioning: SnapPositioning.relativeToAvailableSpace,
                ),
                builder: (context, state) {
                  return Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.black),
                        )
                      ],
                    ),
                  );
                },
              )),
          Positioned(
               top: args.cardPosition.dy,
              left: args.cardPosition.dx,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(-acos(_progerssHeight / 200)),
                    origin: Offset(150, 0),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Transform.rotate(
                        angle: _animation.value,
                        origin: Offset(100.0, 0),
                        child: Container(
                          margin: const EdgeInsets.only(top: 80, left: 25),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: args.cardColor,
                          ),
                          height: 300,
                          width: 200,
                          child: Center(
                            child: Transform(
                              transform: Matrix4.identity()
                                ..setValues(1, 0, 0, args.cardPosition.dy, 0, 1, 0, args.cardPosition.dx, 0, 0, 1, 0, 0, 0, 0, 1)
                                ..rotateY(-_animation.value),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  args.cardText,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }

  Widget rotateCard(Animation<double> animation) {
    return Transform.rotate(
      angle: animation.value,
      origin: Offset(100.0, 0),
      child: Container(
        margin: const EdgeInsets.only(top: 80, left: 25),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.deepOrange,
        ),
        height: 300,
        width: 200,
        child: Center(
          child: Transform.rotate(
            angle: -animation.value,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                'cardText',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

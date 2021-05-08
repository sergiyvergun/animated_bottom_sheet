import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Material(
        child: MainExpandableNavBar(),
      ),
    );
  }
}

double _minHeight = 70.0;
double _maxHeight = 350.0;

class MainExpandableNavBar extends StatefulWidget {
  @override
  _MainExpandableNavBarState createState() => _MainExpandableNavBarState();
}

class _MainExpandableNavBarState extends State<MainExpandableNavBar>
    with SingleTickerProviderStateMixin {


  AnimationController _controller;
  bool _expanded = false;
  double _currentHeight = _minHeight;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
    final double menuWidth = size.width * 0.5;

    final double _maxHeight = 400;
    final double _minHeight = 100;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          body: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, int index) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20)),
                height: 100,
                margin: EdgeInsets.only(top: 20, left: 10, right: 10),
              );
            },
          ),
        ),
        GestureDetector(

          onVerticalDragUpdate:  (details) {
            setState(() {
              final newHeight = _currentHeight + details.delta.dy;
              _controller.value = _currentHeight / _maxHeight;
              _currentHeight = newHeight.clamp(_minHeight, _maxHeight);
            });
          },

          onVerticalDragEnd: (details) {

          },

          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
            if (_expanded) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
          child: AnimatedBuilder(
              animation: _controller,
              builder: (context, snapshot) {
                final value = _controller.value;
                return Stack(
                  children: [
                    Positioned(
                      height: lerpDouble(_maxHeight, _minHeight, value),
                      left: lerpDouble((size.width - menuWidth) / 2, 0, value),
                      width: lerpDouble(menuWidth, size.width, value),
                      bottom: lerpDouble(40, 0, value),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(40),
                              bottom: Radius.circular(lerpDouble(20, 0, value)),
                            ),
                            color: Colors.purpleAccent,
                          ),
                          height: _maxHeight,
                          child: _expanded ? ExpandedContent() : MenuContent(onExpandedChanged: (){
                            _expanded=true;
                            _currentHeight=_maxHeight;
                            _controller.forward(from: 0.0);
                          },)),
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }
}

class MenuContent extends StatelessWidget {
  final Function onExpandedChanged;

  const MenuContent({Key key,@required this.onExpandedChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.play_circle_fill_sharp),
        Container(width: 15),
        GestureDetector(onTap: onExpandedChanged,
          child: Icon(Icons.pause_circle_filled_outlined),),
        Container(width: 15),
        Icon(Icons.forward_rounded)
      ],
    );
  }
}

class ExpandedContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Container(color: Colors.black, height: 80, width: 80),
        SizedBox(height: 15),
        Text('Last Century', style: TextStyle(fontSize: 15)),
        SizedBox(height: 15),
        Text('Bloody Tear', style: TextStyle(fontSize: 20)),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shuffle),
            Container(width: 20),
            Icon(Icons.pause),
            Container(width: 20),
            Icon(Icons.playlist_add),
          ],
        )
      ],
    );
  }
}

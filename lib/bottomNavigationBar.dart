import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:my_pharmacy/main.dart';
import 'package:my_pharmacy/medScanning.dart';

import 'prescriptionScanning.dart';

class bottomNavigationBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<bottomNavigationBar> {
  int selectedIndex = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final screens = [HomeScreen(), medScanningPage(), prescriptionScanning()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.blue,
          key: _bottomNavigationKey,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.category, size: 30),
            Icon(Icons.photo_camera, size: 30),
            Icon(Icons.camera, size: 30),
          ],
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: screens[selectedIndex]);
  }
}

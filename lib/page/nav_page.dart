import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:scrd/page/after_login.dart';
import 'package:scrd/page/home_page.dart';

import '../provider/navigation_provider.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<NavPage> {
  final CarouselSliderController carouselController =
      CarouselSliderController();

  final List<Widget> _pages = [
    Center(child: Text('Search Page', style: TextStyle(color: Colors.white))),
    DateGridPage(),
    Center(child: Text('Add Page', style: TextStyle(color: Colors.white))),
    Center(child: Text('Saved Page', style: TextStyle(color: Colors.white))),
    AfterLogin(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.black,
        leading: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(width: 29),
              Image.asset('assets/scrd_logo.png'),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          ),

          // Container(
          //   width: 30,
          //   height: 30,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(30),
          //     color: Colors.white,
          //   ),
          // ),
          SizedBox(width: 20),
        ],
      ),
      body: _pages[navigationProvider.selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 8), // 상단 패딩 추가
        decoration: const BoxDecoration(
          color: Color(0xff131313), // 배경색 설정
          // border: Border(
          //     top: BorderSide(color: Colors.grey, width: 0.5)), // 상단 테두리 추가 가능
        ),
        child: BottomNavigationBar(
          currentIndex: navigationProvider.selectedIndex,
          onTap: (index) => navigationProvider.setIndex(index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 27,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 27,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.grey,
              icon: Icon(
                Icons.add_box,
                color: Colors.grey,
                size: 27,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bookmark_border,
                size: 27,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
                size: 27,
              ),
              label: '',
            ),
          ],
          backgroundColor: Color(0xff131313),
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}

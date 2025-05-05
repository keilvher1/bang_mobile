import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:scrd/page/after_login.dart';
import 'package:scrd/page/find_group_page.dart';
import 'package:scrd/page/home_page.dart';
import 'package:scrd/page/notification.dart';
import 'package:scrd/page/search_theme.dart';
import 'package:scrd/page/upload_page.dart';

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
    const DateGridPage(),
    const FindGroupPage(),
    const UploadPage(
      isReviewMode: false,
    ),
    // MySavedPage(),
    const NotificationPage(),
    const AfterLogin(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: navigationProvider.selectedIndex != 1 &&
              navigationProvider.selectedIndex != 2 &&
              navigationProvider.selectedIndex != 3
          ? AppBar(
              toolbarHeight: 40,
              backgroundColor: Colors.black,
              leading: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(width: 29),
                    // Image.asset('assets/icon/Logo_Bold.svg'),
                    SvgPicture.asset(
                      // 'assets/icon/Logo_Bold1.svg',
                      'assets/icon/logo_border.svg',
                      width: 28,
                      height: 28,
                    ),
                  ],
                ),
              ),
              actions: [
                // IconButton(
                //   icon: const Icon(
                //     Icons.notifications_none_rounded,
                //     color: Colors.white,
                //     size: 28,
                //   ),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (_) => NotificationPage()),
                //     );
                //   },
                // ),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchThemePage()),
                    );
                  },
                ),

                // Container(
                //   width: 30,
                //   height: 30,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(30),
                //     color: Colors.white,
                //   ),
                // ),
                const SizedBox(width: 20),
              ],
            )
          : null,
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
          onTap: (index) {
            if (index == 2) {
              // + 버튼 눌렀을 때 업로드 페이지 전체화면으로 push
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const UploadPage(
                          isReviewMode: false,
                        )),
              );
            } else {
              navigationProvider.setIndex(index);
            }
          },
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
          backgroundColor: const Color(0xff131313),
          selectedItemColor: const Color(0xffD90206),
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}

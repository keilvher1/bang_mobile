import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:scrd/page/after_login.dart';
import 'package:scrd/page/find_group_page.dart';
import 'package:scrd/page/home_page.dart';
import 'package:scrd/page/notification.dart';
import 'package:scrd/page/upload_page.dart';

import '../auth/secure_storage.dart';
import '../model/theme.dart';
import '../provider/navigation_provider.dart';
import '../provider/notification_provider.dart';
import '../provider/search_theme_provider.dart';
import '../utils/api_server.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
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
  bool _sseInitialized = false;
  final SecureStorage secureStorage = SecureStorage();
  bool _showSearch = false;
  Timer? _debounce;
  List<ThemeModel> _searchResults = [];
  List<ThemeModel> get searchResults => _searchResults;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_sseInitialized) {
        final token = await secureStorage.readToken("x-access-token");
        if (token != null) {
          final provider =
              Provider.of<NotificationProvider>(context, listen: false);
          provider.initialize(context, token);
          _sseInitialized = true;
        }
      }
    });
  }

  void _searchThemes(String keyword) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (keyword.isNotEmpty) {
        final results = await ApiService().searchFilteredThemes(
          keyword: keyword,
          date: DateTime.now(),
        );

        // 명시적으로 ThemeModel로 매핑
        final themes = results.cast<ThemeModel>();

        debugPrint("Search result2s: $themes");
        setState(() {
          _searchResults = themes; // List<ThemeModel>
        });
        final searchProvider =
            Provider.of<SearchThemeProvider>(context, listen: false);
        searchProvider.setSearchResults(themes);
        searchProvider.setKeyword(keyword);
      } else {
        setState(() {
          _searchResults = [];
        });
        final searchProvider =
            Provider.of<SearchThemeProvider>(context, listen: false);
        searchProvider.setSearchResults([]);
        searchProvider.setKeyword('');
      }
    });
  }

  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: navigationProvider.selectedIndex != 1 &&
              navigationProvider.selectedIndex != 2 &&
              navigationProvider.selectedIndex != 3
          ? AppBar(
              leadingWidth: 250,
              toolbarHeight: 40,
              backgroundColor: Colors.black,
              leading: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 29),
                    // Image.asset('assets/icon/Logo_Bold.svg'),
                    SvgPicture.asset(
                      // 'assets/icon/Logo_Bold1.svg',
                      'assets/icon/logo_border.svg',
                      width: 28,
                      height: 28,
                    ),
                    if (_showSearch)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0), // 원하는 만큼 조절
                        child: IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 20),
                          onPressed: () {
                            setState(() {
                              _showSearch = false;
                              _searchController.clear();
                              Provider.of<SearchThemeProvider>(context,
                                      listen: false)
                                  .cancelSearch();
                            });
                          },
                        ),
                      ),
                    AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(1, 0), // 오른쪽에서
                              end: Offset(0, 0), // 제자리로
                            ).animate(animation),
                            child: child,
                          );
                        },
                        child: _showSearch
                            ? SizedBox(
                                key: ValueKey('search_field'),
                                width: 200,
                                child: TextField(
                                  controller: _searchController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: '검색어 입력',
                                    hintStyle: TextStyle(color: Colors.white54),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (query) {
                                    _searchThemes(query.trim());
                                    Provider.of<SearchThemeProvider>(context,
                                            listen: false)
                                        .setKeyword(query.trim());
                                    Provider.of<SearchThemeProvider>(context,
                                            listen: false)
                                        .setSearchResults(_searchResults);
                                    Provider.of<SearchThemeProvider>(context,
                                            listen: false)
                                        .setIsSearching(true);
                                  },
                                ),
                              )
                            : SizedBox()
                        // : IconButton(
                        //     key: ValueKey('search_icon'),
                        //     icon: const Icon(
                        //       Icons.search,
                        //       color: Colors.white,
                        //       size: 20,
                        //     ),
                        //     onPressed: () {
                        //       setState(() => _showSearch = true);
                        //     },
                        //   ),
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
                if (!_showSearch)
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _showSearch = true;
                        });
                      },
                    ),
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
      body: SafeArea(child: _pages[navigationProvider.selectedIndex]),
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
          items: [
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 27,
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 27,
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              backgroundColor: Colors.grey,
              icon: Icon(
                Icons.add_box,
                size: 27,
              ),
              label: '',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.notifications_none_rounded,
            //     size: 27,
            //   ),
            //   label: '',
            // ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    size: 27,
                  ),
                  Consumer<NotificationProvider>(
                    builder: (context, provider, _) {
                      final hasPending = provider.notifications
                          .any((n) => n.status == 'PENDING');
                      return hasPending
                          ? Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Colors.orangeAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ],
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/theme_card.dart';
import '../model/theme.dart';
import '../provider/select_theme_provider.dart';
import '../utils/api_server.dart';

class SearchThemePage extends StatefulWidget {
  const SearchThemePage({super.key});

  @override
  State<SearchThemePage> createState() => _SearchThemePageState();
}

class _SearchThemePageState extends State<SearchThemePage> {
  final TextEditingController _searchController = TextEditingController();
  List<ThemeModel> _searchResults = [];
  final bool _isLoading = false;

  Timer? _debounce;

  void _searchThemes(String keyword) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (keyword.isNotEmpty) {
        final results = await ApiService().searchThemes(keyword);

        // 명시적으로 ThemeModel로 매핑
        final themes = results
            .map((json) => ThemeModel.fromJson(json as Map<String, dynamic>))
            .toList();

        setState(() {
          _searchResults = themes; // List<ThemeModel>
        });
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            Container(
              width: 297,
              height: 35,
              decoration: ShapeDecoration(
                color: const Color(0xFF313131),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  _searchThemes(query.trim()); // 실시간 검색
                },
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 1.75,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xffA1A1A1),
                    size: 19,
                  ), // 🔍 앞쪽 아이콘
                  hintText: '검색어를 입력하세요',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? const Center(
                  child: Text(
                    '검색 결과가 없습니다.',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final theme = _searchResults[index];
                    return GestureDetector(
                      onTap: () {
                        Provider.of<SelectThemeProvider>(context, listen: false)
                            .selectTheme(theme);
                        Navigator.pop(context); // 이전 페이지로
                      },
                      child: ThemeCard(
                        theme: theme,
                      ),
                    );
                  },
                ),
    );
  }
}

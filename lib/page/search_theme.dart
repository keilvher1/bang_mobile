import 'package:flutter/material.dart';

class SearchThemePage extends StatefulWidget {
  const SearchThemePage({super.key});

  @override
  State<SearchThemePage> createState() => _SearchThemePageState();
}

class _SearchThemePageState extends State<SearchThemePage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 페이지 열리자마자 키보드 자동 포커스
    Future.delayed(Duration(milliseconds: 300), () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode, // ✅ 자동 포커스
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.red,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              hintText: '테마명 혹은 매장을 검색하세요.',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(bottom: 0),
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text(
          '검색 결과를 여기에 표시',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

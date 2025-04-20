import 'package:flutter/material.dart';
import '../model/theme.dart';

class ThemeCard extends StatelessWidget {
  final ThemeModel theme;

  const ThemeCard({
    Key? key,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 352,
      height: 90,
      padding: const EdgeInsets.only(left: 19, right: 12, top: 8),
      child: Row(
        children: [
          // 이미지
          Container(
            width: 66,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                theme.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 정보
          Container(
            padding: const EdgeInsets.only(left: 18.0),
            width: MediaQuery.of(context).size.width - 98,
            decoration: const BoxDecoration(color: Color(0xFF121212)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목 + 즐겨찾기
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        theme.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 브랜드 및 지점
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Color(0xFFB9B9B9),
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        '${theme.brand} | ${theme.branch}',
                        style: const TextStyle(
                          color: Color(0xFFB9B9B9),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

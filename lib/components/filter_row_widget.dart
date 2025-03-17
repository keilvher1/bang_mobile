import 'package:flutter/material.dart';

class FilterRowWidget extends StatelessWidget {
  final double height;
  final double horizontalPadding;
  final double iconSize;
  final double fontSize;
  final Color fontColor;
  final FontWeight fontWeight;

  const FilterRowWidget({
    Key? key,
    this.height = 29.0,
    this.horizontalPadding = 12.0,
    this.iconSize = 24.0,
    this.fontSize = 13.0,
    this.fontColor = Colors.white,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 5),
          _buildDropdownButton('지역', ['지역', '옵션1', '옵션2']),
          const SizedBox(width: 5),
          _buildDropdownButton('난이도', ['난이도', '쉬움', '보통', '어려움']),
          const SizedBox(width: 5),
          _buildIconTextButton('공포도', 'assets/button/knife.png'),
          const SizedBox(width: 5),
          _buildIconTextButton('활동성', 'assets/button/sneaker.png'),
          const SizedBox(width: 14),
          _buildCircleIconButton('assets/icon/radio.png'),
        ],
      ),
    );
  }

  Widget _buildDropdownButton(String label, List<String> options) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(30),
      ),
      child: IntrinsicWidth(
        // 너비를 최소한으로 유지
        child: DropdownButtonHideUnderline(
          // 밑줄 제거
          child: DropdownButton<String>(
            value: label,
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    color: fontColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {},
            dropdownColor: Colors.black,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            iconSize: 16,
            // 아이콘 크기 조정
            iconDisabledColor: Colors.white,
            isDense: true,
            // 버튼 높이 최소화
            isExpanded: false,
            // 너비 최소화
            style: TextStyle(
              color: fontColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconTextButton(String text, String iconPath) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              width: iconSize,
              height: iconSize,
            ),
            const SizedBox(width: 4), // 간격 조정
            Text(
              text,
              style: TextStyle(
                color: fontColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIconButton(String iconPath) {
    return Container(
      width: 27,
      height: 27,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Image.asset(
          iconPath,
          color: fontColor,
        ),
        iconSize: iconSize,
        onPressed: () {},
        padding: EdgeInsets.zero,
      ),
    );
  }
}

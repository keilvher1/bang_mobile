import 'package:flutter/material.dart';

class FilterRowWidget extends StatefulWidget {
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
  _FilterRowWidgetState createState() => _FilterRowWidgetState();
}

class _FilterRowWidgetState extends State<FilterRowWidget> {
  bool _isHorrorSelected = false;
  bool _isActivitySelected = false;

  void _toggleHorror() {
    setState(() {
      _isHorrorSelected = !_isHorrorSelected;
    });
  }

  void _toggleActivity() {
    setState(() {
      _isActivitySelected = !_isActivitySelected;
    });
  }

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
          _buildIconTextButton(
            '공포도',
            'assets/icon/ghost_no.png',
            _isHorrorSelected,
            _toggleHorror,
          ),
          const SizedBox(width: 5),
          _buildIconTextButton(
            '활동성',
            'assets/icon/shoe_no.png',
            _isActivitySelected,
            _toggleActivity,
          ),
          const SizedBox(width: 14),
          _buildCircleIconButton('assets/button/filter.png'),
        ],
      ),
    );
  }

  Widget _buildDropdownButton(String label, List<String> options) {
    return Container(
      height: widget.height,
      padding: EdgeInsets.symmetric(
          horizontal: widget.horizontalPadding, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(30),
      ),
      child: IntrinsicWidth(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: label,
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    color: widget.fontColor,
                    fontSize: widget.fontSize,
                    fontWeight: widget.fontWeight,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {},
            dropdownColor: Colors.black,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            iconSize: 16,
            isDense: true,
            isExpanded: false,
            style: TextStyle(
              color: widget.fontColor,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconTextButton(
    String text,
    String iconPath,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: widget.height,
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                iconPath,
                width: widget.iconSize,
                height: widget.iconSize,
                color: isSelected ? Colors.black : Colors.white,
              ),
              const SizedBox(width: 7),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.black : widget.fontColor,
                  fontSize: widget.fontSize,
                  fontWeight: widget.fontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIconButton(String iconPath) {
    return Container(
      width: 27,
      height: 27,
      // decoration: BoxDecoration(
      //   color: Colors.grey[800],
      //   shape: BoxShape.circle,
      // ),
      child: IconButton(
        icon: Image.asset(
          iconPath,
          fit: BoxFit.contain,
        ),
        iconSize: widget.iconSize,
        onPressed: () {},
        padding: EdgeInsets.zero,
      ),
    );
  }
}

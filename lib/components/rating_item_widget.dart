import 'package:flutter/material.dart';

class RatingItemWidget extends StatefulWidget {
  final String label;
  final String? imagePath; // 이미지 경로
  final Color? color;
  final String? value;
  final String? subText;

  const RatingItemWidget({
    super.key,
    required this.label,
    this.imagePath,
    this.color,
    this.value,
    this.subText,
  });

  @override
  _RatingItemWidgetState createState() => _RatingItemWidgetState();
}

class _RatingItemWidgetState extends State<RatingItemWidget> {
  bool _isSelected = false; // 아이콘 색상 상태

  void _toggleSelection() {
    setState(() {
      _isSelected = !_isSelected; // 클릭 시 상태 변경
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSelection, // 클릭 이벤트
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.imagePath != null)
                Image.asset(
                  widget.imagePath!,
                  color: _isSelected ? Colors.red : widget.color, // 클릭 시 색 변경
                  width: 16,
                  height: 16,
                ),
              if (widget.value != null)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    widget.value!,
                    style: TextStyle(
                      color:
                          _isSelected ? Colors.red : widget.color, // 클릭 시 색 변경
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

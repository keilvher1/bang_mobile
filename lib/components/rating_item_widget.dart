import 'package:flutter/material.dart';

class RatingItemWidget extends StatelessWidget {
  final String label;
  final String? imagePath; // 이미지 경로를 위한 필드
  final Color? color;
  final String? value;
  final String? subText;

  const RatingItemWidget({
    Key? key,
    required this.label,
    this.imagePath,
    this.color,
    this.value,
    this.subText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        if (imagePath != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath!,
                color: color,
                width: 16,
                height: 16,
              ),
              if (value != null)
                Text(
                  value!,
                  style: TextStyle(color: color, fontSize: 11),
                ),
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subText != null)
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                    subText!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

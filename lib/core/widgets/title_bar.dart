import 'package:flutter/material.dart';

import '../constants/app_color.dart';
import '../constants/app_size.dart';

class TitleBar extends StatelessWidget {
  final String title;
  const TitleBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BackButton(
          color: AppColor.white,
          onPressed: () => Navigator.pop(context),
        ),
        Expanded(
          child: Text(
            title,
            style: TextStyle(color: AppColor.white, fontSize: FontSize.largeFont, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

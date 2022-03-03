import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_color.dart';
import '../constants/app_size.dart';

class ErrorInfo extends StatelessWidget {
  final double? height;
  final String errorMessage;
  const ErrorInfo({
    Key? key,
    this.height,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.signal_wifi_connected_no_internet_4, color: AppColor.errorColor, size: 150.h),
          SizedBox(height: 25.h),
          Text(
            errorMessage,
            style: TextStyle(color: AppColor.white, fontSize: FontSize.largeFont),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

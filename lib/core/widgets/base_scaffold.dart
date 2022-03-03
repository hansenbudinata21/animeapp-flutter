import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_color.dart';

class BaseScaffold extends StatelessWidget {
  final FloatingActionButton? floatingActionButton;
  final Widget body;
  const BaseScaffold({
    Key? key,
    required this.body,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: floatingActionButton,
      body: Container(
        height: 1.sh,
        width: 1.sw,
        padding: EdgeInsets.only(left: 50.w, right: 50.w, top: 150.h, bottom: 50.h),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppColor.gradientBlack,
              AppColor.black,
            ],
            stops: [0.2, 0.6],
          ),
        ),
        child: body,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_color.dart';
import '../constants/app_size.dart';

class SearchBar extends StatelessWidget {
  final Function(BuildContext, String)? onChanged;
  final Function()? onTap;

  const SearchBar({
    Key? key,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InputBorder inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColor.gradientBlack,
        width: 3.r,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.circular(CurveSize.mediumCurve),
    );

    final TextStyle searchTextStyle = TextStyle(fontSize: FontSize.mediumFont, fontWeight: FontWeight.w600);

    return TextField(
      autofocus: onTap == null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 45.h),
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
        fillColor: AppColor.black,
        filled: true,
        hintText: "Search",
        hintStyle: searchTextStyle.copyWith(color: AppColor.grey),
        prefixIcon: const Icon(Icons.search, color: AppColor.white),
      ),
      onTap: onTap,
      onChanged: onChanged != null ? (String value) => onChanged!(context, value) : (_) {},
      readOnly: onTap != null,
      style: searchTextStyle.copyWith(color: AppColor.white),
    );
  }
}

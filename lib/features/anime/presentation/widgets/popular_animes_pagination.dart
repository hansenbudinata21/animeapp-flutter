import 'package:animeapp/core/constants/app_color.dart';
import 'package:animeapp/core/constants/app_size.dart';
import 'package:animeapp/features/anime/presentation/bloc/popular_animes_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopularAnimesPagination extends StatelessWidget {
  final int page;
  PopularAnimesPagination({Key? key, required this.page}) : super(key: key);

  final TextStyle pageTextStyle = TextStyle(color: AppColor.white, fontSize: FontSize.largeFont, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (page > 1)
          GestureDetector(
            onTap: () {
              BlocProvider.of<PopularAnimesBloc>(context).add(GetPopularAnimesByPage(page: page - 1));
            },
            child: _buildPageItem(color: AppColor.gradientBlack, page: page - 1),
          ),
        SizedBox(width: 25.w),
        _buildPageItem(color: AppColor.primaryColor, page: page),
        SizedBox(width: 25.w),
        GestureDetector(
          onTap: () {
            BlocProvider.of<PopularAnimesBloc>(context).add(GetPopularAnimesByPage(page: page + 1));
          },
          child: _buildPageItem(color: AppColor.gradientBlack, page: page + 1),
        ),
      ],
    );
  }

  Container _buildPageItem({required Color color, required int page}) {
    return Container(
      height: 100.w,
      width: 100.w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(CurveSize.smallCurve), color: color),
      child: Center(child: Text("$page", style: pageTextStyle)),
    );
  }
}

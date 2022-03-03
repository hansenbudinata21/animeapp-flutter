import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../domain/entities/anime.dart';

class PopularAnimesGrid extends StatelessWidget {
  final List<Anime> animes;
  const PopularAnimesGrid({
    Key? key,
    required this.animes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 40.w,
        mainAxisSpacing: 40.h,
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return PopularAnimesItem(
          anime: animes[index],
          index: index,
        );
      },
      itemCount: animes.length,
    );
  }
}

class PopularAnimesItem extends StatelessWidget {
  final int index;
  final Anime anime;
  PopularAnimesItem({Key? key, required this.index, required this.anime}) : super(key: key);

  final TextStyle titleTextStyle = TextStyle(color: AppColor.white, fontSize: FontSize.smallFont, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/detail", arguments: anime),
      child: Stack(
        children: [
          CachedImage(
            imageUrl: anime.imageUrl,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(CurveSize.mediumCurve),
              gradient: const LinearGradient(
                colors: [Colors.transparent, AppColor.gradientBlack],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.65, 1],
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: (1.sw - 190.w) / 2,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Text(
                anime.title,
                style: titleTextStyle,
                maxLines: 4,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

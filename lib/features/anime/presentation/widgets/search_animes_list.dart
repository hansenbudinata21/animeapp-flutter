import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../domain/entities/anime.dart';

class SearchAnimesList extends StatelessWidget {
  final List<Anime> animes;
  const SearchAnimesList({
    Key? key,
    required this.animes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return SearchAnimesItem(anime: animes[index]);
      },
      itemCount: animes.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 50.h);
      },
    );
  }
}

class SearchAnimesItem extends StatelessWidget {
  final Anime anime;
  SearchAnimesItem({Key? key, required this.anime}) : super(key: key);

  final TextStyle titleTextStyle = TextStyle(color: AppColor.white, fontSize: FontSize.mediumFont, fontWeight: FontWeight.w500);
  final TextStyle descriptionTextStyle = TextStyle(fontFamily: "Poppins", fontSize: FontSize.smallFont, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/detail", arguments: anime),
      child: Row(
        children: [
          CachedImage(
            imageUrl: anime.imageUrl,
            height: 250.h,
            width: 250.h,
          ),
          SizedBox(width: 50.w),
          Expanded(
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    anime.title,
                    style: titleTextStyle,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: _buildLatestEpisode(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  RichText _buildLatestEpisode() {
    return RichText(
      maxLines: 1,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: "Latest : ",
            style: descriptionTextStyle.copyWith(color: AppColor.grey),
          ),
          TextSpan(
            text: "Episode ${anime.lastEpisode}",
            style: descriptionTextStyle.copyWith(color: AppColor.primaryColor),
          )
        ],
      ),
    );
  }
}

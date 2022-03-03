import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../domain/entities/anime.dart';

class HomePopularAnimesList extends StatelessWidget {
  final List<Anime> animes;
  const HomePopularAnimesList({
    Key? key,
    required this.animes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return HomePopularAnimesItem(
          anime: animes[index],
          index: index,
        );
      },
      itemCount: animes.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 50.h);
      },
    );
  }
}

class HomePopularAnimesItem extends StatelessWidget {
  final int index;
  final Anime anime;
  HomePopularAnimesItem({Key? key, required this.index, required this.anime}) : super(key: key);

  final TextStyle titleTextStyle = TextStyle(color: AppColor.white, fontSize: FontSize.mediumFont, fontWeight: FontWeight.w500);
  final TextStyle descriptionTextStyle = TextStyle(fontFamily: "Poppins", fontSize: FontSize.smallFont, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/detail", arguments: anime),
      child: Row(
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              "${index + 1}.",
              style: titleTextStyle,
              maxLines: 1,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          CachedImage(
            imageUrl: anime.imageUrl,
            height: 275.h,
            width: 275.h,
          ),
          SizedBox(width: 50.w),
          Expanded(
            child: SizedBox(
              height: 275.h,
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
                  SizedBox(height: 5.h),
                  _buildStatus(),
                  SizedBox(height: 5.h),
                  _buildLatestEpisode(),
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
            text: "Latest: ",
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

  RichText _buildStatus() {
    return RichText(
      maxLines: 1,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: "Status: ",
            style: descriptionTextStyle.copyWith(color: AppColor.grey),
          ),
          TextSpan(
            text: anime.status,
            style: descriptionTextStyle.copyWith(color: anime.status == "Ongoing" ? AppColor.successColor : AppColor.errorColor),
          )
        ],
      ),
    );
  }
}

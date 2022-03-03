import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../domain/entities/anime.dart';
import '../bloc/iframe_urls_bloc.dart';

class DetailEpisodesList extends StatelessWidget {
  final ScrollController scrollController;
  final Anime anime;
  final int numberOfEpisodes;

  const DetailEpisodesList({
    Key? key,
    required this.scrollController,
    required this.anime,
    required this.numberOfEpisodes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Episodes :",
            style: TextStyle(color: AppColor.grey, fontSize: FontSize.smallFont),
          ),
          SizedBox(height: 25.h),
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return DetailEpisodesItem(
                anime: anime,
                index: index,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 25.h);
            },
            itemCount: min(numberOfEpisodes, anime.totalEpisodes),
          ),
        ],
      ),
    );
  }
}

class DetailEpisodesItem extends StatelessWidget {
  const DetailEpisodesItem({
    Key? key,
    required this.anime,
    required this.index,
  }) : super(key: key);

  final Anime anime;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        BlocProvider.of<IframeUrlsBloc>(context).add(GetIframeUrls(id: anime.episodesId[anime.totalEpisodes - index]));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 25.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CurveSize.smallCurve),
          color: AppColor.gradientBlack,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Episode ${anime.totalEpisodes - index}",
              style: TextStyle(color: AppColor.white, fontSize: FontSize.smallFont),
            ),
            Text(
              anime.episodesId[anime.totalEpisodes - index],
              style: TextStyle(color: AppColor.grey, fontSize: FontSize.smallFont),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../domain/entities/anime.dart';
import '../bloc/iframe_urls_bloc.dart';

class HomeRecentlyReleasedEpisodesList extends StatelessWidget {
  final List<Anime> animes;
  const HomeRecentlyReleasedEpisodesList({
    Key? key,
    required this.animes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 800.h,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return HomeRecentlyReleasedEpisodesItem(anime: animes[index]);
        },
        itemCount: animes.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 50.w);
        },
      ),
    );
  }
}

class HomeRecentlyReleasedEpisodesItem extends StatelessWidget {
  final Anime anime;
  const HomeRecentlyReleasedEpisodesItem({
    Key? key,
    required this.anime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle titleTextStyle = TextStyle(color: AppColor.white, fontSize: FontSize.mediumFont, fontWeight: FontWeight.w500);
    final TextStyle descriptionTextStyle = TextStyle(fontFamily: "Poppins", fontSize: FontSize.smallFont, fontWeight: FontWeight.w500);

    return GestureDetector(
      onTap: () {
        BlocProvider.of<IframeUrlsBloc>(context).add(GetIframeUrls(id: anime.lastEpisodeId!));
      },
      child: SizedBox(
        width: 400.w,
        child: Column(
          children: [
            CachedImage(imageUrl: anime.imageUrl, height: 550.h),
            SizedBox(height: 25.h),
            Text(
              anime.title,
              style: titleTextStyle,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Text(
                "Episode ${anime.lastEpisode}",
                style: descriptionTextStyle.copyWith(color: AppColor.primaryColor),
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../domain/entities/anime.dart';
import '../bloc/iframe_urls_bloc.dart';

class DetailAnimeInfo extends StatelessWidget {
  final Anime anime;
  DetailAnimeInfo({Key? key, required this.anime}) : super(key: key);

  final TextStyle titleTextStyle = TextStyle(color: AppColor.white, fontSize: FontSize.mediumFont, fontWeight: FontWeight.w500);
  final TextStyle descriptionTextStyle = TextStyle(fontFamily: "Poppins", fontSize: FontSize.smallFont, fontWeight: FontWeight.w500);
  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: 30.h),
    primary: AppColor.primaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CurveSize.smallCurve)),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedImage(
                imageUrl: anime.imageUrl,
                height: 650.h,
                width: 400.w,
              ),
              SizedBox(width: 50.w),
              Expanded(
                child: SizedBox(
                  height: 700.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Title :",
                        style: TextStyle(color: AppColor.grey, fontSize: FontSize.smallFont),
                      ),
                      Text(
                        anime.title,
                        style: TextStyle(color: AppColor.white, fontSize: FontSize.smallFont, fontWeight: FontWeight.bold),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 25.h),
                      ..._buildReleasedYear(),
                      SizedBox(height: 25.h),
                      ..._buildStatus(),
                      SizedBox(height: 25.h),
                      ..._buildLatestEpisode(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 50.h),
        _buildButtons(context),
        SizedBox(height: 50.h),
        _buildGenres(),
        SizedBox(height: 50.h),
        _buildSynopsis(),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.w),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                BlocProvider.of<IframeUrlsBloc>(context).add(GetIframeUrls(id: anime.episodesId[1]));
              },
              child: Text(
                "Watch First",
                style: titleTextStyle,
              ),
              style: buttonStyle,
            ),
          ),
          SizedBox(width: 50.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                BlocProvider.of<IframeUrlsBloc>(context).add(GetIframeUrls(id: anime.episodesId.last));
              },
              child: Text(
                "Watch Last",
                style: titleTextStyle,
              ),
              style: buttonStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenres() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Genres :",
            style: descriptionTextStyle.copyWith(color: AppColor.grey),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 20.w,
            runSpacing: 20.h,
            children: anime.genres.map((genre) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(CurveSize.mediumCurve),
                  color: AppColor.gradientBlack,
                ),
                child: Text(
                  genre.toUpperCase(),
                  style: descriptionTextStyle.copyWith(color: AppColor.white),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSynopsis() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Plot Summary :",
            style: descriptionTextStyle.copyWith(color: AppColor.grey),
          ),
          ExpandableText(
            anime.synopsisTrim,
            style: descriptionTextStyle.copyWith(color: AppColor.white),
            expandText: 'show more',
            collapseText: 'show less',
            textAlign: TextAlign.justify,
            maxLines: 5,
            linkColor: AppColor.primaryColor,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildReleasedYear() {
    return [
      Text(
        "Released :",
        style: descriptionTextStyle.copyWith(color: AppColor.grey),
      ),
      Text(
        "${anime.releasedYear ?? "-"}",
        style: descriptionTextStyle.copyWith(color: AppColor.white),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  List<Widget> _buildStatus() {
    return [
      Text(
        "Status :",
        style: descriptionTextStyle.copyWith(color: AppColor.grey),
      ),
      Text(
        anime.status,
        style: descriptionTextStyle.copyWith(color: anime.status == "Ongoing" ? AppColor.successColor : AppColor.errorColor),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  List<Widget> _buildLatestEpisode() {
    return [
      Text(
        "Latest Episode :",
        style: descriptionTextStyle.copyWith(color: AppColor.grey),
      ),
      Text(
        "Episode ${anime.lastEpisode}",
        style: descriptionTextStyle.copyWith(color: AppColor.primaryColor),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }
}

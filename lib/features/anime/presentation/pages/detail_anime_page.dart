import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/widgets/base_scaffold.dart';
import '../../../../core/widgets/circular_loading.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/anime.dart';
import '../bloc/iframe_urls_bloc.dart';
import '../widgets/detail_anime_info.dart';
import '../widgets/detail_episodes_list.dart';
import '../../../../core/widgets/title_bar.dart';

class DetailAnimePage extends StatefulWidget {
  final Anime anime;
  const DetailAnimePage({Key? key, required this.anime}) : super(key: key);

  @override
  State<DetailAnimePage> createState() => _DetailAnimePageState();
}

class _DetailAnimePageState extends State<DetailAnimePage> {
  final ScrollController scrollController = ScrollController();
  int numberOfEpisodes = 20;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<IframeUrlsBloc>(
      create: (context) => sl<IframeUrlsBloc>(),
      child: BlocConsumer<IframeUrlsBloc, IframeUrlsState>(
        listener: (context, state) {
          if (state is IframeUrlsLoaded) {
            Navigator.pushNamed(context, "/stream", arguments: state.iframeUrls[0]);
          } else if (state is IframeUrlsError) {
            final SnackBar errorSnackBar = SnackBar(content: Text((state).errorMessage));
            ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
          }
        },
        builder: (context, state) {
          if (state is IframeUrlsLoading) {
            return CircularLoading(size: 70.w);
          }

          return BaseScaffold(
            floatingActionButton: numberOfEpisodes > 20
                ? FloatingActionButton(
                    backgroundColor: AppColor.primaryColor,
                    child: const Icon(Icons.arrow_upward, color: AppColor.white),
                    onPressed: () {
                      scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                    },
                  )
                : null,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleBar(title: widget.anime.title),
                SizedBox(height: 100.h),
                Expanded(
                  child: LazyLoadScrollView(
                    onEndOfPage: () {
                      if (numberOfEpisodes > widget.anime.totalEpisodes) return;
                      setState(() {
                        numberOfEpisodes += 20;
                      });
                    },
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          DetailAnimeInfo(anime: widget.anime),
                          SizedBox(height: 100.h),
                          DetailEpisodesList(
                            scrollController: scrollController,
                            anime: widget.anime,
                            numberOfEpisodes: numberOfEpisodes,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

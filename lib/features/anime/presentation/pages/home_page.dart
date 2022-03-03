import '../bloc/iframe_urls_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/widgets/base_scaffold.dart';
import '../../../../core/widgets/circular_loading.dart';
import '../../../../injection_container.dart';
import '../bloc/popular_animes_bloc.dart';
import '../bloc/recently_released_episodes_bloc.dart';
import '../../../../core/widgets/error_info.dart';
import '../widgets/home_popular_animes_list.dart';
import '../widgets/home_recently_released_episodes_list.dart';
import '../../../../core/widgets/search_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RecentlyReleasedEpisodesBloc>(
          create: (BuildContext context) => sl<RecentlyReleasedEpisodesBloc>()..add(GetFirstTwentyRecentlyReleasedEpisodes()),
        ),
        BlocProvider<PopularAnimesBloc>(
          create: (BuildContext context) => sl<PopularAnimesBloc>()..add(const GetPopularAnimesByPage(page: 1)),
        ),
        BlocProvider<IframeUrlsBloc>(
          create: (BuildContext context) => sl<IframeUrlsBloc>(),
        ),
      ],
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
            body: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SearchBar(
                      onTap: () => Navigator.pushNamed(context, "/search"),
                    ),
                    SizedBox(height: 175.h),
                    Text(
                      "What are you\nlooking for?",
                      style: TextStyle(color: AppColor.white, fontSize: FontSize.headerFont, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25.h),
                    Text(
                      "Check out our recently released\nand popular animes",
                      style: TextStyle(color: AppColor.white, fontSize: FontSize.smallFont),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 200.h),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Recently Released Episodes",
                        style: TextStyle(
                          color: AppColor.white,
                          fontSize: FontSize.subHeaderFont,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 50.h),
                    BlocConsumer<RecentlyReleasedEpisodesBloc, RecentlyReleasedEpisodesState>(
                      listener: (context, state) {
                        if (state is RecentlyReleasedEpisodesError) {
                          final SnackBar errorSnackBar = SnackBar(content: Text((state).errorMessage));
                          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
                        }
                      },
                      builder: (context, state) {
                        if (state is RecentlyReleasedEpisodesInitial) {
                          return CircularLoading(size: 800.h);
                        } else if (state is RecentlyReleasedEpisodesLoading) {
                          return CircularLoading(size: 800.h);
                        } else if (state is RecentlyReleasedEpisodesLoaded) {
                          return HomeRecentlyReleasedEpisodesList(animes: state.recentlyReleasedEpisodes);
                        } else if (state is RecentlyReleasedEpisodesError) {
                          return ErrorInfo(errorMessage: state.errorMessage);
                        }

                        return Container();
                      },
                    ),
                    SizedBox(height: 50.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            "Popular Animes",
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: FontSize.subHeaderFont,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed("/popular");
                          },
                          child: Text(
                            "See all >",
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: FontSize.mediumFont,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50.h),
                    BlocConsumer<PopularAnimesBloc, PopularAnimesState>(
                      listener: (context, state) {
                        if (state is PopularAnimesError) {
                          final SnackBar errorSnackBar = SnackBar(content: Text((state).errorMessage));
                          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
                        }
                      },
                      builder: (context, state) {
                        if (state is PopularAnimesInitial) {
                          return CircularLoading(size: 800.h);
                        } else if (state is PopularAnimesLoading) {
                          return CircularLoading(size: 800.h);
                        } else if (state is PopularAnimesLoaded) {
                          return HomePopularAnimesList(animes: state.popularAnimes);
                        } else if (state is PopularAnimesError) {
                          return ErrorInfo(errorMessage: state.errorMessage);
                        }

                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

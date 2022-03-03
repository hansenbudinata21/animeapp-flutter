import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/base_scaffold.dart';
import '../../../../core/widgets/circular_loading.dart';
import '../../../../core/widgets/error_info.dart';
import '../../../../core/widgets/title_bar.dart';
import '../../../../injection_container.dart';
import '../bloc/popular_animes_bloc.dart';
import '../widgets/popular_animes_grid.dart';
import '../widgets/popular_animes_pagination.dart';

class PopularAnimePage extends StatelessWidget {
  const PopularAnimePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PopularAnimesBloc>(
      create: (BuildContext context) => sl<PopularAnimesBloc>()..add(const GetPopularAnimesByPage(page: 1)),
      child: BaseScaffold(
        body: Column(
          children: [
            const TitleBar(title: "Popular Animes"),
            SizedBox(height: 50.h),
            Expanded(
              child: BlocConsumer<PopularAnimesBloc, PopularAnimesState>(
                listener: (context, state) {
                  if (state is PopularAnimesError) {
                    final SnackBar errorSnackBar = SnackBar(content: Text((state).errorMessage));
                    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
                  }
                },
                builder: (context, state) {
                  if (state is PopularAnimesInitial) {
                    return Center(child: CircularLoading(size: 70.w));
                  } else if (state is PopularAnimesLoading) {
                    return Center(child: CircularLoading(size: 70.w));
                  } else if (state is PopularAnimesLoaded) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          PopularAnimesGrid(animes: state.popularAnimes),
                          SizedBox(height: 100.h),
                          PopularAnimesPagination(page: state.page),
                          SizedBox(height: 50.h),
                        ],
                      ),
                    );
                  } else if (state is PopularAnimesError) {
                    return ErrorInfo(errorMessage: state.errorMessage);
                  }

                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

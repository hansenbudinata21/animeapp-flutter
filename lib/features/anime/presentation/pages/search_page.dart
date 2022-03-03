import 'package:animeapp/core/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/widgets/base_scaffold.dart';
import '../../../../core/widgets/circular_loading.dart';
import '../../../../injection_container.dart';
import '../bloc/search_animes_bloc.dart';
import '../widgets/search_animes_list.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchAnimesBloc>(
      create: (BuildContext context) => sl<SearchAnimesBloc>(),
      child: BaseScaffold(
        body: Column(
          children: [
            Row(
              children: [
                BackButton(
                  color: AppColor.white,
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: SearchBar(
                    onChanged: (BuildContext context, String value) => BlocProvider.of<SearchAnimesBloc>(context).add(GetSearchAnimeByTitle(title: value)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 100.h),
            BlocBuilder<SearchAnimesBloc, SearchAnimesState>(
              builder: (context, state) {
                if (state is SearchAnimesInitial) {
                  return Text(
                    "Find your favorite anime among\nour animes collection",
                    style: TextStyle(color: AppColor.grey, fontSize: FontSize.smallFont),
                    textAlign: TextAlign.center,
                  );
                } else if (state is SearchAnimesLoading) {
                  return CircularLoading(size: 100.h);
                } else if (state is SearchAnimesLoaded) {
                  return Expanded(child: SearchAnimesList(animes: state.searchAnimes));
                } else if (state is SearchAnimesEmpty) {
                  return Text(
                    "Sorry, no animes matching your\nsearch keyword(s)",
                    style: TextStyle(color: AppColor.grey, fontSize: FontSize.smallFont),
                    textAlign: TextAlign.center,
                  );
                } else if (state is SearchAnimesError) {
                  return Text(
                    state.errorMessage,
                    style: TextStyle(color: AppColor.grey, fontSize: FontSize.smallFont),
                    textAlign: TextAlign.center,
                  );
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

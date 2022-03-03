import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constants/app_color.dart';
import 'core/constants/page_route.dart';
import 'features/anime/domain/entities/anime.dart';
import 'features/anime/presentation/pages/detail_anime_page.dart';
import 'features/anime/presentation/pages/home_page.dart';
import 'features/anime/presentation/pages/popular_anime_page.dart';
import 'features/anime/presentation/pages/search_page.dart';
import 'features/anime/presentation/pages/stream_anime_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2220),
      builder: () => MaterialApp(
        builder: (BuildContext context, Widget? widget) {
          ScreenUtil.setContext(context);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: ScrollConfiguration(behavior: const ScrollBehavior(), child: widget!),
          );
        },
        debugShowCheckedModeBanner: false,
        initialRoute: "/home",
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case ("/home"):
              return AppPageRoute(
                settings: settings,
                pageBuilder: (_, __, ___) => const HomePage(),
              );
            case ("/search"):
              return AppPageRoute(
                settings: settings,
                pageBuilder: (_, __, ___) => const SearchPage(),
              );
            case ("/detail"):
              return AppPageRoute(
                settings: settings,
                pageBuilder: (_, __, ___) => DetailAnimePage(
                  anime: (settings.arguments) as Anime,
                ),
              );
            case ("/stream"):
              return AppPageRoute(
                settings: settings,
                pageBuilder: (_, __, ___) => StreamAnimePage(
                  url: (settings.arguments) as String,
                ),
              );
            case ("/popular"):
              return AppPageRoute(
                settings: settings,
                pageBuilder: (_, __, ___) => const PopularAnimePage(),
              );
            default:
              return MaterialPageRoute(builder: (_) => const Scaffold());
          }
        },
        theme: ThemeData(
          fontFamily: "Poppins",
          primarySwatch: AppColor.primaryColor,
        ),
        title: "Anime App",
      ),
    );
  }
}

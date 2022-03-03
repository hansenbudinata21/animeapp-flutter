import 'package:animeapp/core/error/failures.dart';
import 'package:animeapp/features/anime/domain/usecases/get_iframe_urls_by_id.dart';
import 'package:animeapp/features/anime/presentation/bloc/iframe_urls_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetIframeUrlsById extends Mock implements GetIframeUrlsById {}

void main() {
  late IframeUrlsBloc bloc;
  late MockGetIframeUrlsById mockGetIframeUrlsById;

  setUp(() {
    mockGetIframeUrlsById = MockGetIframeUrlsById();
    bloc = IframeUrlsBloc(getIframeUrlsById: mockGetIframeUrlsById);
    registerFallbackValue(const Params(id: "boruto-naruto-next-generations-episode-1"));
  });

  test("initial state should be DetailIframeUrlsInitial", () {
    expect(bloc.state, equals(IframeUrlsInitial()));
  });

  group("in case of GetDetailIframeUrls event", () {
    const String tId = "boruto-naruto-next-generations-episode-1";
    List<String> tUrls = const [
      "gogoplay.io/embedplus?id=OTc2MzI=&token=iXsb4Z-7SsQRXRUbhEGn9w&expires=1645955161",
      "https://sbplay2.com/e/nb7suf37mhl7",
    ];
    const String tErrorMessage = "Not Found";

    test("should get data from get_iframe_urls_by_id usecase with params from the event", () async {
      when(() => mockGetIframeUrlsById(any())).thenAnswer((_) async => Right(tUrls));
      const GetIframeUrls event = GetIframeUrls(id: tId);
      bloc.add(event);
      await untilCalled(() => mockGetIframeUrlsById(any()));
      verify(() => mockGetIframeUrlsById(Params(id: event.id)));
    });

    test("should emit [DetailIframeUrlsLoading, DetailIframeUrlsLoaded] when data is gotten successfully", () async {
      when(() => mockGetIframeUrlsById(any())).thenAnswer((_) async => Right(tUrls));
      final List<IframeUrlsState> expectedResults = [
        IframeUrlsLoading(),
        IframeUrlsLoaded(iframeUrls: tUrls),
      ];
      expectLater(bloc.stream, emitsInOrder(expectedResults));
      bloc.add(const GetIframeUrls(id: tId));
    });

    test(
      "should emit [DetailIframeUrlsLoading, DetailIframeUrlsError] when getting data fails",
      () async {
        when(() => mockGetIframeUrlsById(any())).thenAnswer((_) async => Left(ServerFailure(message: tErrorMessage)));
        final List<IframeUrlsState> expectedResults = [
          IframeUrlsLoading(),
          const IframeUrlsError(errorMessage: tErrorMessage),
        ];
        expectLater(bloc.stream, emitsInOrder(expectedResults));
        bloc.add(const GetIframeUrls(id: tId));
      },
    );
  });
}

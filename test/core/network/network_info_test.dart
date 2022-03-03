import 'package:animeapp/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetConnectionChecker extends Mock implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group("IsConnected", () {
    bool tHasConnection = true;
    test("should forward the call to InternetConnectionChecker.hasConnection", () async {
      when(() => mockInternetConnectionChecker.hasConnection).thenAnswer((_) async => tHasConnection);
      bool result = await networkInfoImpl.isConnected;
      expect(result, equals(tHasConnection));
      verify(() => mockInternetConnectionChecker.hasConnection);
    });
  });
}

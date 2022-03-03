import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_iframe_urls_by_id.dart';

part 'iframe_urls_event.dart';
part 'iframe_urls_state.dart';

class IframeUrlsBloc extends Bloc<IframeUrlsEvent, IframeUrlsState> {
  GetIframeUrlsById getIframeUrlsById;

  IframeUrlsBloc({required this.getIframeUrlsById}) : super(IframeUrlsInitial()) {
    on<GetIframeUrls>(
      (event, emit) async {
        emit(IframeUrlsLoading());
        final Either<Failure, List<String>> result = await getIframeUrlsById(Params(id: event.id));
        emit(result.fold(
          (Failure failure) => IframeUrlsError(errorMessage: failure.failureMessage),
          (List<String> urls) => IframeUrlsLoaded(
            iframeUrls: urls.map(
              (url) {
                if (url.startsWith("http")) {
                  return url;
                } else {
                  return "https://" + url;
                }
              },
            ).toList(),
          ),
        ));
      },
    );
  }
}

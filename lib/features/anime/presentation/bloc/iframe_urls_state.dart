part of 'iframe_urls_bloc.dart';

abstract class IframeUrlsState extends Equatable {
  const IframeUrlsState();

  @override
  List<Object> get props => [];
}

class IframeUrlsInitial extends IframeUrlsState {}

class IframeUrlsLoading extends IframeUrlsState {}

class IframeUrlsLoaded extends IframeUrlsState {
  final List<String> iframeUrls;
  const IframeUrlsLoaded({required this.iframeUrls});
}

class IframeUrlsError extends IframeUrlsState {
  final String errorMessage;
  const IframeUrlsError({required this.errorMessage});
}

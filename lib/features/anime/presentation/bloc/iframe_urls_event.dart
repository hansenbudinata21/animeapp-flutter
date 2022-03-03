part of 'iframe_urls_bloc.dart';

abstract class IframeUrlsEvent extends Equatable {
  const IframeUrlsEvent();

  @override
  List<Object> get props => [];
}

class GetIframeUrls extends IframeUrlsEvent {
  final String id;
  const GetIframeUrls({required this.id});
}

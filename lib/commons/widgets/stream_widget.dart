import 'package:flutter/material.dart';
import 'package:whatsappaudio/commons/base/base_state.dart';
import 'package:whatsappaudio/commons/widgets/loading_widget.dart';

typedef Widget Builder<T>(BuildContext context);

class StreamWidget<T extends BaseState> extends StatelessWidget {
  final Stream<T> stream;
  final T initialData;
  final Builder<T> successBuilder;
  final Builder<T> loadingBuilder;
  final Builder<T> failureBuilder;
  final Builder<T> unknownBuilder;
  final bool loadingWidgetWithImage;

  const StreamWidget({
    Key key,
    @required this.stream,
    @required this.successBuilder,
    this.initialData,
    this.loadingBuilder,
    this.failureBuilder,
    this.unknownBuilder,
    this.loadingWidgetWithImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      initialData: initialData,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (!snapshot.hasData) {
          if (unknownBuilder != null) return unknownBuilder(context);
          return Container();
        }
        switch (snapshot.data.status) {
          case Status.SUCCESS:
            return successBuilder(context);
          case Status.LOADING:
            if (loadingBuilder != null) return loadingBuilder(context);

            return loadingWidgetWithImage
                ? const LoadingWidget()
                : const Center(child: CircularProgressIndicator());
          case Status.FAILURE:
            if (failureBuilder != null) return failureBuilder(context);

            return Center(
                child: Text(
                    snapshot.data.exception?.message ?? 'Some Error Occurred'));
          case Status.UNKNOWN:
            if (unknownBuilder != null) return unknownBuilder(context);

            return Container();
          default:
            return Container();
        }
      },
    );
  }
}

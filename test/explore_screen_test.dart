import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/core/network/auth_token_holder.dart';
import 'package:w2t_mobile/core/network/dio_client.dart';
import 'package:w2t_mobile/features/home/bloc/explore/explore_bloc.dart';
import 'package:w2t_mobile/features/home/data/explore_api.dart';
import 'package:w2t_mobile/features/home/data/explore_content.dart';
import 'package:w2t_mobile/features/home/data/models/explore_video.dart';
import 'package:w2t_mobile/features/home/data/home_content.dart';
import 'package:w2t_mobile/features/home/ui/explore_screen.dart';

class _FakeExploreApi extends ExploreApi {
  _FakeExploreApi() : super(DioClient(AuthTokenHolder()));

  @override
  Future<List<ExploreVideo>> fetchItems(String category) async {
    return ExploreContent.videosFor(category);
  }
}

void main() {
  testWidgets('Explore uses home categories and video cost, not All or comments',
      (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      BlocProvider(
        create: (_) => ExploreBloc(api: _FakeExploreApi()),
        child: const MaterialApp(home: Scaffold(body: ExploreScreen())),
      ),
    );
    await tester.pump();

    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Watch • Learn • Share'), findsOneWidget);
    expect(find.byIcon(Icons.location_on_rounded), findsNothing);
    expect(find.textContaining('Hanamkonda'), findsNothing);
    expect(find.text('All'), findsNothing);
    expect(find.text('120'), findsNothing);
    expect(find.byIcon(Icons.chat_bubble_outline_rounded), findsNothing);
    expect(find.byIcon(Icons.mode_comment_outlined), findsNothing);

    expect(find.text('Food'), findsWidgets);
    expect(find.text('Grocery'), findsWidgets);
    expect(
      HomeContent.categories.first.label,
      'Food',
    );
    expect(find.text('Food'), findsWidgets);
    expect(find.text('₹499'), findsOneWidget);
    expect(find.text('Share Your Own Video'), findsNothing);
    expect(find.text('Upload Video'), findsNothing);
  });
}

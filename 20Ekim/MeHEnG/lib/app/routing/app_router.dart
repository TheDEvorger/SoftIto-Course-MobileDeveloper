import 'package:go_router/go_router.dart';
import '../shell/home_page.dart';
import '../pages/venture_workspace_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, _) => const HomePage()),
    GoRoute(
      path: '/venture/:id',
      builder: (_, state) =>
          VentureWorkspacePage(ventureId: state.pathParameters['id']!),
    ),
  ],
);

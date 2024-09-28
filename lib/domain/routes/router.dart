import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pixabay_prj/presentation/error_screen/error_screen.dart';

import '../../presentation/home/full_screen_image.dart';
import '../../presentation/home/home.dart';
import 'route_names.dart';

class AppRouter {
  static GoRouter appRouter = GoRouter(
    initialLocation: RouteNames.home.path,
    routes: [
      GoRoute(
        path: RouteNames.home.path,
        name: RouteNames.home.name,
        pageBuilder: (context, state) => const MaterialPage(child: Home()),
        routes: [
          GoRoute(
            path: 'image/:id',
            builder: (context, state) {
              final data = state.extra as Map<String, dynamic>? ?? {};

              return FullScreenImage(imageUrl: data['url']! ?? "Image Not Found", id: data['name'] ?? "null");
            },
          ),
        ],
      ),
    ],
    // errorPageBuilder: (context, state) => const MaterialPage(child: ErrorScreen()),
  );
}

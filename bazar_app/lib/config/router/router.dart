

import 'package:bazar_app/pages/home_screen.dart';
import 'package:bazar_app/pages/product_details_screen.dart';
import 'package:bazar_app/pages/search_results_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [

    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: '/items',
      name: 'items',
      builder: (context, state) {
        final query = state.uri.queryParameters['query']!;
        return SearchResultsScreen(searchQuery: query);
      },
      routes: [
        GoRoute(
          path: ':id',
          name: 'item-details',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ProductDetailsScreen(productId: id);
          },
        ),
      ]
    ),

  ]
);
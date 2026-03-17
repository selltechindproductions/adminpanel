import 'dart:core';
import 'package:go_router/go_router.dart';
import 'package:site_admin_pannel/features/app_drawer/view/responsive_scaffold.dart';
import 'package:site_admin_pannel/features/authentication/view/auth_screen.dart';
import 'package:site_admin_pannel/features/blog/models/blog_model.dart';
import 'package:site_admin_pannel/features/blog/view/blog_screen.dart';
import 'package:site_admin_pannel/features/blog/view/create_new_blog_screen.dart';
import 'package:site_admin_pannel/features/contacts/views/contacts_screen.dart';
import 'package:site_admin_pannel/features/content/views/content_screen.dart';
import 'package:site_admin_pannel/features/dashboard/view/dashboard_screen.dart';
import 'package:site_admin_pannel/features/notifications/views/notifications_screen.dart';
import 'package:site_admin_pannel/features/products/models/product_model.dart';
import 'package:site_admin_pannel/features/products/views/product_create_screen.dart';
import 'package:site_admin_pannel/features/users/views/users_edit_screen.dart';
import 'package:site_admin_pannel/features/users/views/users_screen.dart';

import '../features/products/views/product_screen.dart';
import '../features/users/models/user_model.dart';

class AppRouter {
  static final String dashboard = '/dashboard';
  static final String auth = '/';
  static final String content = '/content';
  static final String blogs = '/blogs';
  static final String createBlog = '/blogs/create';
  static final String users = '/users';
  static final String usersEdit = '/users/edit';
  static final String usersCreate = '/users/create';
  static final String products = '/products';
  static final String productsCreate = '/products/create';
  static final String designs = '/designs';
  static final String contacts = '/contacts';
  static final String notifications = '/notifications';
  final GoRouter router = GoRouter(
    initialLocation: dashboard,
    routes: [
      GoRoute(path: auth, builder: (context, state) => AuthScreen()),
      GoRoute(
        path: dashboard,
        builder:
            (context, state) => ResponsiveScaffold(body: DashboardScreen()),
      ),
      GoRoute(
        path: content,
        builder: (context, state) => ResponsiveScaffold(body: ContentScreen()),
      ),
      GoRoute(
        path: blogs,
        builder: (context, state) => ResponsiveScaffold(body: BlogsScreen()),
        routes: [
          GoRoute(
            path: createBlog.split('/').last,
            builder: (context, state) {
              final extra = state.extra as BlogModel?;
              return ResponsiveScaffold(
                body: CreateNewBlogScreen(editingBlog: extra),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: users,
        builder: (context, state) => ResponsiveScaffold(body: UsersScreen()),
        routes: [
          GoRoute(
            path: usersEdit.split('/').last,
            builder: (context, state) {
              final extra = state.extra as UserModel?;
              return ResponsiveScaffold(
                body: CreateEditUserScreen(editingUser: extra),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: products,
        builder: (context, state) => ResponsiveScaffold(body: ProductsScreen()),
        routes: [
          GoRoute(
            path: productsCreate.split('/').last,
            builder: (context, state) {
              final extra = state.extra as ProductModel?;
              return ResponsiveScaffold(
                body: CreateEditProductScreen(editingProduct: extra),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: contacts,
        builder: (context, state) => ResponsiveScaffold(body: ContactsScreen()),
      ),
      GoRoute(
        path: notifications,
        builder:
            (context, state) =>
                ResponsiveScaffold(body: SendNotificationScreen()),
      ),
    ],
  );
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/backend/schema/structs/index.dart';

import '/flutter_flow/flutter_flow_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) => UsernamePasswordWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => UsernamePasswordWidget(),
        ),
        FFRoute(
          name: AddAcquisitionsWidget.routeName,
          path: AddAcquisitionsWidget.routePath,
          builder: (context, params) => AddAcquisitionsWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: LandingASuperuserWidget.routeName,
          path: LandingASuperuserWidget.routePath,
          builder: (context, params) => LandingASuperuserWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: AddNewFamilyWidget.routeName,
          path: AddNewFamilyWidget.routePath,
          builder: (context, params) => AddNewFamilyWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: AddPlantingsWidget.routeName,
          path: AddPlantingsWidget.routePath,
          builder: (context, params) => AddPlantingsWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: AddProgenyWidget.routeName,
          path: AddProgenyWidget.routePath,
          builder: (context, params) => AddProgenyWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: AddProvenancesWidget.routeName,
          path: AddProvenancesWidget.routePath,
          builder: (context, params) => AddProvenancesWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: AddSubZonesWidget.routeName,
          path: AddSubZonesWidget.routePath,
          builder: (context, params) => AddSubZonesWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: AddZoneWidget.routeName,
          path: AddZoneWidget.routePath,
          builder: (context, params) => AddZoneWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: AddSuppliersWidget.routeName,
          path: AddSuppliersWidget.routePath,
          builder: (context, params) => AddSuppliersWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: AddUsersWidget.routeName,
          path: AddUsersWidget.routePath,
          builder: (context, params) => AddUsersWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: AddVarietiesWidget.routeName,
          path: AddVarietiesWidget.routePath,
          builder: (context, params) => AddVarietiesWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: UpdateAcquisitionsWidget.routeName,
          path: UpdateAcquisitionsWidget.routePath,
          builder: (context, params) => UpdateAcquisitionsWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: UpdatePlantingsWidget.routeName,
          path: UpdatePlantingsWidget.routePath,
          builder: (context, params) => UpdatePlantingsWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: UpdateNewFamilyWidget.routeName,
          path: UpdateNewFamilyWidget.routePath,
          builder: (context, params) => UpdateNewFamilyWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: UpdateProgenyWidget.routeName,
          path: UpdateProgenyWidget.routePath,
          builder: (context, params) => UpdateProgenyWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: UpdateVarietiesWidget.routeName,
          path: UpdateVarietiesWidget.routePath,
          builder: (context, params) => UpdateVarietiesWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: UpdateProvenancesWidget.routeName,
          path: UpdateProvenancesWidget.routePath,
          builder: (context, params) => UpdateProvenancesWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: UpdateSuppliersWidget.routeName,
          path: UpdateSuppliersWidget.routePath,
          builder: (context, params) => UpdateSuppliersWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: UpdateUsersWidget.routeName,
          path: UpdateUsersWidget.routePath,
          builder: (context, params) => UpdateUsersWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: UpdateZoneWidget.routeName,
          path: UpdateZoneWidget.routePath,
          builder: (context, params) => UpdateZoneWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: UpdateSubZoneWidget.routeName,
          path: UpdateSubZoneWidget.routePath,
          builder: (context, params) => UpdateSubZoneWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: MConservationStatusWidget.routeName,
          path: MConservationStatusWidget.routePath,
          builder: (context, params) => MConservationStatusWidget(),
        ),
        FFRoute(
          name: MContainerTypeWidget.routeName,
          path: MContainerTypeWidget.routePath,
          builder: (context, params) => MContainerTypeWidget(),
        ),
        FFRoute(
          name: MPlantUtilityWidget.routeName,
          path: MPlantUtilityWidget.routePath,
          builder: (context, params) => MPlantUtilityWidget(),
        ),
        FFRoute(
          name: MPlantingRemovalWidget.routeName,
          path: MPlantingRemovalWidget.routePath,
          builder: (context, params) => MPlantingRemovalWidget(),
        ),
        FFRoute(
          name: MProvenanceWidget.routeName,
          path: MProvenanceWidget.routePath,
          builder: (context, params) => MProvenanceWidget(),
        ),
        FFRoute(
          name: MProvenanceLocationTypesWidget.routeName,
          path: MProvenanceLocationTypesWidget.routePath,
          builder: (context, params) => MProvenanceLocationTypesWidget(),
        ),
        FFRoute(
          name: MPropagationTypeWidget.routeName,
          path: MPropagationTypeWidget.routePath,
          builder: (context, params) => MPropagationTypeWidget(),
        ),
        FFRoute(
          name: MSpeciesUtilityWidget.routeName,
          path: MSpeciesUtilityWidget.routePath,
          builder: (context, params) => MSpeciesUtilityWidget(),
        ),
        FFRoute(
          name: MZoneAspectWidget.routeName,
          path: MZoneAspectWidget.routePath,
          builder: (context, params) => MZoneAspectWidget(),
        ),
        FFRoute(
          name: VUsersWidget.routeName,
          path: VUsersWidget.routePath,
          builder: (context, params) => VUsersWidget(),
        ),
        FFRoute(
          name: VSpeciesWidget.routeName,
          path: VSpeciesWidget.routePath,
          builder: (context, params) => VSpeciesWidget(),
        ),
        FFRoute(
          name: VSuppliersWidget.routeName,
          path: VSuppliersWidget.routePath,
          builder: (context, params) => VSuppliersWidget(),
        ),
        FFRoute(
          name: VGeneticSourceWidget.routeName,
          path: VGeneticSourceWidget.routePath,
          builder: (context, params) => VGeneticSourceWidget(),
        ),
        FFRoute(
          name: VPlantingsWidget.routeName,
          path: VPlantingsWidget.routePath,
          builder: (context, params) => VPlantingsWidget(),
        ),
        FFRoute(
          name: VProgenyWidget.routeName,
          path: VProgenyWidget.routePath,
          builder: (context, params) => VProgenyWidget(),
        ),
        FFRoute(
          name: VProvenancesWidget.routeName,
          path: VProvenancesWidget.routePath,
          builder: (context, params) => VProvenancesWidget(),
        ),
        FFRoute(
          name: VZoneWidget.routeName,
          path: VZoneWidget.routePath,
          builder: (context, params) => VZoneWidget(),
        ),
        FFRoute(
          name: VSubzonesWidget.routeName,
          path: VSubzonesWidget.routePath,
          builder: (context, params) => VSubzonesWidget(),
        ),
        FFRoute(
          name: UsernamePasswordWidget.routeName,
          path: UsernamePasswordWidget.routePath,
          builder: (context, params) => UsernamePasswordWidget(),
        ),
        FFRoute(
          name: LandingClaireFrankynJonesWidget.routeName,
          path: LandingClaireFrankynJonesWidget.routePath,
          builder: (context, params) => LandingClaireFrankynJonesWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: LandingLizBarbourWidget.routeName,
          path: LandingLizBarbourWidget.routePath,
          builder: (context, params) => LandingLizBarbourWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: LandingValMacduffWidget.routeName,
          path: LandingValMacduffWidget.routePath,
          builder: (context, params) => LandingValMacduffWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: LandingGuestWidget.routeName,
          path: LandingGuestWidget.routePath,
          builder: (context, params) => LandingGuestWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: FormUpdateSpeciesWidget.routeName,
          path: FormUpdateSpeciesWidget.routePath,
          builder: (context, params) => FormUpdateSpeciesWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: PlantingCrossTabReportWidget.routeName,
          path: PlantingCrossTabReportWidget.routePath,
          builder: (context, params) => PlantingCrossTabReportWidget(),
        ),
        FFRoute(
          name: UserOtherWidget.routeName,
          path: UserOtherWidget.routePath,
          builder: (context, params) => UserOtherWidget(
            placeholder: params.getParam(
              'placeholder',
              ParamType.int,
            ),
          ),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}

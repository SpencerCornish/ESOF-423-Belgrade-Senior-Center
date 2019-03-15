// GENERATED CODE - DO NOT MODIFY BY HAND

part of app;

// **************************************************************************
// BuiltReduxGenerator
// **************************************************************************

// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: annotate_overrides

class _$AppActions extends AppActions {
  factory _$AppActions() => new _$AppActions._();
  _$AppActions._() : super._();

  final ActionDispatcher<User> setUser = new ActionDispatcher<User>('AppActions-setUser');
  final ActionDispatcher<bool> setLoading = new ActionDispatcher<bool>('AppActions-setLoading');
  final ActionDispatcher<AuthState> setAuthState = new ActionDispatcher<AuthState>('AppActions-setAuthState');
  final ActionDispatcher<BuiltMap<String, User>> setUserMap =
      new ActionDispatcher<BuiltMap<String, User>>('AppActions-setUserMap');
  final ActionDispatcher<BuiltMap<String, Activity>> setActivityMap =
      new ActionDispatcher<BuiltMap<String, Activity>>('AppActions-setActivityMap');
  final ActionDispatcher<BuiltMap<String, Meal>> setMealMap =
      new ActionDispatcher<BuiltMap<String, Meal>>('AppActions-setMealMap');
  final ServerMiddlewareActions server = new ServerMiddlewareActions();

  @override
  void setDispatcher(Dispatcher dispatcher) {
    setUser.setDispatcher(dispatcher);
    setLoading.setDispatcher(dispatcher);
    setAuthState.setDispatcher(dispatcher);
    setUserMap.setDispatcher(dispatcher);
    setActivityMap.setDispatcher(dispatcher);
    setMealMap.setDispatcher(dispatcher);
    server.setDispatcher(dispatcher);
  }
}

class AppActionsNames {
  static final ActionName<User> setUser = new ActionName<User>('AppActions-setUser');
  static final ActionName<bool> setLoading = new ActionName<bool>('AppActions-setLoading');
  static final ActionName<AuthState> setAuthState = new ActionName<AuthState>('AppActions-setAuthState');
  static final ActionName<BuiltMap<String, User>> setUserMap =
      new ActionName<BuiltMap<String, User>>('AppActions-setUserMap');
  static final ActionName<BuiltMap<String, Activity>> setActivityMap =
      new ActionName<BuiltMap<String, Activity>>('AppActions-setActivityMap');
  static final ActionName<BuiltMap<String, Meal>> setMealMap =
      new ActionName<BuiltMap<String, Meal>>('AppActions-setMealMap');
}

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$App extends App {
  @override
  final User user;
  @override
  final bool isLoading;
  @override
  final AuthState authState;
  @override
  final BuiltMap<String, User> userMap;
  @override
  final BuiltMap<String, Activity> activityMap;
  @override
  final BuiltMap<String, Meal> mealMap;

  factory _$App([void updates(AppBuilder b)]) => (new AppBuilder()..update(updates)).build();

  _$App._({this.user, this.isLoading, this.authState, this.userMap, this.activityMap, this.mealMap}) : super._() {
    if (isLoading == null) {
      throw new BuiltValueNullFieldError('App', 'isLoading');
    }
    if (authState == null) {
      throw new BuiltValueNullFieldError('App', 'authState');
    }
    if (userMap == null) {
      throw new BuiltValueNullFieldError('App', 'userMap');
    }
    if (activityMap == null) {
      throw new BuiltValueNullFieldError('App', 'activityMap');
    }
    if (mealMap == null) {
      throw new BuiltValueNullFieldError('App', 'mealMap');
    }
  }

  @override
  App rebuild(void updates(AppBuilder b)) => (toBuilder()..update(updates)).build();

  @override
  AppBuilder toBuilder() => new AppBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is App &&
        user == other.user &&
        isLoading == other.isLoading &&
        authState == other.authState &&
        userMap == other.userMap &&
        activityMap == other.activityMap &&
        mealMap == other.mealMap;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc($jc(0, user.hashCode), isLoading.hashCode), authState.hashCode), userMap.hashCode),
            activityMap.hashCode),
        mealMap.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('App')
          ..add('user', user)
          ..add('isLoading', isLoading)
          ..add('authState', authState)
          ..add('userMap', userMap)
          ..add('activityMap', activityMap)
          ..add('mealMap', mealMap))
        .toString();
  }
}

class AppBuilder implements Builder<App, AppBuilder> {
  _$App _$v;

  UserBuilder _user;
  UserBuilder get user => _$this._user ??= new UserBuilder();
  set user(UserBuilder user) => _$this._user = user;

  bool _isLoading;
  bool get isLoading => _$this._isLoading;
  set isLoading(bool isLoading) => _$this._isLoading = isLoading;

  AuthState _authState;
  AuthState get authState => _$this._authState;
  set authState(AuthState authState) => _$this._authState = authState;

  MapBuilder<String, User> _userMap;
  MapBuilder<String, User> get userMap => _$this._userMap ??= new MapBuilder<String, User>();
  set userMap(MapBuilder<String, User> userMap) => _$this._userMap = userMap;

  MapBuilder<String, Activity> _activityMap;
  MapBuilder<String, Activity> get activityMap => _$this._activityMap ??= new MapBuilder<String, Activity>();
  set activityMap(MapBuilder<String, Activity> activityMap) => _$this._activityMap = activityMap;

  MapBuilder<String, Meal> _mealMap;
  MapBuilder<String, Meal> get mealMap => _$this._mealMap ??= new MapBuilder<String, Meal>();
  set mealMap(MapBuilder<String, Meal> mealMap) => _$this._mealMap = mealMap;

  AppBuilder();

  AppBuilder get _$this {
    if (_$v != null) {
      _user = _$v.user?.toBuilder();
      _isLoading = _$v.isLoading;
      _authState = _$v.authState;
      _userMap = _$v.userMap?.toBuilder();
      _activityMap = _$v.activityMap?.toBuilder();
      _mealMap = _$v.mealMap?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(App other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$App;
  }

  @override
  void update(void updates(AppBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$App build() {
    _$App _$result;
    try {
      _$result = _$v ??
          new _$App._(
              user: _user?.build(),
              isLoading: isLoading,
              authState: authState,
              userMap: userMap.build(),
              activityMap: activityMap.build(),
              mealMap: mealMap.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'user';
        _user?.build();

        _$failedField = 'userMap';
        userMap.build();
        _$failedField = 'activityMap';
        activityMap.build();
        _$failedField = 'mealMap';
        mealMap.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('App', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

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

  final ActionDispatcher<User> setUser =
      new ActionDispatcher<User>('AppActions-setUser');
  final ActionDispatcher<bool> setLoading =
      new ActionDispatcher<bool>('AppActions-setLoading');
  final ActionDispatcher<AuthState> setAuthState =
      new ActionDispatcher<AuthState>('AppActions-setAuthState');
  final ServerMiddlewareActions server = new ServerMiddlewareActions();

  @override
  void setDispatcher(Dispatcher dispatcher) {
    setUser.setDispatcher(dispatcher);
    setLoading.setDispatcher(dispatcher);
    setAuthState.setDispatcher(dispatcher);
    server.setDispatcher(dispatcher);
  }
}

class AppActionsNames {
  static final ActionName<User> setUser =
      new ActionName<User>('AppActions-setUser');
  static final ActionName<bool> setLoading =
      new ActionName<bool>('AppActions-setLoading');
  static final ActionName<AuthState> setAuthState =
      new ActionName<AuthState>('AppActions-setAuthState');
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

  factory _$App([void updates(AppBuilder b)]) =>
      (new AppBuilder()..update(updates)).build();

  _$App._({this.user, this.isLoading, this.authState}) : super._() {
    if (isLoading == null) {
      throw new BuiltValueNullFieldError('App', 'isLoading');
    }
    if (authState == null) {
      throw new BuiltValueNullFieldError('App', 'authState');
    }
  }

  @override
  App rebuild(void updates(AppBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  AppBuilder toBuilder() => new AppBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is App &&
        user == other.user &&
        isLoading == other.isLoading &&
        authState == other.authState;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc(0, user.hashCode), isLoading.hashCode), authState.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('App')
          ..add('user', user)
          ..add('isLoading', isLoading)
          ..add('authState', authState))
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

  AppBuilder();

  AppBuilder get _$this {
    if (_$v != null) {
      _user = _$v.user?.toBuilder();
      _isLoading = _$v.isLoading;
      _authState = _$v.authState;
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
              user: _user?.build(), isLoading: isLoading, authState: authState);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'App', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

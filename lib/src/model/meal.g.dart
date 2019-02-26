// GENERATED CODE - DO NOT MODIFY BY HAND

part of meal;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Meal extends Meal {
  @override
  final String uid;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final BuiltList<String> menu;

  factory _$Meal([void updates(MealBuilder b)]) => (new MealBuilder()..update(updates)).build();

  _$Meal._({this.uid, this.startTime, this.endTime, this.menu}) : super._() {
    if (uid == null) {
      throw new BuiltValueNullFieldError('Meal', 'uid');
    }
    if (startTime == null) {
      throw new BuiltValueNullFieldError('Meal', 'startTime');
    }
    if (endTime == null) {
      throw new BuiltValueNullFieldError('Meal', 'endTime');
    }
    if (menu == null) {
      throw new BuiltValueNullFieldError('Meal', 'menu');
    }
  }

  @override
  Meal rebuild(void updates(MealBuilder b)) => (toBuilder()..update(updates)).build();

  @override
  MealBuilder toBuilder() => new MealBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Meal &&
        uid == other.uid &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        menu == other.menu;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc($jc(0, uid.hashCode), startTime.hashCode), endTime.hashCode), menu.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Meal')
          ..add('uid', uid)
          ..add('startTime', startTime)
          ..add('endTime', endTime)
          ..add('menu', menu))
        .toString();
  }
}

class MealBuilder implements Builder<Meal, MealBuilder> {
  _$Meal _$v;

  String _uid;
  String get uid => _$this._uid;
  set uid(String uid) => _$this._uid = uid;

  DateTime _startTime;
  DateTime get startTime => _$this._startTime;
  set startTime(DateTime startTime) => _$this._startTime = startTime;

  DateTime _endTime;
  DateTime get endTime => _$this._endTime;
  set endTime(DateTime endTime) => _$this._endTime = endTime;

  ListBuilder<String> _menu;
  ListBuilder<String> get menu => _$this._menu ??= new ListBuilder<String>();
  set menu(ListBuilder<String> menu) => _$this._menu = menu;

  MealBuilder();

  MealBuilder get _$this {
    if (_$v != null) {
      _uid = _$v.uid;
      _startTime = _$v.startTime;
      _endTime = _$v.endTime;
      _menu = _$v.menu?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Meal other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Meal;
  }

  @override
  void update(void updates(MealBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Meal build() {
    _$Meal _$result;
    try {
      _$result = _$v ?? new _$Meal._(uid: uid, startTime: startTime, endTime: endTime, menu: menu.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'menu';
        menu.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('Meal', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

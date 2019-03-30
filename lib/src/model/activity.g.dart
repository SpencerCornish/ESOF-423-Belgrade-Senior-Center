// GENERATED CODE - DO NOT MODIFY BY HAND

part of activity;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Activity extends Activity {
  @override
  final String uid;
  @override
  final int capacity;
  @override
  final DateTime endTime;
  @override
  final DateTime startTime;
  @override
  final String instructor;
  @override
  final String location;
  @override
  final String name;
  @override
  final BuiltList<String> users;

  factory _$Activity([void updates(ActivityBuilder b)]) => (new ActivityBuilder()..update(updates)).build();

  _$Activity._(
      {this.uid, this.capacity, this.endTime, this.startTime, this.instructor, this.location, this.name, this.users})
      : super._() {
    if (capacity == null) {
      throw new BuiltValueNullFieldError('Activity', 'capacity');
    }
    if (endTime == null) {
      throw new BuiltValueNullFieldError('Activity', 'endTime');
    }
    if (startTime == null) {
      throw new BuiltValueNullFieldError('Activity', 'startTime');
    }
    if (instructor == null) {
      throw new BuiltValueNullFieldError('Activity', 'instructor');
    }
    if (location == null) {
      throw new BuiltValueNullFieldError('Activity', 'location');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Activity', 'name');
    }
    if (users == null) {
      throw new BuiltValueNullFieldError('Activity', 'users');
    }
  }

  @override
  Activity rebuild(void updates(ActivityBuilder b)) => (toBuilder()..update(updates)).build();

  @override
  ActivityBuilder toBuilder() => new ActivityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Activity &&
        uid == other.uid &&
        capacity == other.capacity &&
        endTime == other.endTime &&
        startTime == other.startTime &&
        instructor == other.instructor &&
        location == other.location &&
        name == other.name &&
        users == other.users;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc($jc($jc(0, uid.hashCode), capacity.hashCode), endTime.hashCode), startTime.hashCode),
                    instructor.hashCode),
                location.hashCode),
            name.hashCode),
        users.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Activity')
          ..add('uid', uid)
          ..add('capacity', capacity)
          ..add('endTime', endTime)
          ..add('startTime', startTime)
          ..add('instructor', instructor)
          ..add('location', location)
          ..add('name', name)
          ..add('users', users))
        .toString();
  }
}

class ActivityBuilder implements Builder<Activity, ActivityBuilder> {
  _$Activity _$v;

  String _uid;
  String get uid => _$this._uid;
  set uid(String uid) => _$this._uid = uid;

  int _capacity;
  int get capacity => _$this._capacity;
  set capacity(int capacity) => _$this._capacity = capacity;

  DateTime _endTime;
  DateTime get endTime => _$this._endTime;
  set endTime(DateTime endTime) => _$this._endTime = endTime;

  DateTime _startTime;
  DateTime get startTime => _$this._startTime;
  set startTime(DateTime startTime) => _$this._startTime = startTime;

  String _instructor;
  String get instructor => _$this._instructor;
  set instructor(String instructor) => _$this._instructor = instructor;

  String _location;
  String get location => _$this._location;
  set location(String location) => _$this._location = location;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  ListBuilder<String> _users;
  ListBuilder<String> get users => _$this._users ??= new ListBuilder<String>();
  set users(ListBuilder<String> users) => _$this._users = users;

  ActivityBuilder();

  ActivityBuilder get _$this {
    if (_$v != null) {
      _uid = _$v.uid;
      _capacity = _$v.capacity;
      _endTime = _$v.endTime;
      _startTime = _$v.startTime;
      _instructor = _$v.instructor;
      _location = _$v.location;
      _name = _$v.name;
      _users = _$v.users?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Activity other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Activity;
  }

  @override
  void update(void updates(ActivityBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Activity build() {
    _$Activity _$result;
    try {
      _$result = _$v ??
          new _$Activity._(
              uid: uid,
              capacity: capacity,
              endTime: endTime,
              startTime: startTime,
              instructor: instructor,
              location: location,
              name: name,
              users: users.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'users';
        users.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('Activity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

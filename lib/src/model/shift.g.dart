// GENERATED CODE - DO NOT MODIFY BY HAND

part of shift;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Shift extends Shift {
  @override
  final String punchID;
  @override
  final String userID;
  @override
  final DateTime inTime;
  @override
  final DateTime outTime;
  Duration __durationWorked;

  factory _$Shift([void updates(ShiftBuilder b)]) =>
      (new ShiftBuilder()..update(updates)).build();

  _$Shift._({this.punchID, this.userID, this.inTime, this.outTime})
      : super._() {
    if (userID == null) {
      throw new BuiltValueNullFieldError('Shift', 'userID');
    }
  }

  @override
  Duration get durationWorked => __durationWorked ??= super.durationWorked;

  @override
  Shift rebuild(void updates(ShiftBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ShiftBuilder toBuilder() => new ShiftBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Shift &&
        punchID == other.punchID &&
        userID == other.userID &&
        inTime == other.inTime &&
        outTime == other.outTime;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, punchID.hashCode), userID.hashCode), inTime.hashCode),
        outTime.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Shift')
          ..add('punchID', punchID)
          ..add('userID', userID)
          ..add('inTime', inTime)
          ..add('outTime', outTime))
        .toString();
  }
}

class ShiftBuilder implements Builder<Shift, ShiftBuilder> {
  _$Shift _$v;

  String _punchID;
  String get punchID => _$this._punchID;
  set punchID(String punchID) => _$this._punchID = punchID;

  String _userID;
  String get userID => _$this._userID;
  set userID(String userID) => _$this._userID = userID;

  DateTime _inTime;
  DateTime get inTime => _$this._inTime;
  set inTime(DateTime inTime) => _$this._inTime = inTime;

  DateTime _outTime;
  DateTime get outTime => _$this._outTime;
  set outTime(DateTime outTime) => _$this._outTime = outTime;

  ShiftBuilder();

  ShiftBuilder get _$this {
    if (_$v != null) {
      _punchID = _$v.punchID;
      _userID = _$v.userID;
      _inTime = _$v.inTime;
      _outTime = _$v.outTime;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Shift other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Shift;
  }

  @override
  void update(void updates(ShiftBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Shift build() {
    final _$result = _$v ??
        new _$Shift._(
            punchID: punchID, userID: userID, inTime: inTime, outTime: outTime);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

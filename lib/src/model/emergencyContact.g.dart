// GENERATED CODE - DO NOT MODIFY BY HAND

part of emergencyContact;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmergencyContact extends EmergencyContact {
  @override
  final String uid;
  @override
  final String name;
  @override
  final String relationship;
  @override
  final String number;

  factory _$EmergencyContact([void updates(EmergencyContactBuilder b)]) =>
      (new EmergencyContactBuilder()..update(updates)).build();

  _$EmergencyContact._({this.uid, this.name, this.relationship, this.number})
      : super._() {
    if (uid == null) {
      throw new BuiltValueNullFieldError('EmergencyContact', 'uid');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('EmergencyContact', 'name');
    }
    if (relationship == null) {
      throw new BuiltValueNullFieldError('EmergencyContact', 'relationship');
    }
    if (number == null) {
      throw new BuiltValueNullFieldError('EmergencyContact', 'number');
    }
  }

  @override
  EmergencyContact rebuild(void updates(EmergencyContactBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  EmergencyContactBuilder toBuilder() =>
      new EmergencyContactBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmergencyContact &&
        uid == other.uid &&
        name == other.name &&
        relationship == other.relationship &&
        number == other.number;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, uid.hashCode), name.hashCode), relationship.hashCode),
        number.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('EmergencyContact')
          ..add('uid', uid)
          ..add('name', name)
          ..add('relationship', relationship)
          ..add('number', number))
        .toString();
  }
}

class EmergencyContactBuilder
    implements Builder<EmergencyContact, EmergencyContactBuilder> {
  _$EmergencyContact _$v;

  String _uid;
  String get uid => _$this._uid;
  set uid(String uid) => _$this._uid = uid;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _relationship;
  String get relationship => _$this._relationship;
  set relationship(String relationship) => _$this._relationship = relationship;

  String _number;
  String get number => _$this._number;
  set number(String number) => _$this._number = number;

  EmergencyContactBuilder();

  EmergencyContactBuilder get _$this {
    if (_$v != null) {
      _uid = _$v.uid;
      _name = _$v.name;
      _relationship = _$v.relationship;
      _number = _$v.number;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmergencyContact other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$EmergencyContact;
  }

  @override
  void update(void updates(EmergencyContactBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$EmergencyContact build() {
    final _$result = _$v ??
        new _$EmergencyContact._(
            uid: uid, name: name, relationship: relationship, number: number);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

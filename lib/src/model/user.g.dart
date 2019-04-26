// GENERATED CODE - DO NOT MODIFY BY HAND

part of user;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$User extends User {
  @override
  final String loginUID;
  @override
  final String docUID;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String email;
  @override
  final String phoneNumber;
  @override
  final String mobileNumber;
  @override
  final String address;
  @override
  final String role;
  @override
  final String dietaryRestrictions;
  @override
  final String emergencyContactName;
  @override
  final String emergencyContactNumber;
  @override
  final String emergencyContactRelation;
  @override
  final DateTime membershipStart;
  @override
  final DateTime membershipRenewal;
  @override
  final String disabilities;
  @override
  final BuiltList<String> forms;
  @override
  final String medicalIssues;
  @override
  final String position;
  @override
  final bool homeDeliver;
  @override
  final bool medRelease;
  @override
  final bool waiverRelease;
  @override
  final bool intakeForm;
  @override
  final BuiltList<String> services;

  factory _$User([void updates(UserBuilder b)]) => (new UserBuilder()..update(updates)).build();

  _$User._(
      {this.loginUID,
      this.docUID,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.mobileNumber,
      this.address,
      this.role,
      this.dietaryRestrictions,
      this.emergencyContactName,
      this.emergencyContactNumber,
      this.emergencyContactRelation,
      this.membershipStart,
      this.membershipRenewal,
      this.disabilities,
      this.forms,
      this.medicalIssues,
      this.position,
      this.homeDeliver,
      this.medRelease,
      this.waiverRelease,
      this.intakeForm,
      this.services})
      : super._() {
    if (firstName == null) {
      throw new BuiltValueNullFieldError('User', 'firstName');
    }
    if (lastName == null) {
      throw new BuiltValueNullFieldError('User', 'lastName');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('User', 'email');
    }
    if (phoneNumber == null) {
      throw new BuiltValueNullFieldError('User', 'phoneNumber');
    }
    if (mobileNumber == null) {
      throw new BuiltValueNullFieldError('User', 'mobileNumber');
    }
    if (address == null) {
      throw new BuiltValueNullFieldError('User', 'address');
    }
    if (role == null) {
      throw new BuiltValueNullFieldError('User', 'role');
    }
    if (dietaryRestrictions == null) {
      throw new BuiltValueNullFieldError('User', 'dietaryRestrictions');
    }
    if (emergencyContactName == null) {
      throw new BuiltValueNullFieldError('User', 'emergencyContactName');
    }
    if (emergencyContactNumber == null) {
      throw new BuiltValueNullFieldError('User', 'emergencyContactNumber');
    }
    if (emergencyContactRelation == null) {
      throw new BuiltValueNullFieldError('User', 'emergencyContactRelation');
    }
    if (membershipStart == null) {
      throw new BuiltValueNullFieldError('User', 'membershipStart');
    }
    if (membershipRenewal == null) {
      throw new BuiltValueNullFieldError('User', 'membershipRenewal');
    }
    if (disabilities == null) {
      throw new BuiltValueNullFieldError('User', 'disabilities');
    }
    if (forms == null) {
      throw new BuiltValueNullFieldError('User', 'forms');
    }
    if (position == null) {
      throw new BuiltValueNullFieldError('User', 'position');
    }
    if (services == null) {
      throw new BuiltValueNullFieldError('User', 'services');
    }
  }

  @override
  User rebuild(void updates(UserBuilder b)) => (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => new UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        loginUID == other.loginUID &&
        docUID == other.docUID &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        email == other.email &&
        phoneNumber == other.phoneNumber &&
        mobileNumber == other.mobileNumber &&
        address == other.address &&
        role == other.role &&
        dietaryRestrictions == other.dietaryRestrictions &&
        emergencyContactName == other.emergencyContactName &&
        emergencyContactNumber == other.emergencyContactNumber &&
        emergencyContactRelation == other.emergencyContactRelation &&
        membershipStart == other.membershipStart &&
        membershipRenewal == other.membershipRenewal &&
        disabilities == other.disabilities &&
        forms == other.forms &&
        medicalIssues == other.medicalIssues &&
        position == other.position &&
        homeDeliver == other.homeDeliver &&
        medRelease == other.medRelease &&
        waiverRelease == other.waiverRelease &&
        intakeForm == other.intakeForm &&
        services == other.services;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    $jc(
                                                                        $jc(
                                                                            $jc(
                                                                                $jc(
                                                                                    $jc(
                                                                                        $jc(
                                                                                            $jc(
                                                                                                $jc(0,
                                                                                                    loginUID.hashCode),
                                                                                                docUID.hashCode),
                                                                                            firstName.hashCode),
                                                                                        lastName.hashCode),
                                                                                    email.hashCode),
                                                                                phoneNumber.hashCode),
                                                                            mobileNumber.hashCode),
                                                                        address.hashCode),
                                                                    role.hashCode),
                                                                dietaryRestrictions.hashCode),
                                                            emergencyContactName.hashCode),
                                                        emergencyContactNumber.hashCode),
                                                    emergencyContactRelation.hashCode),
                                                membershipStart.hashCode),
                                            membershipRenewal.hashCode),
                                        disabilities.hashCode),
                                    forms.hashCode),
                                medicalIssues.hashCode),
                            position.hashCode),
                        homeDeliver.hashCode),
                    medRelease.hashCode),
                waiverRelease.hashCode),
            intakeForm.hashCode),
        services.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('User')
          ..add('loginUID', loginUID)
          ..add('docUID', docUID)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('email', email)
          ..add('phoneNumber', phoneNumber)
          ..add('mobileNumber', mobileNumber)
          ..add('address', address)
          ..add('role', role)
          ..add('dietaryRestrictions', dietaryRestrictions)
          ..add('emergencyContactName', emergencyContactName)
          ..add('emergencyContactNumber', emergencyContactNumber)
          ..add('emergencyContactRelation', emergencyContactRelation)
          ..add('membershipStart', membershipStart)
          ..add('membershipRenewal', membershipRenewal)
          ..add('disabilities', disabilities)
          ..add('forms', forms)
          ..add('medicalIssues', medicalIssues)
          ..add('position', position)
          ..add('homeDeliver', homeDeliver)
          ..add('medRelease', medRelease)
          ..add('waiverRelease', waiverRelease)
          ..add('intakeForm', intakeForm)
          ..add('services', services))
        .toString();
  }
}

class UserBuilder implements Builder<User, UserBuilder> {
  _$User _$v;

  String _loginUID;
  String get loginUID => _$this._loginUID;
  set loginUID(String loginUID) => _$this._loginUID = loginUID;

  String _docUID;
  String get docUID => _$this._docUID;
  set docUID(String docUID) => _$this._docUID = docUID;

  String _firstName;
  String get firstName => _$this._firstName;
  set firstName(String firstName) => _$this._firstName = firstName;

  String _lastName;
  String get lastName => _$this._lastName;
  set lastName(String lastName) => _$this._lastName = lastName;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  String _phoneNumber;
  String get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String phoneNumber) => _$this._phoneNumber = phoneNumber;

  String _mobileNumber;
  String get mobileNumber => _$this._mobileNumber;
  set mobileNumber(String mobileNumber) => _$this._mobileNumber = mobileNumber;

  String _address;
  String get address => _$this._address;
  set address(String address) => _$this._address = address;

  String _role;
  String get role => _$this._role;
  set role(String role) => _$this._role = role;

  String _dietaryRestrictions;
  String get dietaryRestrictions => _$this._dietaryRestrictions;
  set dietaryRestrictions(String dietaryRestrictions) => _$this._dietaryRestrictions = dietaryRestrictions;

  String _emergencyContactName;
  String get emergencyContactName => _$this._emergencyContactName;
  set emergencyContactName(String emergencyContactName) => _$this._emergencyContactName = emergencyContactName;

  String _emergencyContactNumber;
  String get emergencyContactNumber => _$this._emergencyContactNumber;
  set emergencyContactNumber(String emergencyContactNumber) => _$this._emergencyContactNumber = emergencyContactNumber;

  String _emergencyContactRelation;
  String get emergencyContactRelation => _$this._emergencyContactRelation;
  set emergencyContactRelation(String emergencyContactRelation) =>
      _$this._emergencyContactRelation = emergencyContactRelation;

  DateTime _membershipStart;
  DateTime get membershipStart => _$this._membershipStart;
  set membershipStart(DateTime membershipStart) => _$this._membershipStart = membershipStart;

  DateTime _membershipRenewal;
  DateTime get membershipRenewal => _$this._membershipRenewal;
  set membershipRenewal(DateTime membershipRenewal) => _$this._membershipRenewal = membershipRenewal;

  String _disabilities;
  String get disabilities => _$this._disabilities;
  set disabilities(String disabilities) => _$this._disabilities = disabilities;

  ListBuilder<String> _forms;
  ListBuilder<String> get forms => _$this._forms ??= new ListBuilder<String>();
  set forms(ListBuilder<String> forms) => _$this._forms = forms;

  String _medicalIssues;
  String get medicalIssues => _$this._medicalIssues;
  set medicalIssues(String medicalIssues) => _$this._medicalIssues = medicalIssues;

  String _position;
  String get position => _$this._position;
  set position(String position) => _$this._position = position;

  bool _homeDeliver;
  bool get homeDeliver => _$this._homeDeliver;
  set homeDeliver(bool homeDeliver) => _$this._homeDeliver = homeDeliver;

  bool _medRelease;
  bool get medRelease => _$this._medRelease;
  set medRelease(bool medRelease) => _$this._medRelease = medRelease;

  bool _waiverRelease;
  bool get waiverRelease => _$this._waiverRelease;
  set waiverRelease(bool waiverRelease) => _$this._waiverRelease = waiverRelease;

  bool _intakeForm;
  bool get intakeForm => _$this._intakeForm;
  set intakeForm(bool intakeForm) => _$this._intakeForm = intakeForm;

  ListBuilder<String> _services;
  ListBuilder<String> get services => _$this._services ??= new ListBuilder<String>();
  set services(ListBuilder<String> services) => _$this._services = services;

  UserBuilder();

  UserBuilder get _$this {
    if (_$v != null) {
      _loginUID = _$v.loginUID;
      _docUID = _$v.docUID;
      _firstName = _$v.firstName;
      _lastName = _$v.lastName;
      _email = _$v.email;
      _phoneNumber = _$v.phoneNumber;
      _mobileNumber = _$v.mobileNumber;
      _address = _$v.address;
      _role = _$v.role;
      _dietaryRestrictions = _$v.dietaryRestrictions;
      _emergencyContactName = _$v.emergencyContactName;
      _emergencyContactNumber = _$v.emergencyContactNumber;
      _emergencyContactRelation = _$v.emergencyContactRelation;
      _membershipStart = _$v.membershipStart;
      _membershipRenewal = _$v.membershipRenewal;
      _disabilities = _$v.disabilities;
      _forms = _$v.forms?.toBuilder();
      _medicalIssues = _$v.medicalIssues;
      _position = _$v.position;
      _homeDeliver = _$v.homeDeliver;
      _medRelease = _$v.medRelease;
      _waiverRelease = _$v.waiverRelease;
      _intakeForm = _$v.intakeForm;
      _services = _$v.services?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(User other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$User;
  }

  @override
  void update(void updates(UserBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$User build() {
    _$User _$result;
    try {
      _$result = _$v ??
          new _$User._(
              loginUID: loginUID,
              docUID: docUID,
              firstName: firstName,
              lastName: lastName,
              email: email,
              phoneNumber: phoneNumber,
              mobileNumber: mobileNumber,
              address: address,
              role: role,
              dietaryRestrictions: dietaryRestrictions,
              emergencyContactName: emergencyContactName,
              emergencyContactNumber: emergencyContactNumber,
              emergencyContactRelation: emergencyContactRelation,
              membershipStart: membershipStart,
              membershipRenewal: membershipRenewal,
              disabilities: disabilities,
              forms: forms.build(),
              medicalIssues: medicalIssues,
              position: position,
              homeDeliver: homeDeliver,
              medRelease: medRelease,
              waiverRelease: waiverRelease,
              intakeForm: intakeForm,
              services: services.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'forms';
        forms.build();

        _$failedField = 'services';
        services.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError('User', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

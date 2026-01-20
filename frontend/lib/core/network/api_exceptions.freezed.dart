// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_exceptions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ApiException {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Map<String, List<String>> fieldErrors,
    )
    badRequest,
    required TResult Function(String message) unauthorized,
    required TResult Function(String message) forbidden,
    required TResult Function(String message) notFound,
    required TResult Function(String message) tooManyRequests,
    required TResult Function(String message) serverError,
    required TResult Function() noConnection,
    required TResult Function() timeout,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult? Function(String message)? unauthorized,
    TResult? Function(String message)? forbidden,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? tooManyRequests,
    TResult? Function(String message)? serverError,
    TResult? Function()? noConnection,
    TResult? Function()? timeout,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult Function(String message)? unauthorized,
    TResult Function(String message)? forbidden,
    TResult Function(String message)? notFound,
    TResult Function(String message)? tooManyRequests,
    TResult Function(String message)? serverError,
    TResult Function()? noConnection,
    TResult Function()? timeout,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException value) badRequest,
    required TResult Function(UnauthorizedException value) unauthorized,
    required TResult Function(ForbiddenException value) forbidden,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(TooManyRequestsException value) tooManyRequests,
    required TResult Function(ServerErrorException value) serverError,
    required TResult Function(NoConnectionException value) noConnection,
    required TResult Function(TimeoutException value) timeout,
    required TResult Function(CancelledException value) cancelled,
    required TResult Function(UnknownException value) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException value)? badRequest,
    TResult? Function(UnauthorizedException value)? unauthorized,
    TResult? Function(ForbiddenException value)? forbidden,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(TooManyRequestsException value)? tooManyRequests,
    TResult? Function(ServerErrorException value)? serverError,
    TResult? Function(NoConnectionException value)? noConnection,
    TResult? Function(TimeoutException value)? timeout,
    TResult? Function(CancelledException value)? cancelled,
    TResult? Function(UnknownException value)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException value)? badRequest,
    TResult Function(UnauthorizedException value)? unauthorized,
    TResult Function(ForbiddenException value)? forbidden,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(TooManyRequestsException value)? tooManyRequests,
    TResult Function(ServerErrorException value)? serverError,
    TResult Function(NoConnectionException value)? noConnection,
    TResult Function(TimeoutException value)? timeout,
    TResult Function(CancelledException value)? cancelled,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiExceptionCopyWith<$Res> {
  factory $ApiExceptionCopyWith(
    ApiException value,
    $Res Function(ApiException) then,
  ) = _$ApiExceptionCopyWithImpl<$Res, ApiException>;
}

/// @nodoc
class _$ApiExceptionCopyWithImpl<$Res, $Val extends ApiException>
    implements $ApiExceptionCopyWith<$Res> {
  _$ApiExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$BadRequestExceptionImplCopyWith<$Res> {
  factory _$$BadRequestExceptionImplCopyWith(
    _$BadRequestExceptionImpl value,
    $Res Function(_$BadRequestExceptionImpl) then,
  ) = __$$BadRequestExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, Map<String, List<String>> fieldErrors});
}

/// @nodoc
class __$$BadRequestExceptionImplCopyWithImpl<$Res>
    extends _$ApiExceptionCopyWithImpl<$Res, _$BadRequestExceptionImpl>
    implements _$$BadRequestExceptionImplCopyWith<$Res> {
  __$$BadRequestExceptionImplCopyWithImpl(
    _$BadRequestExceptionImpl _value,
    $Res Function(_$BadRequestExceptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? fieldErrors = null}) {
    return _then(
      _$BadRequestExceptionImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        null == fieldErrors
            ? _value._fieldErrors
            : fieldErrors // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<String>>,
      ),
    );
  }
}

/// @nodoc

class _$BadRequestExceptionImpl extends BadRequestException {
  const _$BadRequestExceptionImpl(
    this.message,
    final Map<String, List<String>> fieldErrors,
  ) : _fieldErrors = fieldErrors,
      super._();

  @override
  final String message;
  final Map<String, List<String>> _fieldErrors;
  @override
  Map<String, List<String>> get fieldErrors {
    if (_fieldErrors is EqualUnmodifiableMapView) return _fieldErrors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fieldErrors);
  }

  @override
  String toString() {
    return 'ApiException.badRequest(message: $message, fieldErrors: $fieldErrors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BadRequestExceptionImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(
              other._fieldErrors,
              _fieldErrors,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(_fieldErrors),
  );

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BadRequestExceptionImplCopyWith<_$BadRequestExceptionImpl> get copyWith =>
      __$$BadRequestExceptionImplCopyWithImpl<_$BadRequestExceptionImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Map<String, List<String>> fieldErrors,
    )
    badRequest,
    required TResult Function(String message) unauthorized,
    required TResult Function(String message) forbidden,
    required TResult Function(String message) notFound,
    required TResult Function(String message) tooManyRequests,
    required TResult Function(String message) serverError,
    required TResult Function() noConnection,
    required TResult Function() timeout,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return badRequest(message, fieldErrors);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult? Function(String message)? unauthorized,
    TResult? Function(String message)? forbidden,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? tooManyRequests,
    TResult? Function(String message)? serverError,
    TResult? Function()? noConnection,
    TResult? Function()? timeout,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return badRequest?.call(message, fieldErrors);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult Function(String message)? unauthorized,
    TResult Function(String message)? forbidden,
    TResult Function(String message)? notFound,
    TResult Function(String message)? tooManyRequests,
    TResult Function(String message)? serverError,
    TResult Function()? noConnection,
    TResult Function()? timeout,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (badRequest != null) {
      return badRequest(message, fieldErrors);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException value) badRequest,
    required TResult Function(UnauthorizedException value) unauthorized,
    required TResult Function(ForbiddenException value) forbidden,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(TooManyRequestsException value) tooManyRequests,
    required TResult Function(ServerErrorException value) serverError,
    required TResult Function(NoConnectionException value) noConnection,
    required TResult Function(TimeoutException value) timeout,
    required TResult Function(CancelledException value) cancelled,
    required TResult Function(UnknownException value) unknown,
  }) {
    return badRequest(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException value)? badRequest,
    TResult? Function(UnauthorizedException value)? unauthorized,
    TResult? Function(ForbiddenException value)? forbidden,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(TooManyRequestsException value)? tooManyRequests,
    TResult? Function(ServerErrorException value)? serverError,
    TResult? Function(NoConnectionException value)? noConnection,
    TResult? Function(TimeoutException value)? timeout,
    TResult? Function(CancelledException value)? cancelled,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return badRequest?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException value)? badRequest,
    TResult Function(UnauthorizedException value)? unauthorized,
    TResult Function(ForbiddenException value)? forbidden,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(TooManyRequestsException value)? tooManyRequests,
    TResult Function(ServerErrorException value)? serverError,
    TResult Function(NoConnectionException value)? noConnection,
    TResult Function(TimeoutException value)? timeout,
    TResult Function(CancelledException value)? cancelled,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (badRequest != null) {
      return badRequest(this);
    }
    return orElse();
  }
}

abstract class BadRequestException extends ApiException {
  const factory BadRequestException(
    final String message,
    final Map<String, List<String>> fieldErrors,
  ) = _$BadRequestExceptionImpl;
  const BadRequestException._() : super._();

  String get message;
  Map<String, List<String>> get fieldErrors;

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BadRequestExceptionImplCopyWith<_$BadRequestExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnauthorizedExceptionImplCopyWith<$Res> {
  factory _$$UnauthorizedExceptionImplCopyWith(
    _$UnauthorizedExceptionImpl value,
    $Res Function(_$UnauthorizedExceptionImpl) then,
  ) = __$$UnauthorizedExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UnauthorizedExceptionImplCopyWithImpl<$Res>
    extends _$ApiExceptionCopyWithImpl<$Res, _$UnauthorizedExceptionImpl>
    implements _$$UnauthorizedExceptionImplCopyWith<$Res> {
  __$$UnauthorizedExceptionImplCopyWithImpl(
    _$UnauthorizedExceptionImpl _value,
    $Res Function(_$UnauthorizedExceptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$UnauthorizedExceptionImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UnauthorizedExceptionImpl extends UnauthorizedException {
  const _$UnauthorizedExceptionImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'ApiException.unauthorized(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnauthorizedExceptionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnauthorizedExceptionImplCopyWith<_$UnauthorizedExceptionImpl>
  get copyWith =>
      __$$UnauthorizedExceptionImplCopyWithImpl<_$UnauthorizedExceptionImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Map<String, List<String>> fieldErrors,
    )
    badRequest,
    required TResult Function(String message) unauthorized,
    required TResult Function(String message) forbidden,
    required TResult Function(String message) notFound,
    required TResult Function(String message) tooManyRequests,
    required TResult Function(String message) serverError,
    required TResult Function() noConnection,
    required TResult Function() timeout,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return unauthorized(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult? Function(String message)? unauthorized,
    TResult? Function(String message)? forbidden,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? tooManyRequests,
    TResult? Function(String message)? serverError,
    TResult? Function()? noConnection,
    TResult? Function()? timeout,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return unauthorized?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult Function(String message)? unauthorized,
    TResult Function(String message)? forbidden,
    TResult Function(String message)? notFound,
    TResult Function(String message)? tooManyRequests,
    TResult Function(String message)? serverError,
    TResult Function()? noConnection,
    TResult Function()? timeout,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException value) badRequest,
    required TResult Function(UnauthorizedException value) unauthorized,
    required TResult Function(ForbiddenException value) forbidden,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(TooManyRequestsException value) tooManyRequests,
    required TResult Function(ServerErrorException value) serverError,
    required TResult Function(NoConnectionException value) noConnection,
    required TResult Function(TimeoutException value) timeout,
    required TResult Function(CancelledException value) cancelled,
    required TResult Function(UnknownException value) unknown,
  }) {
    return unauthorized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException value)? badRequest,
    TResult? Function(UnauthorizedException value)? unauthorized,
    TResult? Function(ForbiddenException value)? forbidden,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(TooManyRequestsException value)? tooManyRequests,
    TResult? Function(ServerErrorException value)? serverError,
    TResult? Function(NoConnectionException value)? noConnection,
    TResult? Function(TimeoutException value)? timeout,
    TResult? Function(CancelledException value)? cancelled,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return unauthorized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException value)? badRequest,
    TResult Function(UnauthorizedException value)? unauthorized,
    TResult Function(ForbiddenException value)? forbidden,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(TooManyRequestsException value)? tooManyRequests,
    TResult Function(ServerErrorException value)? serverError,
    TResult Function(NoConnectionException value)? noConnection,
    TResult Function(TimeoutException value)? timeout,
    TResult Function(CancelledException value)? cancelled,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized(this);
    }
    return orElse();
  }
}

abstract class UnauthorizedException extends ApiException {
  const factory UnauthorizedException(final String message) =
      _$UnauthorizedExceptionImpl;
  const UnauthorizedException._() : super._();

  String get message;

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnauthorizedExceptionImplCopyWith<_$UnauthorizedExceptionImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ForbiddenExceptionImplCopyWith<$Res> {
  factory _$$ForbiddenExceptionImplCopyWith(
    _$ForbiddenExceptionImpl value,
    $Res Function(_$ForbiddenExceptionImpl) then,
  ) = __$$ForbiddenExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ForbiddenExceptionImplCopyWithImpl<$Res>
    extends _$ApiExceptionCopyWithImpl<$Res, _$ForbiddenExceptionImpl>
    implements _$$ForbiddenExceptionImplCopyWith<$Res> {
  __$$ForbiddenExceptionImplCopyWithImpl(
    _$ForbiddenExceptionImpl _value,
    $Res Function(_$ForbiddenExceptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ForbiddenExceptionImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ForbiddenExceptionImpl extends ForbiddenException {
  const _$ForbiddenExceptionImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'ApiException.forbidden(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForbiddenExceptionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForbiddenExceptionImplCopyWith<_$ForbiddenExceptionImpl> get copyWith =>
      __$$ForbiddenExceptionImplCopyWithImpl<_$ForbiddenExceptionImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Map<String, List<String>> fieldErrors,
    )
    badRequest,
    required TResult Function(String message) unauthorized,
    required TResult Function(String message) forbidden,
    required TResult Function(String message) notFound,
    required TResult Function(String message) tooManyRequests,
    required TResult Function(String message) serverError,
    required TResult Function() noConnection,
    required TResult Function() timeout,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return forbidden(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult? Function(String message)? unauthorized,
    TResult? Function(String message)? forbidden,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? tooManyRequests,
    TResult? Function(String message)? serverError,
    TResult? Function()? noConnection,
    TResult? Function()? timeout,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return forbidden?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult Function(String message)? unauthorized,
    TResult Function(String message)? forbidden,
    TResult Function(String message)? notFound,
    TResult Function(String message)? tooManyRequests,
    TResult Function(String message)? serverError,
    TResult Function()? noConnection,
    TResult Function()? timeout,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (forbidden != null) {
      return forbidden(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException value) badRequest,
    required TResult Function(UnauthorizedException value) unauthorized,
    required TResult Function(ForbiddenException value) forbidden,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(TooManyRequestsException value) tooManyRequests,
    required TResult Function(ServerErrorException value) serverError,
    required TResult Function(NoConnectionException value) noConnection,
    required TResult Function(TimeoutException value) timeout,
    required TResult Function(CancelledException value) cancelled,
    required TResult Function(UnknownException value) unknown,
  }) {
    return forbidden(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException value)? badRequest,
    TResult? Function(UnauthorizedException value)? unauthorized,
    TResult? Function(ForbiddenException value)? forbidden,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(TooManyRequestsException value)? tooManyRequests,
    TResult? Function(ServerErrorException value)? serverError,
    TResult? Function(NoConnectionException value)? noConnection,
    TResult? Function(TimeoutException value)? timeout,
    TResult? Function(CancelledException value)? cancelled,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return forbidden?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException value)? badRequest,
    TResult Function(UnauthorizedException value)? unauthorized,
    TResult Function(ForbiddenException value)? forbidden,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(TooManyRequestsException value)? tooManyRequests,
    TResult Function(ServerErrorException value)? serverError,
    TResult Function(NoConnectionException value)? noConnection,
    TResult Function(TimeoutException value)? timeout,
    TResult Function(CancelledException value)? cancelled,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (forbidden != null) {
      return forbidden(this);
    }
    return orElse();
  }
}

abstract class ForbiddenException extends ApiException {
  const factory ForbiddenException(final String message) =
      _$ForbiddenExceptionImpl;
  const ForbiddenException._() : super._();

  String get message;

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForbiddenExceptionImplCopyWith<_$ForbiddenExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotFoundExceptionImplCopyWith<$Res> {
  factory _$$NotFoundExceptionImplCopyWith(
    _$NotFoundExceptionImpl value,
    $Res Function(_$NotFoundExceptionImpl) then,
  ) = __$$NotFoundExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$NotFoundExceptionImplCopyWithImpl<$Res>
    extends _$ApiExceptionCopyWithImpl<$Res, _$NotFoundExceptionImpl>
    implements _$$NotFoundExceptionImplCopyWith<$Res> {
  __$$NotFoundExceptionImplCopyWithImpl(
    _$NotFoundExceptionImpl _value,
    $Res Function(_$NotFoundExceptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$NotFoundExceptionImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$NotFoundExceptionImpl extends NotFoundException {
  const _$NotFoundExceptionImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'ApiException.notFound(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotFoundExceptionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotFoundExceptionImplCopyWith<_$NotFoundExceptionImpl> get copyWith =>
      __$$NotFoundExceptionImplCopyWithImpl<_$NotFoundExceptionImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Map<String, List<String>> fieldErrors,
    )
    badRequest,
    required TResult Function(String message) unauthorized,
    required TResult Function(String message) forbidden,
    required TResult Function(String message) notFound,
    required TResult Function(String message) tooManyRequests,
    required TResult Function(String message) serverError,
    required TResult Function() noConnection,
    required TResult Function() timeout,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return notFound(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult? Function(String message)? unauthorized,
    TResult? Function(String message)? forbidden,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? tooManyRequests,
    TResult? Function(String message)? serverError,
    TResult? Function()? noConnection,
    TResult? Function()? timeout,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return notFound?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult Function(String message)? unauthorized,
    TResult Function(String message)? forbidden,
    TResult Function(String message)? notFound,
    TResult Function(String message)? tooManyRequests,
    TResult Function(String message)? serverError,
    TResult Function()? noConnection,
    TResult Function()? timeout,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException value) badRequest,
    required TResult Function(UnauthorizedException value) unauthorized,
    required TResult Function(ForbiddenException value) forbidden,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(TooManyRequestsException value) tooManyRequests,
    required TResult Function(ServerErrorException value) serverError,
    required TResult Function(NoConnectionException value) noConnection,
    required TResult Function(TimeoutException value) timeout,
    required TResult Function(CancelledException value) cancelled,
    required TResult Function(UnknownException value) unknown,
  }) {
    return notFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException value)? badRequest,
    TResult? Function(UnauthorizedException value)? unauthorized,
    TResult? Function(ForbiddenException value)? forbidden,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(TooManyRequestsException value)? tooManyRequests,
    TResult? Function(ServerErrorException value)? serverError,
    TResult? Function(NoConnectionException value)? noConnection,
    TResult? Function(TimeoutException value)? timeout,
    TResult? Function(CancelledException value)? cancelled,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return notFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException value)? badRequest,
    TResult Function(UnauthorizedException value)? unauthorized,
    TResult Function(ForbiddenException value)? forbidden,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(TooManyRequestsException value)? tooManyRequests,
    TResult Function(ServerErrorException value)? serverError,
    TResult Function(NoConnectionException value)? noConnection,
    TResult Function(TimeoutException value)? timeout,
    TResult Function(CancelledException value)? cancelled,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(this);
    }
    return orElse();
  }
}

abstract class NotFoundException extends ApiException {
  const factory NotFoundException(final String message) =
      _$NotFoundExceptionImpl;
  const NotFoundException._() : super._();

  String get message;

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotFoundExceptionImplCopyWith<_$NotFoundExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TooManyRequestsExceptionImplCopyWith<$Res> {
  factory _$$TooManyRequestsExceptionImplCopyWith(
    _$TooManyRequestsExceptionImpl value,
    $Res Function(_$TooManyRequestsExceptionImpl) then,
  ) = __$$TooManyRequestsExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$TooManyRequestsExceptionImplCopyWithImpl<$Res>
    extends _$ApiExceptionCopyWithImpl<$Res, _$TooManyRequestsExceptionImpl>
    implements _$$TooManyRequestsExceptionImplCopyWith<$Res> {
  __$$TooManyRequestsExceptionImplCopyWithImpl(
    _$TooManyRequestsExceptionImpl _value,
    $Res Function(_$TooManyRequestsExceptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$TooManyRequestsExceptionImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$TooManyRequestsExceptionImpl extends TooManyRequestsException {
  const _$TooManyRequestsExceptionImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'ApiException.tooManyRequests(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TooManyRequestsExceptionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TooManyRequestsExceptionImplCopyWith<_$TooManyRequestsExceptionImpl>
  get copyWith =>
      __$$TooManyRequestsExceptionImplCopyWithImpl<
        _$TooManyRequestsExceptionImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Map<String, List<String>> fieldErrors,
    )
    badRequest,
    required TResult Function(String message) unauthorized,
    required TResult Function(String message) forbidden,
    required TResult Function(String message) notFound,
    required TResult Function(String message) tooManyRequests,
    required TResult Function(String message) serverError,
    required TResult Function() noConnection,
    required TResult Function() timeout,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return tooManyRequests(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult? Function(String message)? unauthorized,
    TResult? Function(String message)? forbidden,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? tooManyRequests,
    TResult? Function(String message)? serverError,
    TResult? Function()? noConnection,
    TResult? Function()? timeout,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return tooManyRequests?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult Function(String message)? unauthorized,
    TResult Function(String message)? forbidden,
    TResult Function(String message)? notFound,
    TResult Function(String message)? tooManyRequests,
    TResult Function(String message)? serverError,
    TResult Function()? noConnection,
    TResult Function()? timeout,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (tooManyRequests != null) {
      return tooManyRequests(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException value) badRequest,
    required TResult Function(UnauthorizedException value) unauthorized,
    required TResult Function(ForbiddenException value) forbidden,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(TooManyRequestsException value) tooManyRequests,
    required TResult Function(ServerErrorException value) serverError,
    required TResult Function(NoConnectionException value) noConnection,
    required TResult Function(TimeoutException value) timeout,
    required TResult Function(CancelledException value) cancelled,
    required TResult Function(UnknownException value) unknown,
  }) {
    return tooManyRequests(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException value)? badRequest,
    TResult? Function(UnauthorizedException value)? unauthorized,
    TResult? Function(ForbiddenException value)? forbidden,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(TooManyRequestsException value)? tooManyRequests,
    TResult? Function(ServerErrorException value)? serverError,
    TResult? Function(NoConnectionException value)? noConnection,
    TResult? Function(TimeoutException value)? timeout,
    TResult? Function(CancelledException value)? cancelled,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return tooManyRequests?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException value)? badRequest,
    TResult Function(UnauthorizedException value)? unauthorized,
    TResult Function(ForbiddenException value)? forbidden,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(TooManyRequestsException value)? tooManyRequests,
    TResult Function(ServerErrorException value)? serverError,
    TResult Function(NoConnectionException value)? noConnection,
    TResult Function(TimeoutException value)? timeout,
    TResult Function(CancelledException value)? cancelled,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (tooManyRequests != null) {
      return tooManyRequests(this);
    }
    return orElse();
  }
}

abstract class TooManyRequestsException extends ApiException {
  const factory TooManyRequestsException(final String message) =
      _$TooManyRequestsExceptionImpl;
  const TooManyRequestsException._() : super._();

  String get message;

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TooManyRequestsExceptionImplCopyWith<_$TooManyRequestsExceptionImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ServerErrorExceptionImplCopyWith<$Res> {
  factory _$$ServerErrorExceptionImplCopyWith(
    _$ServerErrorExceptionImpl value,
    $Res Function(_$ServerErrorExceptionImpl) then,
  ) = __$$ServerErrorExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ServerErrorExceptionImplCopyWithImpl<$Res>
    extends _$ApiExceptionCopyWithImpl<$Res, _$ServerErrorExceptionImpl>
    implements _$$ServerErrorExceptionImplCopyWith<$Res> {
  __$$ServerErrorExceptionImplCopyWithImpl(
    _$ServerErrorExceptionImpl _value,
    $Res Function(_$ServerErrorExceptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ServerErrorExceptionImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ServerErrorExceptionImpl extends ServerErrorException {
  const _$ServerErrorExceptionImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'ApiException.serverError(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerErrorExceptionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerErrorExceptionImplCopyWith<_$ServerErrorExceptionImpl>
  get copyWith =>
      __$$ServerErrorExceptionImplCopyWithImpl<_$ServerErrorExceptionImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Map<String, List<String>> fieldErrors,
    )
    badRequest,
    required TResult Function(String message) unauthorized,
    required TResult Function(String message) forbidden,
    required TResult Function(String message) notFound,
    required TResult Function(String message) tooManyRequests,
    required TResult Function(String message) serverError,
    required TResult Function() noConnection,
    required TResult Function() timeout,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return serverError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult? Function(String message)? unauthorized,
    TResult? Function(String message)? forbidden,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? tooManyRequests,
    TResult? Function(String message)? serverError,
    TResult? Function()? noConnection,
    TResult? Function()? timeout,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return serverError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult Function(String message)? unauthorized,
    TResult Function(String message)? forbidden,
    TResult Function(String message)? notFound,
    TResult Function(String message)? tooManyRequests,
    TResult Function(String message)? serverError,
    TResult Function()? noConnection,
    TResult Function()? timeout,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException value) badRequest,
    required TResult Function(UnauthorizedException value) unauthorized,
    required TResult Function(ForbiddenException value) forbidden,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(TooManyRequestsException value) tooManyRequests,
    required TResult Function(ServerErrorException value) serverError,
    required TResult Function(NoConnectionException value) noConnection,
    required TResult Function(TimeoutException value) timeout,
    required TResult Function(CancelledException value) cancelled,
    required TResult Function(UnknownException value) unknown,
  }) {
    return serverError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException value)? badRequest,
    TResult? Function(UnauthorizedException value)? unauthorized,
    TResult? Function(ForbiddenException value)? forbidden,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(TooManyRequestsException value)? tooManyRequests,
    TResult? Function(ServerErrorException value)? serverError,
    TResult? Function(NoConnectionException value)? noConnection,
    TResult? Function(TimeoutException value)? timeout,
    TResult? Function(CancelledException value)? cancelled,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return serverError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException value)? badRequest,
    TResult Function(UnauthorizedException value)? unauthorized,
    TResult Function(ForbiddenException value)? forbidden,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(TooManyRequestsException value)? tooManyRequests,
    TResult Function(ServerErrorException value)? serverError,
    TResult Function(NoConnectionException value)? noConnection,
    TResult Function(TimeoutException value)? timeout,
    TResult Function(CancelledException value)? cancelled,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(this);
    }
    return orElse();
  }
}

abstract class ServerErrorException extends ApiException {
  const factory ServerErrorException(final String message) =
      _$ServerErrorExceptionImpl;
  const ServerErrorException._() : super._();

  String get message;

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerErrorExceptionImplCopyWith<_$ServerErrorExceptionImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NoConnectionExceptionImplCopyWith<$Res> {
  factory _$$NoConnectionExceptionImplCopyWith(
    _$NoConnectionExceptionImpl value,
    $Res Function(_$NoConnectionExceptionImpl) then,
  ) = __$$NoConnectionExceptionImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NoConnectionExceptionImplCopyWithImpl<$Res>
    extends _$ApiExceptionCopyWithImpl<$Res, _$NoConnectionExceptionImpl>
    implements _$$NoConnectionExceptionImplCopyWith<$Res> {
  __$$NoConnectionExceptionImplCopyWithImpl(
    _$NoConnectionExceptionImpl _value,
    $Res Function(_$NoConnectionExceptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NoConnectionExceptionImpl extends NoConnectionException {
  const _$NoConnectionExceptionImpl() : super._();

  @override
  String toString() {
    return 'ApiException.noConnection()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoConnectionExceptionImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Map<String, List<String>> fieldErrors,
    )
    badRequest,
    required TResult Function(String message) unauthorized,
    required TResult Function(String message) forbidden,
    required TResult Function(String message) notFound,
    required TResult Function(String message) tooManyRequests,
    required TResult Function(String message) serverError,
    required TResult Function() noConnection,
    required TResult Function() timeout,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return noConnection();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult? Function(String message)? unauthorized,
    TResult? Function(String message)? forbidden,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? tooManyRequests,
    TResult? Function(String message)? serverError,
    TResult? Function()? noConnection,
    TResult? Function()? timeout,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return noConnection?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult Function(String message)? unauthorized,
    TResult Function(String message)? forbidden,
    TResult Function(String message)? notFound,
    TResult Function(String message)? tooManyRequests,
    TResult Function(String message)? serverError,
    TResult Function()? noConnection,
    TResult Function()? timeout,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (noConnection != null) {
      return noConnection();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException value) badRequest,
    required TResult Function(UnauthorizedException value) unauthorized,
    required TResult Function(ForbiddenException value) forbidden,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(TooManyRequestsException value) tooManyRequests,
    required TResult Function(ServerErrorException value) serverError,
    required TResult Function(NoConnectionException value) noConnection,
    required TResult Function(TimeoutException value) timeout,
    required TResult Function(CancelledException value) cancelled,
    required TResult Function(UnknownException value) unknown,
  }) {
    return noConnection(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException value)? badRequest,
    TResult? Function(UnauthorizedException value)? unauthorized,
    TResult? Function(ForbiddenException value)? forbidden,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(TooManyRequestsException value)? tooManyRequests,
    TResult? Function(ServerErrorException value)? serverError,
    TResult? Function(NoConnectionException value)? noConnection,
    TResult? Function(TimeoutException value)? timeout,
    TResult? Function(CancelledException value)? cancelled,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return noConnection?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException value)? badRequest,
    TResult Function(UnauthorizedException value)? unauthorized,
    TResult Function(ForbiddenException value)? forbidden,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(TooManyRequestsException value)? tooManyRequests,
    TResult Function(ServerErrorException value)? serverError,
    TResult Function(NoConnectionException value)? noConnection,
    TResult Function(TimeoutException value)? timeout,
    TResult Function(CancelledException value)? cancelled,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (noConnection != null) {
      return noConnection(this);
    }
    return orElse();
  }
}

abstract class NoConnectionException extends ApiException {
  const factory NoConnectionException() = _$NoConnectionExceptionImpl;
  const NoConnectionException._() : super._();
}

/// @nodoc
abstract class _$$TimeoutExceptionImplCopyWith<$Res> {
  factory _$$TimeoutExceptionImplCopyWith(
    _$TimeoutExceptionImpl value,
    $Res Function(_$TimeoutExceptionImpl) then,
  ) = __$$TimeoutExceptionImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TimeoutExceptionImplCopyWithImpl<$Res>
    extends _$ApiExceptionCopyWithImpl<$Res, _$TimeoutExceptionImpl>
    implements _$$TimeoutExceptionImplCopyWith<$Res> {
  __$$TimeoutExceptionImplCopyWithImpl(
    _$TimeoutExceptionImpl _value,
    $Res Function(_$TimeoutExceptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TimeoutExceptionImpl extends TimeoutException {
  const _$TimeoutExceptionImpl() : super._();

  @override
  String toString() {
    return 'ApiException.timeout()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TimeoutExceptionImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Map<String, List<String>> fieldErrors,
    )
    badRequest,
    required TResult Function(String message) unauthorized,
    required TResult Function(String message) forbidden,
    required TResult Function(String message) notFound,
    required TResult Function(String message) tooManyRequests,
    required TResult Function(String message) serverError,
    required TResult Function() noConnection,
    required TResult Function() timeout,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return timeout();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult? Function(String message)? unauthorized,
    TResult? Function(String message)? forbidden,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? tooManyRequests,
    TResult? Function(String message)? serverError,
    TResult? Function()? noConnection,
    TResult? Function()? timeout,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return timeout?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult Function(String message)? unauthorized,
    TResult Function(String message)? forbidden,
    TResult Function(String message)? notFound,
    TResult Function(String message)? tooManyRequests,
    TResult Function(String message)? serverError,
    TResult Function()? noConnection,
    TResult Function()? timeout,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (timeout != null) {
      return timeout();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException value) badRequest,
    required TResult Function(UnauthorizedException value) unauthorized,
    required TResult Function(ForbiddenException value) forbidden,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(TooManyRequestsException value) tooManyRequests,
    required TResult Function(ServerErrorException value) serverError,
    required TResult Function(NoConnectionException value) noConnection,
    required TResult Function(TimeoutException value) timeout,
    required TResult Function(CancelledException value) cancelled,
    required TResult Function(UnknownException value) unknown,
  }) {
    return timeout(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException value)? badRequest,
    TResult? Function(UnauthorizedException value)? unauthorized,
    TResult? Function(ForbiddenException value)? forbidden,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(TooManyRequestsException value)? tooManyRequests,
    TResult? Function(ServerErrorException value)? serverError,
    TResult? Function(NoConnectionException value)? noConnection,
    TResult? Function(TimeoutException value)? timeout,
    TResult? Function(CancelledException value)? cancelled,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return timeout?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException value)? badRequest,
    TResult Function(UnauthorizedException value)? unauthorized,
    TResult Function(ForbiddenException value)? forbidden,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(TooManyRequestsException value)? tooManyRequests,
    TResult Function(ServerErrorException value)? serverError,
    TResult Function(NoConnectionException value)? noConnection,
    TResult Function(TimeoutException value)? timeout,
    TResult Function(CancelledException value)? cancelled,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (timeout != null) {
      return timeout(this);
    }
    return orElse();
  }
}

abstract class TimeoutException extends ApiException {
  const factory TimeoutException() = _$TimeoutExceptionImpl;
  const TimeoutException._() : super._();
}

/// @nodoc
abstract class _$$CancelledExceptionImplCopyWith<$Res> {
  factory _$$CancelledExceptionImplCopyWith(
    _$CancelledExceptionImpl value,
    $Res Function(_$CancelledExceptionImpl) then,
  ) = __$$CancelledExceptionImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CancelledExceptionImplCopyWithImpl<$Res>
    extends _$ApiExceptionCopyWithImpl<$Res, _$CancelledExceptionImpl>
    implements _$$CancelledExceptionImplCopyWith<$Res> {
  __$$CancelledExceptionImplCopyWithImpl(
    _$CancelledExceptionImpl _value,
    $Res Function(_$CancelledExceptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CancelledExceptionImpl extends CancelledException {
  const _$CancelledExceptionImpl() : super._();

  @override
  String toString() {
    return 'ApiException.cancelled()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CancelledExceptionImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Map<String, List<String>> fieldErrors,
    )
    badRequest,
    required TResult Function(String message) unauthorized,
    required TResult Function(String message) forbidden,
    required TResult Function(String message) notFound,
    required TResult Function(String message) tooManyRequests,
    required TResult Function(String message) serverError,
    required TResult Function() noConnection,
    required TResult Function() timeout,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return cancelled();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult? Function(String message)? unauthorized,
    TResult? Function(String message)? forbidden,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? tooManyRequests,
    TResult? Function(String message)? serverError,
    TResult? Function()? noConnection,
    TResult? Function()? timeout,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return cancelled?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult Function(String message)? unauthorized,
    TResult Function(String message)? forbidden,
    TResult Function(String message)? notFound,
    TResult Function(String message)? tooManyRequests,
    TResult Function(String message)? serverError,
    TResult Function()? noConnection,
    TResult Function()? timeout,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException value) badRequest,
    required TResult Function(UnauthorizedException value) unauthorized,
    required TResult Function(ForbiddenException value) forbidden,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(TooManyRequestsException value) tooManyRequests,
    required TResult Function(ServerErrorException value) serverError,
    required TResult Function(NoConnectionException value) noConnection,
    required TResult Function(TimeoutException value) timeout,
    required TResult Function(CancelledException value) cancelled,
    required TResult Function(UnknownException value) unknown,
  }) {
    return cancelled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException value)? badRequest,
    TResult? Function(UnauthorizedException value)? unauthorized,
    TResult? Function(ForbiddenException value)? forbidden,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(TooManyRequestsException value)? tooManyRequests,
    TResult? Function(ServerErrorException value)? serverError,
    TResult? Function(NoConnectionException value)? noConnection,
    TResult? Function(TimeoutException value)? timeout,
    TResult? Function(CancelledException value)? cancelled,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return cancelled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException value)? badRequest,
    TResult Function(UnauthorizedException value)? unauthorized,
    TResult Function(ForbiddenException value)? forbidden,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(TooManyRequestsException value)? tooManyRequests,
    TResult Function(ServerErrorException value)? serverError,
    TResult Function(NoConnectionException value)? noConnection,
    TResult Function(TimeoutException value)? timeout,
    TResult Function(CancelledException value)? cancelled,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled(this);
    }
    return orElse();
  }
}

abstract class CancelledException extends ApiException {
  const factory CancelledException() = _$CancelledExceptionImpl;
  const CancelledException._() : super._();
}

/// @nodoc
abstract class _$$UnknownExceptionImplCopyWith<$Res> {
  factory _$$UnknownExceptionImplCopyWith(
    _$UnknownExceptionImpl value,
    $Res Function(_$UnknownExceptionImpl) then,
  ) = __$$UnknownExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UnknownExceptionImplCopyWithImpl<$Res>
    extends _$ApiExceptionCopyWithImpl<$Res, _$UnknownExceptionImpl>
    implements _$$UnknownExceptionImplCopyWith<$Res> {
  __$$UnknownExceptionImplCopyWithImpl(
    _$UnknownExceptionImpl _value,
    $Res Function(_$UnknownExceptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$UnknownExceptionImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UnknownExceptionImpl extends UnknownException {
  const _$UnknownExceptionImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'ApiException.unknown(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownExceptionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownExceptionImplCopyWith<_$UnknownExceptionImpl> get copyWith =>
      __$$UnknownExceptionImplCopyWithImpl<_$UnknownExceptionImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Map<String, List<String>> fieldErrors,
    )
    badRequest,
    required TResult Function(String message) unauthorized,
    required TResult Function(String message) forbidden,
    required TResult Function(String message) notFound,
    required TResult Function(String message) tooManyRequests,
    required TResult Function(String message) serverError,
    required TResult Function() noConnection,
    required TResult Function() timeout,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return unknown(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult? Function(String message)? unauthorized,
    TResult? Function(String message)? forbidden,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? tooManyRequests,
    TResult? Function(String message)? serverError,
    TResult? Function()? noConnection,
    TResult? Function()? timeout,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return unknown?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Map<String, List<String>> fieldErrors)?
    badRequest,
    TResult Function(String message)? unauthorized,
    TResult Function(String message)? forbidden,
    TResult Function(String message)? notFound,
    TResult Function(String message)? tooManyRequests,
    TResult Function(String message)? serverError,
    TResult Function()? noConnection,
    TResult Function()? timeout,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException value) badRequest,
    required TResult Function(UnauthorizedException value) unauthorized,
    required TResult Function(ForbiddenException value) forbidden,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(TooManyRequestsException value) tooManyRequests,
    required TResult Function(ServerErrorException value) serverError,
    required TResult Function(NoConnectionException value) noConnection,
    required TResult Function(TimeoutException value) timeout,
    required TResult Function(CancelledException value) cancelled,
    required TResult Function(UnknownException value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException value)? badRequest,
    TResult? Function(UnauthorizedException value)? unauthorized,
    TResult? Function(ForbiddenException value)? forbidden,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(TooManyRequestsException value)? tooManyRequests,
    TResult? Function(ServerErrorException value)? serverError,
    TResult? Function(NoConnectionException value)? noConnection,
    TResult? Function(TimeoutException value)? timeout,
    TResult? Function(CancelledException value)? cancelled,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException value)? badRequest,
    TResult Function(UnauthorizedException value)? unauthorized,
    TResult Function(ForbiddenException value)? forbidden,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(TooManyRequestsException value)? tooManyRequests,
    TResult Function(ServerErrorException value)? serverError,
    TResult Function(NoConnectionException value)? noConnection,
    TResult Function(TimeoutException value)? timeout,
    TResult Function(CancelledException value)? cancelled,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownException extends ApiException {
  const factory UnknownException(final String message) = _$UnknownExceptionImpl;
  const UnknownException._() : super._();

  String get message;

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnknownExceptionImplCopyWith<_$UnknownExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

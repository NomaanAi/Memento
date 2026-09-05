// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppTask {

 String get id; String? get projectId; String get title; String? get description; String? get priority; String? get status; DateTime? get dueDate; DateTime get createdAt; DateTime get updatedAt; String get userId;
/// Create a copy of AppTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppTaskCopyWith<AppTask> get copyWith => _$AppTaskCopyWithImpl<AppTask>(this as AppTask, _$identity);

  /// Serializes this AppTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppTask;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppTask&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.projectId, _this.projectId) || other.projectId == _this.projectId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.userId, _this.userId) || other.userId == _this.userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppTask;
  return Object.hash(runtimeType,_this.id,_this.projectId,_this.title,_this.description,_this.priority,_this.status,_this.dueDate,_this.createdAt,_this.updatedAt,_this.userId);
}

@override
String toString() {
  final _this = this as AppTask;
  return 'AppTask(id: ${_this.id}, projectId: ${_this.projectId}, title: ${_this.title}, description: ${_this.description}, priority: ${_this.priority}, status: ${_this.status}, dueDate: ${_this.dueDate}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, userId: ${_this.userId})';
}


}

/// @nodoc
abstract mixin class $AppTaskCopyWith<$Res>  {
  factory $AppTaskCopyWith(AppTask value, $Res Function(AppTask) _then) = _$AppTaskCopyWithImpl;
@useResult
$Res call({
 String id, String? projectId, String title, String? description, String? priority, String? status, DateTime? dueDate, DateTime createdAt, DateTime updatedAt, String userId
});




}
/// @nodoc
class _$AppTaskCopyWithImpl<$Res>
    implements $AppTaskCopyWith<$Res> {
  _$AppTaskCopyWithImpl(this._self, this._then);

  final AppTask _self;
  final $Res Function(AppTask) _then;

/// Create a copy of AppTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = freezed,Object? title = null,Object? description = freezed,Object? priority = freezed,Object? status = freezed,Object? dueDate = freezed,Object? createdAt = null,Object? updatedAt = null,Object? userId = null,}) {
  return _then(AppTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppTask].
extension AppTaskPatterns on AppTask {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppTask() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppTask value)  $default,){
final _that = this;
switch (_that) {
case _AppTask():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppTask value)?  $default,){
final _that = this;
switch (_that) {
case _AppTask() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? projectId,  String title,  String? description,  String? priority,  String? status,  DateTime? dueDate,  DateTime createdAt,  DateTime updatedAt,  String userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppTask() when $default != null:
return $default(_that.id,_that.projectId,_that.title,_that.description,_that.priority,_that.status,_that.dueDate,_that.createdAt,_that.updatedAt,_that.userId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? projectId,  String title,  String? description,  String? priority,  String? status,  DateTime? dueDate,  DateTime createdAt,  DateTime updatedAt,  String userId)  $default,) {final _that = this;
switch (_that) {
case _AppTask():
return $default(_that.id,_that.projectId,_that.title,_that.description,_that.priority,_that.status,_that.dueDate,_that.createdAt,_that.updatedAt,_that.userId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? projectId,  String title,  String? description,  String? priority,  String? status,  DateTime? dueDate,  DateTime createdAt,  DateTime updatedAt,  String userId)?  $default,) {final _that = this;
switch (_that) {
case _AppTask() when $default != null:
return $default(_that.id,_that.projectId,_that.title,_that.description,_that.priority,_that.status,_that.dueDate,_that.createdAt,_that.updatedAt,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppTask implements AppTask {
  const _AppTask({required this.id, this.projectId, required this.title, this.description, this.priority, this.status, this.dueDate, required this.createdAt, required this.updatedAt, required this.userId});
  factory _AppTask.fromJson(Map<String, dynamic> json) => _$AppTaskFromJson(json);

@override final  String id;
@override final  String? projectId;
@override final  String title;
@override final  String? description;
@override final  String? priority;
@override final  String? status;
@override final  DateTime? dueDate;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String userId;

/// Create a copy of AppTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppTaskCopyWith<_AppTask> get copyWith => __$AppTaskCopyWithImpl<_AppTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppTaskToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppTask&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,projectId,title,description,priority,status,dueDate,createdAt,updatedAt,userId);
}

@override
String toString() {
    return 'AppTask(id: $id, projectId: $projectId, title: $title, description: $description, priority: $priority, status: $status, dueDate: $dueDate, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$AppTaskCopyWith<$Res> implements $AppTaskCopyWith<$Res> {
  factory _$AppTaskCopyWith(_AppTask value, $Res Function(_AppTask) _then) = __$AppTaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String? projectId, String title, String? description, String? priority, String? status, DateTime? dueDate, DateTime createdAt, DateTime updatedAt, String userId
});




}
/// @nodoc
class __$AppTaskCopyWithImpl<$Res>
    implements _$AppTaskCopyWith<$Res> {
  __$AppTaskCopyWithImpl(this._self, this._then);

  final _AppTask _self;
  final $Res Function(_AppTask) _then;

/// Create a copy of AppTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = freezed,Object? title = null,Object? description = freezed,Object? priority = freezed,Object? status = freezed,Object? dueDate = freezed,Object? createdAt = null,Object? updatedAt = null,Object? userId = null,}) {
  return _then(_AppTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

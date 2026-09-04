export 'unsupported_connection.dart'
    if (dart.library.ffi) 'native_connection.dart'
    if (dart.library.js_interop) 'web_connection.dart';

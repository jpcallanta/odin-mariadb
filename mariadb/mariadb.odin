// Package mariadb provides Odin bindings for libmariadb (MariaDB Connector/C).
// This is the main package file with the foreign library import.
package mariadb

// The call_conv for STDCALL: on Windows this is stdcall, on other platforms it's c.
when ODIN_OS == .Windows {
	call_conv :: "stdcall"
} else {
	call_conv :: "c"
}

// Foreign library import: libmariadb on Linux, libmariadb.dll on Windows
when ODIN_OS != .Windows {
	foreign import lib "system:mariadb"
} else {
	foreign import lib "mariadb.lib"
}

// High-level convenience: basic connection and query helpers will be
// added as wrapper procs in this file if desired, but the core binding
// exposes the raw C ABI in the individual files below (connect.odin,
// query.odin, stmt.odin, etc.).

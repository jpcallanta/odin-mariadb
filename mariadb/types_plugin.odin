package mariadb

import "core:c"

// ─── Plugin Type Constants ──────────────────────────────────────────────────

MYSQL_CLIENT_PLUGIN_RESERVED :: 0
MYSQL_CLIENT_PLUGIN_RESERVED2 :: 1
MYSQL_CLIENT_AUTHENTICATION_PLUGIN :: 2
MYSQL_CLIENT_MAX_PLUGINS :: 3

MARIADB_CLIENT_REMOTEIO_PLUGIN :: 100
MARIADB_CLIENT_PVIO_PLUGIN :: 101
MARIADB_CLIENT_TRACE_PLUGIN :: 102
MARIADB_CLIENT_CONNECTION_PLUGIN :: 103
MARIADB_CLIENT_COMPRESSION_PLUGIN :: 104

MYSQL_CLIENT_AUTHENTICATION_PLUGIN_INTERFACE_VERSION :: 0x0101
MARIADB_CLIENT_REMOTEIO_PLUGIN_INTERFACE_VERSION :: 0x0100
MARIADB_CLIENT_PVIO_PLUGIN_INTERFACE_VERSION :: 0x0100
MARIADB_CLIENT_TRACE_PLUGIN_INTERFACE_VERSION :: 0x0100
MARIADB_CLIENT_CONNECTION_PLUGIN_INTERFACE_VERSION :: 0x0100
MARIADB_CLIENT_COMPRESSION_PLUGIN_INTERFACE_VERSION :: 0x0100

PLUGINDIR :: "lib/plugin"

// ─── st_mysql_client_plugin (generic plugin header) ─────────────────────────

st_mysql_client_plugin :: struct {
	type:               c.int,
	interface_version:  c.uint,
	name:               cstring,
	author:             cstring,
	desc:               cstring,
	version:            [3]c.uint,
	license:            cstring,
	mysql_api:          rawptr,
	init:               proc(cstring, c.size_t, c.int, c.va_list) -> c.int,
	deinit:             proc() -> c.int,
	options:            proc(cstring, rawptr) -> c.int,
}

// ─── MARIADB_CONNECTION_PLUGIN ──────────────────────────────────────────────

MARIADB_CONNECTION_PLUGIN :: struct {
	// plugin header (MYSQL_CLIENT_PLUGIN_HEADER)
	type:               c.int,
	interface_version:  c.uint,
	name:               cstring,
	author:             cstring,
	desc:               cstring,
	version:            [3]c.uint,
	license:            cstring,
	mysql_api:          rawptr,
	init:               proc(cstring, c.size_t, c.int, c.va_list) -> c.int,
	deinit:             proc() -> c.int,
	options:            proc(cstring, rawptr) -> c.int,
	// connection plugin specific
	connect:            proc(^MYSQL, cstring, cstring, cstring, cstring, c.uint, cstring, c.ulong) -> ^MYSQL,
	close:              proc(^MYSQL),
	set_optionsv:       proc(^MYSQL, c.uint) -> c.int,
	set_connection:     proc(^MYSQL, enum_server_command, cstring, c.size_t, my_bool, rawptr) -> c.int,
	reconnect:          proc(^MYSQL) -> my_bool,
	reset:              proc(^MYSQL) -> c.int,
}

// ─── MARIADB_PVIO_PLUGIN ──────────────────────────────────────────────────

MARIADB_PVIO_PLUGIN :: struct {
	type:               c.int,
	interface_version:  c.uint,
	name:               cstring,
	author:             cstring,
	desc:               cstring,
	version:            [3]c.uint,
	license:            cstring,
	mysql_api:          rawptr,
	init:               proc(cstring, c.size_t, c.int, c.va_list) -> c.int,
	deinit:             proc() -> c.int,
	options:            proc(cstring, rawptr) -> c.int,
	methods:            ^st_ma_pvio_methods,
}

// ─── st_mysql_client_plugin_AUTHENTICATION ──────────────────────────────────

st_mysql_client_plugin_AUTHENTICATION :: struct {
	type:               c.int,
	interface_version:  c.uint,
	name:               cstring,
	author:             cstring,
	desc:               cstring,
	version:            [3]c.uint,
	license:            cstring,
	mysql_api:          rawptr,
	init:               proc(cstring, c.size_t, c.int, c.va_list) -> c.int,
	deinit:             proc() -> c.int,
	options:            proc(cstring, rawptr) -> c.int,
	authenticate_user:  proc(^MYSQL_PLUGIN_VIO, ^MYSQL) -> c.int,
	hash_password_bin:  proc(^MYSQL, ^u8, ^c.size_t) -> c.int,
}

// ─── st_mysql_client_plugin_TRACE ───────────────────────────────────────────

st_mysql_client_plugin_TRACE :: struct {
	type:               c.int,
	interface_version:  c.uint,
	name:               cstring,
	author:             cstring,
	desc:               cstring,
	version:            [3]c.uint,
	license:            cstring,
	mysql_api:          rawptr,
	init:               proc(cstring, c.size_t, c.int, c.va_list) -> c.int,
	deinit:             proc() -> c.int,
	options:            proc(cstring, rawptr) -> c.int,
}

// ─── MARIADB_COMPRESSION_PLUGIN ─────────────────────────────────────────────

MARIADB_COMPRESSION_PLUGIN :: struct {
	type:               c.int,
	interface_version:  c.uint,
	name:               cstring,
	author:             cstring,
	desc:               cstring,
	version:            [3]c.uint,
	license:            cstring,
	mysql_api:          rawptr,
	init:               proc(cstring, c.size_t, c.int, c.va_list) -> c.int,
	deinit:             proc() -> c.int,
	options:            proc(cstring, rawptr) -> c.int,
	init_ctx:           proc(c.int) -> rawptr,
	free_ctx:           proc(rawptr),
	compress:           proc(rawptr, rawptr, ^c.size_t, rawptr, c.size_t) -> my_bool,
	decompress:         proc(rawptr, rawptr, ^c.size_t, rawptr, ^c.size_t) -> my_bool,
}

// ─── MYSQL_PLUGIN_VIO (authentication plugin VIO) ───────────────────────────

MYSQL_PLUGIN_VIO :: struct {
	read_packet:  proc(^MYSQL_PLUGIN_VIO, ^^u8) -> c.int,
	write_packet: proc(^MYSQL_PLUGIN_VIO, ^u8, c.int) -> c.int,
	info:         proc(^MYSQL_PLUGIN_VIO, ^MYSQL_PLUGIN_VIO_INFO),
}

// ─── MYSQL_PLUGIN_VIO_INFO ──────────────────────────────────────────────────

MYSQL_PLUGIN_VIO_INFO :: struct {
	protocol: c.int,
	socket:   c.int,
}

// ─── Authentication dialog callback ─────────────────────────────────────────

mysql_authentication_dialog_ask_t :: #type proc(^MYSQL, c.int, cstring, cstring, c.int) -> cstring

// ─── st_ma_pvio_methods ─────────────────────────────────────────────────────

st_ma_pvio_methods :: struct {
	set_timeout:      proc(^MARIADB_PVIO, enum_pvio_timeout, c.int) -> my_bool,
	get_timeout:      proc(^MARIADB_PVIO, enum_pvio_timeout) -> c.int,
	read:             proc(^MARIADB_PVIO, ^u8, c.size_t) -> c.ssize_t,
	async_read:       proc(^MARIADB_PVIO, ^u8, c.size_t) -> c.ssize_t,
	write:            proc(^MARIADB_PVIO, ^u8, c.size_t) -> c.ssize_t,
	async_write:      proc(^MARIADB_PVIO, ^u8, c.size_t) -> c.ssize_t,
	wait_io_or_timeout: proc(^MARIADB_PVIO, my_bool, c.int) -> c.int,
	blocking:         proc(^MARIADB_PVIO, my_bool, ^my_bool) -> c.int,
	connect:          proc(^MARIADB_PVIO, ^MA_PVIO_CINFO) -> my_bool,
	close:            proc(^MARIADB_PVIO) -> my_bool,
	fast_send:        proc(^MARIADB_PVIO) -> c.int,
	keepalive:        proc(^MARIADB_PVIO) -> c.int,
	get_handle:       proc(^MARIADB_PVIO, rawptr) -> my_bool,
	is_blocking:      proc(^MARIADB_PVIO) -> my_bool,
	is_alive:         proc(^MARIADB_PVIO) -> my_bool,
	has_data:         proc(^MARIADB_PVIO, ^c.ssize_t) -> my_bool,
	shutdown:         proc(^MARIADB_PVIO) -> c.int,
}

// ─── MA_PVIO_CINFO ──────────────────────────────────────────────────────────

MA_PVIO_CINFO :: struct {
	host:       cstring,
	unix_socket: cstring,
	port:       c.int,
	type:       enum_pvio_type,
	mysql:      ^MYSQL,
}

// ─── PVIO_CALLBACK ──────────────────────────────────────────────────────────

PVIO_CALLBACK :: struct {
	callback: proc(^MYSQL, ^u8, c.size_t),
	next:     ^PVIO_CALLBACK,
}

// ─── MARIADB_TLS ────────────────────────────────────────────────────────────

MARIADB_TLS :: struct {
	data:      rawptr,
	pvio:      ^MARIADB_PVIO,
	ssl:       rawptr,
	cert_info: MARIADB_X509_INFO,
}

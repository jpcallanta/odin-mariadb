package mariadb

import "core:c"

when ODIN_OS != .Windows {
	foreign import lib "system:mariadb"
} else {
	foreign import lib "mariadb.lib"
}

// ─── Network / Internal Protocol Functions ──────────────────────────────────

foreign lib {
	ma_net_init         :: proc(net: ^NET, pvio: ^MARIADB_PVIO) -> c.int ---
	ma_net_end          :: proc(net: ^NET) ---
	ma_net_clear        :: proc(net: ^NET) ---
	ma_net_flush        :: proc(net: ^NET) -> c.int ---
	ma_net_write        :: proc(net: ^NET, packet: ^u8, len: c.size_t) -> c.int ---
	ma_net_write_buff   :: proc(net: ^NET, packet: cstring, len: c.size_t) -> c.int ---
	ma_net_write_command :: proc(net: ^NET, command: u8, packet: cstring, len: c.size_t, disable_flush: my_bool) -> c.int ---
	ma_net_real_write   :: proc(net: ^NET, packet: cstring, len: c.size_t) -> c.int ---
	ma_net_read         :: proc(net: ^NET) -> c.ulong ---
}

// ─── PVIO Functions ─────────────────────────────────────────────────────────

foreign lib {
	ma_pvio_init           :: proc(cinfo: ^MA_PVIO_CINFO) -> ^MARIADB_PVIO ---
	ma_pvio_close          :: proc(pvio: ^MARIADB_PVIO) ---
	ma_pvio_cache_read     :: proc(pvio: ^MARIADB_PVIO, buffer: ^u8, length: c.size_t) -> c.ssize_t ---
	ma_pvio_read           :: proc(pvio: ^MARIADB_PVIO, buffer: ^u8, length: c.size_t) -> c.ssize_t ---
	ma_pvio_write          :: proc(pvio: ^MARIADB_PVIO, buffer: ^u8, length: c.size_t) -> c.ssize_t ---
	ma_pvio_get_timeout    :: proc(pvio: ^MARIADB_PVIO, type: enum_pvio_timeout) -> c.int ---
	ma_pvio_set_timeout    :: proc(pvio: ^MARIADB_PVIO, type: enum_pvio_timeout, timeout: c.int) -> my_bool ---
	ma_pvio_fast_send      :: proc(pvio: ^MARIADB_PVIO) -> c.int ---
	ma_pvio_keepalive      :: proc(pvio: ^MARIADB_PVIO) -> c.int ---
	ma_pvio_get_socket     :: proc(pvio: ^MARIADB_PVIO) -> my_socket ---
	ma_pvio_is_blocking    :: proc(pvio: ^MARIADB_PVIO) -> my_bool ---
	ma_pvio_blocking       :: proc(pvio: ^MARIADB_PVIO, block: my_bool, previous_mode: ^my_bool) -> my_bool ---
	ma_pvio_wait_io_or_timeout :: proc(pvio: ^MARIADB_PVIO, is_read: my_bool, timeout: c.int) -> c.int ---
	ma_pvio_connect        :: proc(pvio: ^MARIADB_PVIO, cinfo: ^MA_PVIO_CINFO) -> my_bool ---
	ma_pvio_is_alive       :: proc(pvio: ^MARIADB_PVIO) -> my_bool ---
	ma_pvio_get_handle     :: proc(pvio: ^MARIADB_PVIO, handle: rawptr) -> my_bool ---
	ma_pvio_has_data       :: proc(pvio: ^MARIADB_PVIO, length: ^c.ssize_t) -> my_bool ---
}

// ─── Simple Command ─────────────────────────────────────────────────────────

foreign lib {
	ma_simple_command :: proc(
		mysql: ^MYSQL,
		command: enum_server_command,
		arg: cstring,
		length: c.size_t,
		skipp_check: my_bool,
		opt_arg: rawptr,
	) -> c.int ---
}

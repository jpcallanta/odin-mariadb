package mariadb

import "core:c"

when ODIN_OS != .Windows {
	foreign import lib "system:mariadb"
} else {
	foreign import lib "mariadb.lib"
}

// ─── String Escaping & Encoding ─────────────────────────────────────────────

foreign lib {
	mysql_escape_string       :: proc(to: cstring, from: cstring, from_length: c.ulong) -> c.ulong ---
	mysql_real_escape_string  :: proc(mysql: ^MYSQL, to: cstring, from: cstring, length: c.ulong) -> c.ulong ---
	mysql_hex_string          :: proc(to: cstring, from: cstring, len: c.ulong) -> c.ulong ---
}

// ─── Parameters ─────────────────────────────────────────────────────────────

foreign lib {
	mysql_get_parameters :: proc() -> ^MYSQL_PARAMETERS ---
}

// ─── Net / Internal ─────────────────────────────────────────────────────────

foreign lib {
	mysql_net_read_packet  :: proc(mysql: ^MYSQL) -> c.ulong ---
	mysql_net_field_length :: proc(packet: ^^u8) -> c.ulong ---
	mysql_embedded         :: proc() -> my_bool ---
	ma_net_safe_read       :: proc(mysql: ^MYSQL) -> c.ulong ---
	net_field_length       :: proc(packet: ^^u8) -> c.ulong ---
}

// ─── Charset Utilities ──────────────────────────────────────────────────────

foreign lib {
	mariadb_get_charset_by_name :: proc(csname: cstring) -> ^MARIADB_CHARSET_INFO ---
	mariadb_get_charset_by_nr   :: proc(csnr: c.uint) -> ^MARIADB_CHARSET_INFO ---
	mariadb_convert_string      :: proc(from: cstring, from_len: ^c.size_t, from_cs: ^MARIADB_CHARSET_INFO, to: cstring, to_len: ^c.size_t, to_cs: ^MARIADB_CHARSET_INFO, errorcode: ^c.int) -> c.size_t ---
}

// ─── Password Hashing ───────────────────────────────────────────────────────

foreign lib {
	ma_scramble_323           :: proc(to: cstring, message: cstring, password: cstring) -> cstring ---
	ma_scramble_41            :: proc(buffer: ^u8, scramble: cstring, password: cstring) ---
	ma_hash_password          :: proc(result: ^c.ulong, password: cstring, len: c.size_t) ---
	ma_make_scrambled_password :: proc(to: cstring, password: cstring) ---
}

// ─── Config File Loading ────────────────────────────────────────────────────

foreign lib {
	mariadb_load_defaults :: proc(conf_file: cstring, groups: ^cstring, argc: ^c.int, argv: ^^cstring) ---
}

// ─── Error Setting (variadic in C, exposed without variadic) ────────────────

foreign lib {
	my_set_error :: proc(mysql: ^MYSQL, error_nr: c.uint, sqlstate: cstring, format: cstring) ---
}

// ─── Thread (internal) ──────────────────────────────────────────────────────

foreign lib {
	ma_thread_init :: proc() -> my_bool ---
	ma_thread_end  :: proc() ---
}

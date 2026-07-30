package mariadb

import "core:c"

when ODIN_OS != .Windows {
	foreign import lib "system:mariadb"
} else {
	foreign import lib "mariadb.lib"
}

// ─── Plugin Loading ─────────────────────────────────────────────────────────
// Note: mysql_load_plugin is variadic in C. The _v variant takes a va_list.
// For variadic calls, use the _v variant with c.va_list.

foreign lib {
	mysql_load_plugin_v        :: proc(mysql: ^MYSQL, name: cstring, type: c.int, argc: c.int, args: c.va_list) -> ^st_mysql_client_plugin ---
	mysql_client_find_plugin   :: proc(mysql: ^MYSQL, name: cstring, type: c.int) -> ^st_mysql_client_plugin ---
	mysql_client_register_plugin :: proc(mysql: ^MYSQL, plugin: ^st_mysql_client_plugin) -> ^st_mysql_client_plugin ---
}

// ─── Plugin extern ──────────────────────────────────────────────────────────

foreign lib {
	mysql_client_builtins: [^]^st_mysql_client_plugin
}

// ─── TLS Functions ──────────────────────────────────────────────────────────

foreign lib {
	ma_tls_start                    :: proc(errmsg: cstring, errmsg_len: c.size_t) -> c.int ---
	ma_tls_end                      :: proc() ---
	ma_tls_init                     :: proc(mysql: ^MYSQL) -> rawptr ---
	ma_tls_connect                  :: proc(ctls: ^MARIADB_TLS) -> my_bool ---
	ma_tls_read                     :: proc(ctls: ^MARIADB_TLS, buffer: ^u8, length: c.size_t) -> c.ssize_t ---
	ma_tls_write                    :: proc(ctls: ^MARIADB_TLS, buffer: ^u8, length: c.size_t) -> c.ssize_t ---
	ma_tls_close                    :: proc(ctls: ^MARIADB_TLS) -> my_bool ---
	ma_tls_verify_server_cert       :: proc(ctls: ^MARIADB_TLS, flags: c.uint) -> c.int ---
	ma_tls_get_cipher               :: proc(ssl: ^MARIADB_TLS) -> cstring ---
	ma_tls_get_finger_print         :: proc(ctls: ^MARIADB_TLS, hash_type: c.uint, fp: cstring, fp_len: c.uint) -> c.uint ---
	ma_tls_get_protocol_version     :: proc(ctls: ^MARIADB_TLS) -> c.int ---
	ma_tls_set_connection           :: proc(mysql: ^MYSQL) ---
	ma_tls_get_peer_cert_info       :: proc(ctls: ^MARIADB_TLS, size: c.uint) -> c.uint ---
	ma_pvio_tls_init                :: proc(mysql: ^MYSQL) -> ^MARIADB_TLS ---
	ma_pvio_tls_connect             :: proc(ctls: ^MARIADB_TLS) -> my_bool ---
	ma_pvio_tls_read                :: proc(ctls: ^MARIADB_TLS, buffer: ^u8, length: c.size_t) -> c.ssize_t ---
	ma_pvio_tls_write               :: proc(ctls: ^MARIADB_TLS, buffer: ^u8, length: c.size_t) -> c.ssize_t ---
	ma_pvio_tls_close               :: proc(ctls: ^MARIADB_TLS) -> my_bool ---
	ma_pvio_tls_verify_server_cert  :: proc(ctls: ^MARIADB_TLS, flags: c.uint) -> c.int ---
	ma_pvio_tls_cipher              :: proc(ctls: ^MARIADB_TLS) -> cstring ---
	ma_pvio_tls_check_fp            :: proc(ctls: ^MARIADB_TLS, fp: cstring, fp_list: cstring) -> my_bool ---
	ma_pvio_start_ssl               :: proc(pvio: ^MARIADB_PVIO) -> my_bool ---
	ma_pvio_tls_set_connection      :: proc(mysql: ^MYSQL) ---
	ma_pvio_tls_end                 :: proc() ---
	ma_pvio_tls_get_peer_cert_info  :: proc(ctls: ^MARIADB_TLS, size: c.uint) -> c.uint ---
	ma_pvio_tls_get_protocol_version :: proc(ctls: ^MARIADB_TLS) -> cstring ---
	ma_pvio_tls_get_protocol_version_id :: proc(ctls: ^MARIADB_TLS) -> c.int ---
	ma_is_ip_address                :: proc(s: cstring) -> my_bool ---
}

// TLS library version string
foreign lib {
	tls_library_version: [TLS_VERSION_LENGTH]u8
}

// ─── Charset / Ctype variables and functions ────────────────────────────────

foreign lib {
	ma_default_charset_info:     ^MARIADB_CHARSET_INFO
	ma_charset_bin:              ^MARIADB_CHARSET_INFO
	ma_charset_latin1:           ^MARIADB_CHARSET_INFO
	ma_charset_utf8_general_ci:  ^MARIADB_CHARSET_INFO
	ma_charset_utf16le_general_ci: ^MARIADB_CHARSET_INFO
}

foreign lib {
	find_compiled_charset       :: proc(cs_number: c.uint) -> ^MARIADB_CHARSET_INFO ---
	find_compiled_charset_by_name :: proc(name: cstring) -> ^MARIADB_CHARSET_INFO ---
	mysql_cset_escape_quotes    :: proc(cset: ^MARIADB_CHARSET_INFO, newstr: cstring, escapestr: cstring, escapestr_len: c.size_t) -> c.size_t ---
	mysql_cset_escape_slashes   :: proc(cset: ^MARIADB_CHARSET_INFO, newstr: cstring, escapestr: cstring, escapestr_len: c.size_t) -> c.size_t ---
	madb_get_os_character_set   :: proc() -> cstring ---
}

// Error message arrays
foreign lib {
	client_errors:        [^]cstring
	mariadb_client_errors: [^]cstring
}

foreign lib {
	init_client_errs :: proc() ---
}

// PS fetch functions table
foreign lib {
	mysql_ps_fetch_functions: [256]MYSQL_PS_CONVERSION
}

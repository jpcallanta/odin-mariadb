package mariadb

import "core:c"

when ODIN_OS != .Windows {
	foreign import lib "system:mariadb"
} else {
	foreign import lib "mariadb.lib"
}

// ─── Global Variables (declared in libmariadb) ──────────────────────────────

foreign lib {
	mysql_port:                c.uint
	mysql_unix_port:           cstring
	mariadb_deinitialize_ssl:  c.uint
}

// ─── Initialization & Threading ─────────────────────────────────────────────

foreign lib {
	mysql_server_init :: proc(argc: c.int, argv: ^cstring, groups: ^cstring) -> c.int ---
	mysql_server_end  :: proc() ---
	mysql_thread_init :: proc() -> my_bool ---
	mysql_thread_end  :: proc() ---
	mysql_thread_safe :: proc() -> c.uint ---
}

// ─── Connection Management ──────────────────────────────────────────────────

foreign lib {
	mysql_init         :: proc(mysql: ^MYSQL) -> ^MYSQL ---
	mysql_real_connect :: proc(mysql: ^MYSQL, host: cstring, user: cstring, passwd: cstring, db: cstring, port: c.uint, unix_socket: cstring, clientflag: c.ulong) -> ^MYSQL ---
	mysql_close        :: proc(sock: ^MYSQL) ---
	mysql_select_db    :: proc(mysql: ^MYSQL, db: cstring) -> c.int ---
	mysql_change_user  :: proc(mysql: ^MYSQL, user: cstring, passwd: cstring, db: cstring) -> my_bool ---
	mysql_ping         :: proc(mysql: ^MYSQL) -> c.int ---
}

// ─── Connection Options ─────────────────────────────────────────────────────
// Note: mysql_optionsv and mysql_get_optionv are variadic in C but exposed
// here without the variadic suffix since Odin foreign blocks do not support
// #c_vararg. Use the fixed-arg variants (mysql_options, mysql_get_option)
// for most use cases.

foreign lib {
	mysql_options     :: proc(mysql: ^MYSQL, option: mysql_option, arg: rawptr) -> c.int ---
	mysql_options4    :: proc(mysql: ^MYSQL, option: mysql_option, arg1: rawptr, arg2: rawptr) -> c.int ---
	mysql_get_option  :: proc(mysql: ^MYSQL, option: mysql_option, arg: rawptr) -> c.int ---
}

// ─── SSL ────────────────────────────────────────────────────────────────────

foreign lib {
	mysql_ssl_set         :: proc(mysql: ^MYSQL, key: cstring, cert: cstring, ca: cstring, capath: cstring, cipher: cstring) -> c.int ---
	mysql_get_ssl_cipher  :: proc(mysql: ^MYSQL) -> cstring ---
}

// ─── Auto-commit & Transactions ─────────────────────────────────────────────

foreign lib {
	mysql_autocommit :: proc(mysql: ^MYSQL, mode: my_bool) -> my_bool ---
	mysql_commit     :: proc(mysql: ^MYSQL) -> my_bool ---
	mysql_rollback   :: proc(mysql: ^MYSQL) -> my_bool ---
}

// ─── Server Options ─────────────────────────────────────────────────────────

foreign lib {
	mysql_set_server_option :: proc(mysql: ^MYSQL, option: enum_mysql_set_option) -> c.int ---
}

// ─── Connection Status ──────────────────────────────────────────────────────

foreign lib {
	mariadb_connection :: proc(mysql: ^MYSQL) -> my_bool ---
	mariadb_reconnect  :: proc(mysql: ^MYSQL) -> my_bool ---
}

// ─── Connection Information ─────────────────────────────────────────────────

foreign lib {
	mysql_get_host_info      :: proc(mysql: ^MYSQL) -> cstring ---
	mysql_get_server_info    :: proc(mysql: ^MYSQL) -> cstring ---
	mysql_get_server_name    :: proc(mysql: ^MYSQL) -> cstring ---
	mysql_get_server_version :: proc(mysql: ^MYSQL) -> c.ulong ---
	mysql_get_proto_info     :: proc(mysql: ^MYSQL) -> c.uint ---
	mysql_get_client_info    :: proc() -> cstring ---
	mysql_get_client_version :: proc() -> c.ulong ---
	mysql_get_socket         :: proc(mysql: ^MYSQL) -> my_socket ---
	mysql_get_timeout_value    :: proc(mysql: ^MYSQL) -> c.uint ---
	mysql_get_timeout_value_ms :: proc(mysql: ^MYSQL) -> c.uint ---
	mysql_character_set_name      :: proc(mysql: ^MYSQL) -> cstring ---
	mysql_get_character_set_info  :: proc(mysql: ^MYSQL, cs: ^MY_CHARSET_INFO) ---
	mysql_set_character_set       :: proc(mysql: ^MYSQL, csname: cstring) -> c.int ---
}

// ─── Error / Info ───────────────────────────────────────────────────────────

foreign lib {
	mysql_errno         :: proc(mysql: ^MYSQL) -> c.uint ---
	mysql_error         :: proc(mysql: ^MYSQL) -> cstring ---
	mysql_sqlstate      :: proc(mysql: ^MYSQL) -> cstring ---
	mysql_warning_count :: proc(mysql: ^MYSQL) -> c.uint ---
	mysql_info          :: proc(mysql: ^MYSQL) -> cstring ---
	mysql_thread_id     :: proc(mysql: ^MYSQL) -> c.ulong ---
	mariadb_get_info    :: proc(mysql: ^MYSQL, value: mariadb_value, arg: rawptr) -> my_bool ---
	mariadb_get_infov   :: proc(mysql: ^MYSQL, value: mariadb_value, arg: rawptr) -> my_bool ---
}

// ─── Server Administration ──────────────────────────────────────────────────

foreign lib {
	mysql_shutdown         :: proc(mysql: ^MYSQL, shutdown_level: mysql_enum_shutdown_level) -> c.int ---
	mysql_dump_debug_info  :: proc(mysql: ^MYSQL) -> c.int ---
	mysql_refresh          :: proc(mysql: ^MYSQL, refresh_options: c.uint) -> c.int ---
	mysql_kill             :: proc(mysql: ^MYSQL, pid: c.ulong) -> c.int ---
	mysql_stat             :: proc(mysql: ^MYSQL) -> cstring ---
	mysql_debug            :: proc(debug: cstring) ---
	mysql_reset_connection :: proc(mysql: ^MYSQL) -> c.int ---
}

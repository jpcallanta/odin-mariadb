package mariadb

import "core:c"

when ODIN_OS != .Windows {
	foreign import lib "system:mariadb"
} else {
	foreign import lib "mariadb.lib"
}

// ─── Async API (Non-blocking) ───────────────────────────────────────────────
// Each function pair (xxx_start / xxx_cont) is used for non-blocking operation.
// The _start function initiates an operation and returns a wait status.
// The _cont function continues the operation; call it repeatedly until the
// operation completes.

foreign lib {
	mysql_close_start       :: proc(sock: ^MYSQL) -> c.int ---
	mysql_close_cont        :: proc(sock: ^MYSQL, status: c.int) -> c.int ---
	mysql_commit_start      :: proc(ret: ^my_bool, mysql: ^MYSQL) -> c.int ---
	mysql_commit_cont       :: proc(ret: ^my_bool, mysql: ^MYSQL, status: c.int) -> c.int ---
	mysql_rollback_start    :: proc(ret: ^my_bool, mysql: ^MYSQL) -> c.int ---
	mysql_rollback_cont     :: proc(ret: ^my_bool, mysql: ^MYSQL, status: c.int) -> c.int ---
	mysql_autocommit_start  :: proc(ret: ^my_bool, mysql: ^MYSQL, auto_mode: my_bool) -> c.int ---
	mysql_autocommit_cont   :: proc(ret: ^my_bool, mysql: ^MYSQL, status: c.int) -> c.int ---
	mysql_next_result_start :: proc(ret: ^c.int, mysql: ^MYSQL) -> c.int ---
	mysql_next_result_cont  :: proc(ret: ^c.int, mysql: ^MYSQL, status: c.int) -> c.int ---
	mysql_select_db_start   :: proc(ret: ^c.int, mysql: ^MYSQL, db: cstring) -> c.int ---
	mysql_select_db_cont    :: proc(ret: ^c.int, mysql: ^MYSQL, ready_status: c.int) -> c.int ---

	mysql_real_connect_start :: proc(
		ret: ^^MYSQL,
		mysql: ^MYSQL,
		host: cstring,
		user: cstring,
		passwd: cstring,
		db: cstring,
		port: c.uint,
		unix_socket: cstring,
		clientflag: c.ulong,
	) -> c.int ---
	mysql_real_connect_cont :: proc(ret: ^^MYSQL, mysql: ^MYSQL, status: c.int) -> c.int ---

	mysql_query_start :: proc(ret: ^c.int, mysql: ^MYSQL, q: cstring) -> c.int ---
	mysql_query_cont  :: proc(ret: ^c.int, mysql: ^MYSQL, status: c.int) -> c.int ---

	mysql_send_query_start :: proc(ret: ^c.int, mysql: ^MYSQL, q: cstring, length: c.ulong) -> c.int ---
	mysql_send_query_cont  :: proc(ret: ^c.int, mysql: ^MYSQL, status: c.int) -> c.int ---

	mysql_real_query_start :: proc(ret: ^c.int, mysql: ^MYSQL, q: cstring, length: c.ulong) -> c.int ---
	mysql_real_query_cont  :: proc(ret: ^c.int, mysql: ^MYSQL, status: c.int) -> c.int ---

	mysql_store_result_start :: proc(ret: ^^MYSQL_RES, mysql: ^MYSQL) -> c.int ---
	mysql_store_result_cont  :: proc(ret: ^^MYSQL_RES, mysql: ^MYSQL, status: c.int) -> c.int ---

	mysql_free_result_start :: proc(result: ^MYSQL_RES) -> c.int ---
	mysql_free_result_cont  :: proc(result: ^MYSQL_RES, status: c.int) -> c.int ---

	mysql_fetch_row_start :: proc(ret: ^MYSQL_ROW, result: ^MYSQL_RES) -> c.int ---
	mysql_fetch_row_cont  :: proc(ret: ^MYSQL_ROW, result: ^MYSQL_RES, status: c.int) -> c.int ---

	mysql_read_query_result_start :: proc(ret: ^my_bool, mysql: ^MYSQL) -> c.int ---
	mysql_read_query_result_cont  :: proc(ret: ^my_bool, mysql: ^MYSQL, status: c.int) -> c.int ---

	mysql_change_user_start :: proc(ret: ^my_bool, mysql: ^MYSQL, user: cstring, passwd: cstring, db: cstring) -> c.int ---
	mysql_change_user_cont  :: proc(ret: ^my_bool, mysql: ^MYSQL, status: c.int) -> c.int ---

	mysql_set_character_set_start :: proc(ret: ^c.int, mysql: ^MYSQL, csname: cstring) -> c.int ---
	mysql_set_character_set_cont  :: proc(ret: ^c.int, mysql: ^MYSQL, status: c.int) -> c.int ---

	mysql_shutdown_start :: proc(ret: ^c.int, mysql: ^MYSQL, shutdown_level: mysql_enum_shutdown_level) -> c.int ---
	mysql_shutdown_cont  :: proc(ret: ^c.int, mysql: ^MYSQL, status: c.int) -> c.int ---

	mysql_refresh_start :: proc(ret: ^c.int, mysql: ^MYSQL, refresh_options: c.uint) -> c.int ---
	mysql_refresh_cont  :: proc(ret: ^c.int, mysql: ^MYSQL, status: c.int) -> c.int ---

	mysql_kill_start :: proc(ret: ^c.int, mysql: ^MYSQL, pid: c.ulong) -> c.int ---
	mysql_kill_cont  :: proc(ret: ^c.int, mysql: ^MYSQL, status: c.int) -> c.int ---

	mysql_set_server_option_start :: proc(ret: ^c.int, mysql: ^MYSQL, option: enum_mysql_set_option) -> c.int ---
	mysql_set_server_option_cont  :: proc(ret: ^c.int, mysql: ^MYSQL, status: c.int) -> c.int ---

	mysql_ping_start :: proc(ret: ^c.int, mysql: ^MYSQL) -> c.int ---
	mysql_ping_cont  :: proc(ret: ^c.int, mysql: ^MYSQL, status: c.int) -> c.int ---

	mysql_stat_start :: proc(ret: ^cstring, mysql: ^MYSQL) -> c.int ---
	mysql_stat_cont  :: proc(ret: ^cstring, mysql: ^MYSQL, status: c.int) -> c.int ---

	mysql_dump_debug_info_start :: proc(ret: ^c.int, mysql: ^MYSQL) -> c.int ---
	mysql_dump_debug_info_cont  :: proc(ret: ^c.int, mysql: ^MYSQL, ready_status: c.int) -> c.int ---

	mysql_list_fields_start :: proc(ret: ^^MYSQL_RES, mysql: ^MYSQL, table: cstring, wild: cstring) -> c.int ---
	mysql_list_fields_cont  :: proc(ret: ^^MYSQL_RES, mysql: ^MYSQL, ready_status: c.int) -> c.int ---

	mysql_reset_connection_start :: proc(ret: ^c.int, mysql: ^MYSQL) -> c.int ---
	mysql_reset_connection_cont  :: proc(ret: ^c.int, mysql: ^MYSQL, status: c.int) -> c.int ---

	// ─── Async Prepared Statement ──────────────────────────────────────────

	mysql_stmt_prepare_start :: proc(ret: ^c.int, stmt: ^MYSQL_STMT, query: cstring, length: c.ulong) -> c.int ---
	mysql_stmt_prepare_cont  :: proc(ret: ^c.int, stmt: ^MYSQL_STMT, status: c.int) -> c.int ---
	mysql_stmt_execute_start :: proc(ret: ^c.int, stmt: ^MYSQL_STMT) -> c.int ---
	mysql_stmt_execute_cont  :: proc(ret: ^c.int, stmt: ^MYSQL_STMT, status: c.int) -> c.int ---
	mysql_stmt_fetch_start   :: proc(ret: ^c.int, stmt: ^MYSQL_STMT) -> c.int ---
	mysql_stmt_fetch_cont    :: proc(ret: ^c.int, stmt: ^MYSQL_STMT, status: c.int) -> c.int ---
	mysql_stmt_store_result_start :: proc(ret: ^c.int, stmt: ^MYSQL_STMT) -> c.int ---
	mysql_stmt_store_result_cont  :: proc(ret: ^c.int, stmt: ^MYSQL_STMT, status: c.int) -> c.int ---
	mysql_stmt_close_start   :: proc(ret: ^my_bool, stmt: ^MYSQL_STMT) -> c.int ---
	mysql_stmt_close_cont    :: proc(ret: ^my_bool, stmt: ^MYSQL_STMT, status: c.int) -> c.int ---
	mysql_stmt_reset_start   :: proc(ret: ^my_bool, stmt: ^MYSQL_STMT) -> c.int ---
	mysql_stmt_reset_cont    :: proc(ret: ^my_bool, stmt: ^MYSQL_STMT, status: c.int) -> c.int ---
	mysql_stmt_free_result_start :: proc(ret: ^my_bool, stmt: ^MYSQL_STMT) -> c.int ---
	mysql_stmt_free_result_cont  :: proc(ret: ^my_bool, stmt: ^MYSQL_STMT, status: c.int) -> c.int ---
	mysql_stmt_send_long_data_start :: proc(ret: ^my_bool, stmt: ^MYSQL_STMT, param_number: c.uint, data: cstring, len: c.ulong) -> c.int ---
	mysql_stmt_send_long_data_cont  :: proc(ret: ^my_bool, stmt: ^MYSQL_STMT, status: c.int) -> c.int ---
	mysql_stmt_next_result_start :: proc(ret: ^c.int, stmt: ^MYSQL_STMT) -> c.int ---
	mysql_stmt_next_result_cont  :: proc(ret: ^c.int, stmt: ^MYSQL_STMT, status: c.int) -> c.int ---

	// ─── Warning Count (async) ──────────────────────────────────────────────
	mysql_stmt_warning_count :: proc(stmt: ^MYSQL_STMT) -> c.int ---
}

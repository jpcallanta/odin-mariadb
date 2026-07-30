package mariadb

import "core:c"

when ODIN_OS != .Windows {
	foreign import lib "system:mariadb"
} else {
	foreign import lib "mariadb.lib"
}

// ─── Prepared Statement Functions ───────────────────────────────────────────

foreign lib {
	mysql_stmt_init           :: proc(mysql: ^MYSQL) -> ^MYSQL_STMT ---
	mysql_stmt_prepare        :: proc(stmt: ^MYSQL_STMT, query: cstring, length: c.ulong) -> c.int ---
	mysql_stmt_execute        :: proc(stmt: ^MYSQL_STMT) -> c.int ---
	mysql_stmt_fetch          :: proc(stmt: ^MYSQL_STMT) -> c.int ---
	mysql_stmt_fetch_column   :: proc(stmt: ^MYSQL_STMT, bind_arg: ^MYSQL_BIND, column: c.uint, offset: c.ulong) -> c.int ---
	mysql_stmt_store_result   :: proc(stmt: ^MYSQL_STMT) -> c.int ---
	mysql_stmt_param_count    :: proc(stmt: ^MYSQL_STMT) -> c.ulong ---
	mysql_stmt_attr_set       :: proc(stmt: ^MYSQL_STMT, attr_type: enum_stmt_attr_type, attr: rawptr) -> my_bool ---
	mysql_stmt_attr_get       :: proc(stmt: ^MYSQL_STMT, attr_type: enum_stmt_attr_type, attr: rawptr) -> my_bool ---
	mysql_stmt_bind_param     :: proc(stmt: ^MYSQL_STMT, bnd: ^MYSQL_BIND) -> my_bool ---
	mysql_stmt_bind_result    :: proc(stmt: ^MYSQL_STMT, bnd: ^MYSQL_BIND) -> my_bool ---
	mysql_stmt_close          :: proc(stmt: ^MYSQL_STMT) -> my_bool ---
	mysql_stmt_reset          :: proc(stmt: ^MYSQL_STMT) -> my_bool ---
	mysql_stmt_free_result    :: proc(stmt: ^MYSQL_STMT) -> my_bool ---
	mysql_stmt_send_long_data :: proc(stmt: ^MYSQL_STMT, param_number: c.uint, data: cstring, length: c.ulong) -> my_bool ---
	mysql_stmt_result_metadata :: proc(stmt: ^MYSQL_STMT) -> ^MYSQL_RES ---
	mysql_stmt_param_metadata :: proc(stmt: ^MYSQL_STMT) -> ^MYSQL_RES ---
	mysql_stmt_errno          :: proc(stmt: ^MYSQL_STMT) -> c.uint ---
	mysql_stmt_error          :: proc(stmt: ^MYSQL_STMT) -> cstring ---
	mysql_stmt_sqlstate       :: proc(stmt: ^MYSQL_STMT) -> cstring ---
	mysql_stmt_row_seek       :: proc(stmt: ^MYSQL_STMT, offset: MYSQL_ROW_OFFSET) -> MYSQL_ROW_OFFSET ---
	mysql_stmt_row_tell       :: proc(stmt: ^MYSQL_STMT) -> MYSQL_ROW_OFFSET ---
	mysql_stmt_data_seek      :: proc(stmt: ^MYSQL_STMT, offset: c.ulonglong) ---
	mysql_stmt_num_rows       :: proc(stmt: ^MYSQL_STMT) -> c.ulonglong ---
	mysql_stmt_affected_rows  :: proc(stmt: ^MYSQL_STMT) -> c.ulonglong ---
	mysql_stmt_insert_id      :: proc(stmt: ^MYSQL_STMT) -> c.ulonglong ---
	mysql_stmt_field_count    :: proc(stmt: ^MYSQL_STMT) -> c.uint ---
	mysql_stmt_next_result    :: proc(stmt: ^MYSQL_STMT) -> c.int ---
	mysql_stmt_more_results   :: proc(stmt: ^MYSQL_STMT) -> my_bool ---
	mariadb_stmt_execute_direct :: proc(stmt: ^MYSQL_STMT, stmt_str: cstring, length: c.size_t) -> c.int ---
	mariadb_stmt_fetch_fields :: proc(stmt: ^MYSQL_STMT) -> ^MYSQL_FIELD ---
}

// ─── Internal helpers ───────────────────────────────────────────────────────

foreign lib {
	mysql_init_ps_subsystem :: proc() ---
}

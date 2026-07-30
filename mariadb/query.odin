package mariadb

import "core:c"

when ODIN_OS != .Windows {
	foreign import lib "system:mariadb"
} else {
	foreign import lib "mariadb.lib"
}

// ─── Query Execution ────────────────────────────────────────────────────────

foreign lib {
	mysql_query          :: proc(mysql: ^MYSQL, q: cstring) -> c.int ---
	mysql_real_query     :: proc(mysql: ^MYSQL, q: cstring, length: c.ulong) -> c.int ---
	mysql_send_query     :: proc(mysql: ^MYSQL, q: cstring, length: c.ulong) -> c.int ---
	mysql_read_query_result :: proc(mysql: ^MYSQL) -> my_bool ---
}

// ─── Result Set ─────────────────────────────────────────────────────────────

foreign lib {
	mysql_store_result   :: proc(mysql: ^MYSQL) -> ^MYSQL_RES ---
	mysql_use_result     :: proc(mysql: ^MYSQL) -> ^MYSQL_RES ---
	mysql_free_result    :: proc(result: ^MYSQL_RES) ---
	mysql_num_rows       :: proc(res: ^MYSQL_RES) -> c.ulonglong ---
	mysql_num_fields     :: proc(res: ^MYSQL_RES) -> c.uint ---
	mysql_field_count    :: proc(mysql: ^MYSQL) -> c.uint ---
	mysql_affected_rows  :: proc(mysql: ^MYSQL) -> c.ulonglong ---
	mysql_insert_id      :: proc(mysql: ^MYSQL) -> c.ulonglong ---
}

// ─── Row Navigation ─────────────────────────────────────────────────────────

foreign lib {
	mysql_fetch_row      :: proc(result: ^MYSQL_RES) -> MYSQL_ROW ---
	mysql_fetch_lengths  :: proc(result: ^MYSQL_RES) -> [^]c.ulong ---
	mysql_data_seek      :: proc(result: ^MYSQL_RES, offset: c.ulonglong) ---
	mysql_row_seek       :: proc(result: ^MYSQL_RES, offset: MYSQL_ROW_OFFSET) -> MYSQL_ROW_OFFSET ---
	mysql_row_tell       :: proc(result: ^MYSQL_RES) -> ^MYSQL_ROWS ---
	mysql_field_seek     :: proc(result: ^MYSQL_RES, offset: MYSQL_FIELD_OFFSET) -> MYSQL_FIELD_OFFSET ---
	mysql_field_tell     :: proc(result: ^MYSQL_RES) -> c.uint ---
	mysql_eof            :: proc(res: ^MYSQL_RES) -> my_bool ---
}

// ─── Field Metadata ─────────────────────────────────────────────────────────

foreign lib {
	mysql_fetch_field       :: proc(result: ^MYSQL_RES) -> ^MYSQL_FIELD ---
	mysql_fetch_fields      :: proc(res: ^MYSQL_RES) -> ^MYSQL_FIELD ---
	mysql_fetch_field_direct :: proc(res: ^MYSQL_RES, fieldnr: c.uint) -> ^MYSQL_FIELD ---
	mariadb_field_attr      :: proc(attr: ^MARIADB_CONST_STRING, field: ^MYSQL_FIELD, type: mariadb_field_attr_t) -> c.int ---
}

// ─── Database/Table Listing ─────────────────────────────────────────────────

foreign lib {
	mysql_list_dbs       :: proc(mysql: ^MYSQL, wild: cstring) -> ^MYSQL_RES ---
	mysql_list_tables    :: proc(mysql: ^MYSQL, wild: cstring) -> ^MYSQL_RES ---
	mysql_list_fields    :: proc(mysql: ^MYSQL, table: cstring, wild: cstring) -> ^MYSQL_RES ---
	mysql_list_processes :: proc(mysql: ^MYSQL) -> ^MYSQL_RES ---
}

// ─── Multi-Result Sets ──────────────────────────────────────────────────────

foreign lib {
	mysql_more_results :: proc(mysql: ^MYSQL) -> my_bool ---
	mysql_next_result  :: proc(mysql: ^MYSQL) -> c.int ---
}

// ─── Local Infile Support ───────────────────────────────────────────────────

foreign lib {
	mysql_set_local_infile_handler :: proc(
		mysql: ^MYSQL,
		local_infile_init:  proc "stdcall" (^^rawptr, cstring, rawptr) -> c.int,
		local_infile_read:  proc "stdcall" (rawptr, cstring, c.uint) -> c.int,
		local_infile_end:   proc "stdcall" (rawptr),
		local_infile_error: proc "stdcall" (rawptr, cstring, c.uint) -> c.int,
		userdata: rawptr,
	) ---
	mysql_set_local_infile_default :: proc(mysql: ^MYSQL) ---
}

// ─── Session Tracking ───────────────────────────────────────────────────────

foreign lib {
	mysql_session_track_get_first :: proc(mysql: ^MYSQL, type: enum_session_state_type, data: ^cstring, length: ^c.size_t) -> c.int ---
	mysql_session_track_get_next  :: proc(mysql: ^MYSQL, type: enum_session_state_type, data: ^cstring, length: ^c.size_t) -> c.int ---
}

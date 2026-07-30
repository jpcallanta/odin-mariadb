package mariadb

import "core:c"

// ─── Prepared Statement Constants ───────────────────────────────────────────

MYSQL_NO_DATA :: 100
MYSQL_DATA_TRUNCATED :: 101
MYSQL_DEFAULT_PREFETCH_ROWS :: c.ulong(1)
MADB_BIND_DUMMY :: 1
STMT_ID_LENGTH :: 4

MYSQL_PS_SKIP_RESULT_W_LEN :: -1
MYSQL_PS_SKIP_RESULT_STR :: -2

// BULK flags
STMT_BULK_FLAG_CLIENT_SEND_TYPES :: 128
STMT_BULK_FLAG_SEND_UNIT_RESULTS :: 64

// ─── enum_stmt_attr_type ────────────────────────────────────────────────────

enum_stmt_attr_type :: enum c.int {
	STMT_ATTR_UPDATE_MAX_LENGTH,
	STMT_ATTR_CURSOR_TYPE,
	STMT_ATTR_PREFETCH_ROWS,
	// MariaDB only
	STMT_ATTR_PREBIND_PARAMS  = 200,
	STMT_ATTR_ARRAY_SIZE,
	STMT_ATTR_ROW_SIZE,
	STMT_ATTR_STATE,
	STMT_ATTR_CB_USER_DATA,
	STMT_ATTR_CB_PARAM,
	STMT_ATTR_CB_RESULT,
	STMT_ATTR_SQL_STATEMENT,
}

// ─── enum_cursor_type ───────────────────────────────────────────────────────

enum_cursor_type :: enum c.int {
	CURSOR_TYPE_NO_CURSOR   = 0,
	CURSOR_TYPE_READ_ONLY   = 1,
	CURSOR_TYPE_FOR_UPDATE  = 2,
	CURSOR_TYPE_SCROLLABLE  = 4,
}

// ─── enum_indicator_type ────────────────────────────────────────────────────

enum_indicator_type :: enum c.int {
	STMT_INDICATOR_NTS       = -1,
	STMT_INDICATOR_NONE      = 0,
	STMT_INDICATOR_NULL      = 1,
	STMT_INDICATOR_DEFAULT   = 2,
	STMT_INDICATOR_IGNORE    = 3,
	STMT_INDICATOR_IGNORE_ROW = 4,
}

// ─── enum_mysqlnd_stmt_state ────────────────────────────────────────────────

enum_mysqlnd_stmt_state :: enum c.int {
	MYSQL_STMT_INITTED,
	MYSQL_STMT_PREPARED,
	MYSQL_STMT_EXECUTED,
	MYSQL_STMT_WAITING_USE_OR_STORE,
	MYSQL_STMT_USE_OR_STORE_CALLED,
	MYSQL_STMT_USER_FETCHING,
	MYSQL_STMT_FETCH_DONE,
}

// ─── MYSQL_BIND ─────────────────────────────────────────────────────────────

MYSQL_BIND :: struct {
	length:              ^c.ulong,
	is_null:             ^my_bool,
	buffer:              rawptr,
	error:               ^my_bool,
	u:                   struct #raw_union {
		row_ptr:   ^u8,
		indicator: cstring,
	},
	store_param_func:    proc "stdcall" (^NET, ^MYSQL_BIND),
	fetch_result:        proc "stdcall" (^MYSQL_BIND, ^MYSQL_FIELD, ^^u8),
	skip_result:         proc "stdcall" (^MYSQL_BIND, ^MYSQL_FIELD, ^^u8),
	buffer_length:       c.ulong,
	offset:              c.ulong,
	length_value:        c.ulong,
	flags:               c.uint,
	pack_length:         c.uint,
	buffer_type:         enum_field_types,
	error_value:         my_bool,
	is_unsigned:         my_bool,
	long_data_used:      my_bool,
	is_null_value:       my_bool,
	extension:           rawptr,
}

// ─── mysql_upsert_status ────────────────────────────────────────────────────

mysql_upsert_status :: struct {
	warning_count:  c.uint,
	server_status:  c.uint,
	affected_rows:  c.ulonglong,
	last_insert_id: c.ulonglong,
}

// ─── MYSQL_CMD_BUFFER ───────────────────────────────────────────────────────

MYSQL_CMD_BUFFER :: struct {
	buffer: [^]u8,
	length: c.size_t,
}

// ─── mysql_error_info ───────────────────────────────────────────────────────

mysql_error_info :: struct {
	error_no: c.uint,
	error:    [MYSQL_ERRMSG_SIZE + 1]u8,
	sqlstate: [SQLSTATE_LENGTH + 1]u8,
}

// ─── MYSQL_STMT (prepared statement handle) ─────────────────────────────────

MYSQL_STMT :: struct {
	mem_root:              MA_MEM_ROOT,
	mysql:                 ^MYSQL,
	stmt_id:               c.ulong,
	flags:                 c.ulong,
	state:                 enum_mysqlnd_stmt_state,
	fields:                ^MYSQL_FIELD,
	field_count:           c.uint,
	param_count:           c.uint,
	send_types_to_server:  u8,
	params:                ^MYSQL_BIND,
	bind:                  ^MYSQL_BIND,
	result:                MYSQL_DATA,
	result_cursor:         ^MYSQL_ROWS,
	bind_result_done:      my_bool,
	bind_param_done:       my_bool,
	upsert_status:         mysql_upsert_status,
	last_errno:            c.uint,
	last_error:            [MYSQL_ERRMSG_SIZE + 1]u8,
	sqlstate:              [SQLSTATE_LENGTH + 1]u8,
	update_max_length:     my_bool,
	prefetch_rows:         c.ulong,
	list:                  LIST,
	cursor_exists:         my_bool,
	extension:             rawptr,
	fetch_row_func:        proc "stdcall" (^MYSQL_STMT, ^^u8) -> c.int,
	execute_count:         c.uint,
	default_rset_handler:  proc "stdcall" (^MYSQL_STMT) -> ^MYSQL_RES,
	request_buffer:        ^u8,
	array_size:            c.uint,
	row_size:              c.size_t,
	prebind_params:        c.uint,
	user_data:             rawptr,
	result_callback:       proc "stdcall" (rawptr, c.uint, ^^u8),
	param_callback:        proc "stdcall" (rawptr, ^MYSQL_BIND, c.uint) -> my_bool,
	request_length:        c.size_t,
	sql:                   MARIADB_CONST_STRING,
}

// ─── MYSQL_PS_CONVERSION ────────────────────────────────────────────────────

MYSQL_PS_CONVERSION :: struct {
	func:    proc "stdcall" (^MYSQL_BIND, ^MYSQL_FIELD, ^^u8),
	pack_len: c.int,
	max_len: c.ulong,
}

// ─── Callback type aliases ──────────────────────────────────────────────────

mysql_stmt_fetch_row_func :: #type proc "stdcall" (^MYSQL_STMT, ^^u8) -> c.int
ps_result_callback :: #type proc "stdcall" (rawptr, c.uint, ^^u8)
ps_param_callback :: #type proc "stdcall" (rawptr, ^MYSQL_BIND, c.uint) -> my_bool
mysql_stmt_use_or_store_func :: #type proc "stdcall" (^MYSQL_STMT) -> ^MYSQL_RES
ps_field_fetch_func :: #type proc "stdcall" (^MYSQL_BIND, ^MYSQL_FIELD, ^^u8)

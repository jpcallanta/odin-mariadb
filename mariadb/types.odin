package mariadb

import "core:c"

// ─── Core Type Aliases ──────────────────────────────────────────────────────

my_bool :: c.char
my_ulonglong :: c.ulonglong
my_socket :: c.int
my_uint :: c.uint

// ─── MARIADB_CONST_STRING ───────────────────────────────────────────────────

MARIADB_CONST_STRING :: struct {
	str:    cstring,
	length: c.size_t,
}

// ─── MARIADB_CONST_DATA ─────────────────────────────────────────────────────

MARIADB_CONST_DATA :: struct {
	data:   [^]u8,
	length: c.size_t,
}

// ─── MA_USED_MEM ────────────────────────────────────────────────────────────

MA_USED_MEM :: struct {
	next: ^MA_USED_MEM,
	left: c.size_t,
	size: c.size_t,
}

// ─── MA_MEM_ROOT ────────────────────────────────────────────────────────────

MA_MEM_ROOT :: struct {
	free:             ^MA_USED_MEM,
	used:             ^MA_USED_MEM,
	pre_alloc:        ^MA_USED_MEM,
	min_malloc:       c.size_t,
	block_size:       c.size_t,
	block_num:        c.uint,
	first_block_usage: c.uint,
	error_handler:    proc(),
}

// ─── LIST ───────────────────────────────────────────────────────────────────

LIST :: struct {
	prev: ^LIST,
	next: ^LIST,
	data: rawptr,
}

// ─── MYSQL_TIME ─────────────────────────────────────────────────────────────

MYSQL_TIME :: struct {
	year:        c.uint,
	month:       c.uint,
	day:         c.uint,
	hour:        c.uint,
	minute:      c.uint,
	second:      c.uint,
	second_part: c.ulong,
	neg:         my_bool,
	time_type:   enum_mysql_timestamp_type,
}

// ─── MYSQL_FIELD ────────────────────────────────────────────────────────────

MYSQL_FIELD :: struct {
	name:             cstring,
	org_name:         cstring,
	table:            cstring,
	org_table:        cstring,
	db:               cstring,
	catalog:          cstring,
	def:              cstring,
	length:           c.ulong,
	max_length:       c.ulong,
	name_length:      c.uint,
	org_name_length:  c.uint,
	table_length:     c.uint,
	org_table_length: c.uint,
	db_length:        c.uint,
	catalog_length:   c.uint,
	def_length:       c.uint,
	flags:            c.uint,
	decimals:         c.uint,
	charsetnr:        c.uint,
	type:             enum_field_types,
	extension:        rawptr,
}

// ─── MYSQL_ROW / MYSQL_FIELD_OFFSET ─────────────────────────────────────────

MYSQL_ROW :: [^]cstring
MYSQL_FIELD_OFFSET :: c.uint

// ─── MYSQL_ROWS ─────────────────────────────────────────────────────────────

MYSQL_ROWS :: struct {
	next:   ^MYSQL_ROWS,
	data:   MYSQL_ROW,
	length: c.ulong,
}

MYSQL_ROW_OFFSET :: ^MYSQL_ROWS

// ─── MYSQL_DATA ─────────────────────────────────────────────────────────────

MYSQL_DATA :: struct {
	data:          ^MYSQL_ROWS,
	embedded_info: rawptr,
	alloc:         MA_MEM_ROOT,
	rows:          c.ulonglong,
	fields:        c.uint,
	extension:     rawptr,
}

// ─── NET (communication) ────────────────────────────────────────────────────

MARIADB_PVIO :: struct {}

NET :: struct {
	pvio:               ^MARIADB_PVIO,
	buff:               [^]u8,
	buff_end:           [^]u8,
	write_pos:          [^]u8,
	read_pos:           [^]u8,
	fd:                 my_socket,
	remain_in_buf:      c.ulong,
	length:             c.ulong,
	buf_length:         c.ulong,
	where_b:            c.ulong,
	max_packet:         c.ulong,
	max_packet_size:    c.ulong,
	pkt_nr:             c.uint,
	compress_pkt_nr:    c.uint,
	write_timeout:      c.uint,
	read_timeout:       c.uint,
	retry_count:        c.uint,
	fcntl:              c.int,
	return_status:      ^c.uint,
	reading_or_writing: u8,
	save_char:          u8,
	unused_1:           u8,
	tls_verify_status:  u8,
	compress:           my_bool,
	unused_2:           my_bool,
	unused_3:           cstring,
	last_errno:         c.uint,
	error:              u8,
	unused_5:           my_bool,
	unused_6:           my_bool,
	last_error:         [MYSQL_ERRMSG_SIZE]u8,
	sqlstate:           [SQLSTATE_LENGTH + 1]u8,
	extension:          ^st_mariadb_net_extension,
}

// ─── MYSQL_OPTIONS ──────────────────────────────────────────────────────────

MYSQL_OPTIONS :: struct {
	connect_timeout:  c.uint,
	read_timeout:     c.uint,
	write_timeout:    c.uint,
	port:             c.uint,
	protocol:         c.uint,
	client_flag:      c.ulong,
	host:             cstring,
	user:             cstring,
	password:         cstring,
	unix_socket:      cstring,
	db:               cstring,
	init_command:     rawptr, // struct st_dynamic_array *
	my_cnf_file:      cstring,
	my_cnf_group:     cstring,
	charset_dir:      cstring,
	charset_name:     cstring,
	ssl_key:          cstring,
	ssl_cert:         cstring,
	ssl_ca:           cstring,
	ssl_capath:       cstring,
	ssl_cipher:       cstring,
	shared_memory_base_name: cstring,
	max_allowed_packet:      c.ulong,
	use_ssl:          my_bool,
	compress:         my_bool,
	named_pipe:       my_bool,
	reconnect:        my_bool,
	unused_1:         my_bool,
	unused_2:         my_bool,
	unused_3:         my_bool,
	methods_to_use:   mysql_option,
	bind_address:     cstring,
	secure_auth:      my_bool,
	report_data_truncation: my_bool,
	local_infile_init:  proc(^^rawptr, cstring, rawptr) -> c.int,
	local_infile_read:  proc(rawptr, cstring, c.uint) -> c.int,
	local_infile_end:   proc(rawptr),
	local_infile_error: proc(rawptr, cstring, c.uint) -> c.int,
	local_infile_userdata: rawptr,
	extension:        ^st_mysql_options_extension,
}

// ─── MYSQL (main connection handle) ─────────────────────────────────────────

MYSQL :: struct {
	net:                 NET,
	unused_0:            rawptr,
	host:                cstring,
	user:                cstring,
	passwd:              cstring,
	unix_socket:         cstring,
	server_version:      cstring,
	host_info:           cstring,
	info:                cstring,
	db:                  cstring,
	charset:             ^MARIADB_CHARSET_INFO,
	fields:              ^MYSQL_FIELD,
	field_alloc:         MA_MEM_ROOT,
	affected_rows:       c.ulonglong,
	insert_id:           c.ulonglong,
	extra_info:          c.ulonglong,
	thread_id:           c.ulong,
	packet_length:       c.ulong,
	port:                c.uint,
	client_flag:         c.ulong,
	server_capabilities: c.ulong,
	protocol_version:    c.uint,
	field_count:         c.uint,
	server_status:       c.uint,
	server_language:     c.uint,
	warning_count:       c.uint,
	options:             MYSQL_OPTIONS,
	status:              mysql_status,
	free_me:             my_bool,
	unused_1:            my_bool,
	scramble_buff:       [20 + 1]u8,
	unused_2:            my_bool,
	unused_3:            rawptr,
	unused_4:            rawptr,
	unused_5:            rawptr,
	unused_6:            rawptr,
	stmts:               ^LIST,
	methods:             ^st_mariadb_methods,
	thd:                 rawptr,
	unbuffered_fetch_owner: ^my_bool,
	info_buffer:         cstring,
	extension:           ^st_mariadb_extension,
}

// ─── MYSQL_RES (result set) ─────────────────────────────────────────────────

MYSQL_RES :: struct {
	row_count:    c.ulonglong,
	field_count:  c.uint,
	current_field: c.uint,
	fields:       ^MYSQL_FIELD,
	data:         ^MYSQL_DATA,
	data_cursor:  ^MYSQL_ROWS,
	field_alloc:  MA_MEM_ROOT,
	row:          MYSQL_ROW,
	current_row:  MYSQL_ROW,
	lengths:      [^]c.ulong,
	handle:       ^MYSQL,
	eof:          my_bool,
	is_ps:        my_bool,
}

// ─── MYSQL_PARAMETERS ───────────────────────────────────────────────────────

MYSQL_PARAMETERS :: struct {
	p_max_allowed_packet: ^c.ulong,
	p_net_buffer_length:  ^c.ulong,
	extension:            rawptr,
}

// ─── MY_CHARSET_INFO ────────────────────────────────────────────────────────

MY_CHARSET_INFO :: struct {
	number:   c.uint,
	state:    c.uint,
	csname:   cstring,
	name:     cstring,
	comment:  cstring,
	dir:      cstring,
	mbminlen: c.uint,
	mbmaxlen: c.uint,
}

// ─── MARIADB_CHARSET_INFO ───────────────────────────────────────────────────

MARIADB_CHARSET_INFO :: struct {
	nr:          c.uint,
	state:       c.uint,
	csname:      cstring,
	name:        cstring,
	dir:         cstring,
	codepage:    c.uint,
	encoding:    cstring,
	char_minlen: c.uint,
	char_maxlen: c.uint,
	mb_charlen:  proc(c.uint) -> c.uint,
	mb_valid:    proc(cstring, cstring) -> c.uint,
}

// ─── MARIADB_X509_INFO ──────────────────────────────────────────────────────

MARIADB_X509_INFO :: struct {
	version:     c.int,
	issuer:      cstring,
	subject:     cstring,
	fingerprint: [129]u8,
	not_before:  tm,
	not_after:   tm,
}

// ─── UDF_ARGS ───────────────────────────────────────────────────────────────

UDF_ARGS :: struct {
	arg_count:  c.uint,
	arg_type:   ^Item_result,
	args:       ^cstring,
	lengths:    ^c.ulong,
	maybe_null: cstring,
}

// ─── UDF_INIT ───────────────────────────────────────────────────────────────

UDF_INIT :: struct {
	maybe_null: my_bool,
	decimals:   c.uint,
	max_length: c.uint,
	ptr:        cstring,
	const_item: my_bool,
}

// ─── MYSQL_LEX_STRING ───────────────────────────────────────────────────────

MYSQL_LEX_STRING :: struct {
	str:    cstring,
	length: c.size_t,
}

LEX_STRING :: MYSQL_LEX_STRING

// ─── DYNAMIC_STRING ─────────────────────────────────────────────────────────

DYNAMIC_STRING :: struct {
	str:            cstring,
	length:         c.size_t,
	max_length:     c.size_t,
	alloc_increment: c.size_t,
}

// ─── tm alias (from time.h) ─────────────────────────────────────────────────

tm :: struct {
	tm_sec:    c.int,
	tm_min:    c.int,
	tm_hour:   c.int,
	tm_mday:   c.int,
	tm_mon:    c.int,
	tm_year:   c.int,
	tm_wday:   c.int,
	tm_yday:   c.int,
	tm_isdst:  c.int,
}

// ─── Opaque extensions ──────────────────────────────────────────────────────

st_mariadb_net_extension :: struct {}
st_mysql_options_extension :: struct {}
st_mariadb_extension :: struct {}
st_dynamic_array :: struct {}

// ─── st_mariadb_api function table ──────────────────────────────────────────

st_mariadb_api :: struct {
	mysql_num_rows:                   proc "stdcall" (^MYSQL_RES) -> c.ulonglong,
	mysql_num_fields:                 proc "stdcall" (^MYSQL_RES) -> c.uint,
	mysql_eof:                        proc "stdcall" (^MYSQL_RES) -> my_bool,
	mysql_fetch_field_direct:         proc "stdcall" (^MYSQL_RES, c.uint) -> ^MYSQL_FIELD,
	mysql_fetch_fields:               proc "stdcall" (^MYSQL_RES) -> ^MYSQL_FIELD,
	mysql_row_tell:                   proc "stdcall" (^MYSQL_RES) -> ^MYSQL_ROWS,
	mysql_field_tell:                 proc "stdcall" (^MYSQL_RES) -> c.uint,
	mysql_field_count:                proc "stdcall" (^MYSQL) -> c.uint,
	mysql_more_results:               proc "stdcall" (^MYSQL) -> my_bool,
	mysql_next_result:                proc "stdcall" (^MYSQL) -> c.int,
	mysql_affected_rows:              proc "stdcall" (^MYSQL) -> c.ulonglong,
	mysql_autocommit:                 proc "stdcall" (^MYSQL, my_bool) -> my_bool,
	mysql_commit:                     proc "stdcall" (^MYSQL) -> my_bool,
	mysql_rollback:                   proc "stdcall" (^MYSQL) -> my_bool,
	mysql_insert_id:                  proc "stdcall" (^MYSQL) -> c.ulonglong,
	mysql_errno:                      proc "stdcall" (^MYSQL) -> c.uint,
	mysql_error:                      proc "stdcall" (^MYSQL) -> cstring,
	mysql_info:                       proc "stdcall" (^MYSQL) -> cstring,
	mysql_thread_id:                  proc "stdcall" (^MYSQL) -> c.ulong,
	mysql_character_set_name:         proc "stdcall" (^MYSQL) -> cstring,
	mysql_get_character_set_info:     proc "stdcall" (^MYSQL, ^MY_CHARSET_INFO),
	mysql_set_character_set:          proc "stdcall" (^MYSQL, cstring) -> c.int,
	mariadb_get_infov:                proc(^MYSQL, mariadb_value, rawptr) -> my_bool,
	mariadb_get_info:                 proc "stdcall" (^MYSQL, mariadb_value, rawptr) -> my_bool,
	mysql_init:                       proc "stdcall" (^MYSQL) -> ^MYSQL,
	mysql_ssl_set:                    proc "stdcall" (^MYSQL, cstring, cstring, cstring, cstring, cstring) -> c.int,
	mysql_get_ssl_cipher:             proc "stdcall" (^MYSQL) -> cstring,
	mysql_change_user:                proc "stdcall" (^MYSQL, cstring, cstring, cstring) -> my_bool,
	mysql_real_connect:               proc "stdcall" (^MYSQL, cstring, cstring, cstring, cstring, c.uint, cstring, c.ulong) -> ^MYSQL,
	mysql_close:                      proc "stdcall" (^MYSQL),
	mysql_select_db:                  proc "stdcall" (^MYSQL, cstring) -> c.int,
	mysql_query:                      proc "stdcall" (^MYSQL, cstring) -> c.int,
	mysql_send_query:                 proc "stdcall" (^MYSQL, cstring, c.ulong) -> c.int,
	mysql_read_query_result:          proc "stdcall" (^MYSQL) -> my_bool,
	mysql_real_query:                 proc "stdcall" (^MYSQL, cstring, c.ulong) -> c.int,
	mysql_shutdown:                   proc "stdcall" (^MYSQL, mysql_enum_shutdown_level) -> c.int,
	mysql_dump_debug_info:            proc "stdcall" (^MYSQL) -> c.int,
	mysql_refresh:                    proc "stdcall" (^MYSQL, c.uint) -> c.int,
	mysql_kill:                       proc "stdcall" (^MYSQL, c.ulong) -> c.int,
	mysql_ping:                       proc "stdcall" (^MYSQL) -> c.int,
	mysql_stat:                       proc "stdcall" (^MYSQL) -> cstring,
	mysql_get_server_info:            proc "stdcall" (^MYSQL) -> cstring,
	mysql_get_server_version:         proc "stdcall" (^MYSQL) -> c.ulong,
	mysql_get_host_info:              proc "stdcall" (^MYSQL) -> cstring,
	mysql_get_proto_info:             proc "stdcall" (^MYSQL) -> c.uint,
	mysql_list_dbs:                   proc "stdcall" (^MYSQL, cstring) -> ^MYSQL_RES,
	mysql_list_tables:                proc "stdcall" (^MYSQL, cstring) -> ^MYSQL_RES,
	mysql_list_fields:                proc "stdcall" (^MYSQL, cstring, cstring) -> ^MYSQL_RES,
	mysql_list_processes:             proc "stdcall" (^MYSQL) -> ^MYSQL_RES,
	mysql_store_result:               proc "stdcall" (^MYSQL) -> ^MYSQL_RES,
	mysql_use_result:                 proc "stdcall" (^MYSQL) -> ^MYSQL_RES,
	mysql_options:                    proc "stdcall" (^MYSQL, mysql_option, rawptr) -> c.int,
	mysql_free_result:                proc "stdcall" (^MYSQL_RES),
	mysql_data_seek:                  proc "stdcall" (^MYSQL_RES, c.ulonglong),
	mysql_row_seek:                   proc "stdcall" (^MYSQL_RES, MYSQL_ROW_OFFSET) -> MYSQL_ROW_OFFSET,
	mysql_field_seek:                 proc "stdcall" (^MYSQL_RES, MYSQL_FIELD_OFFSET) -> MYSQL_FIELD_OFFSET,
	mysql_fetch_row:                  proc "stdcall" (^MYSQL_RES) -> MYSQL_ROW,
	mysql_fetch_lengths:              proc "stdcall" (^MYSQL_RES) -> [^]c.ulong,
	mysql_fetch_field:                proc "stdcall" (^MYSQL_RES) -> ^MYSQL_FIELD,
	mysql_escape_string:              proc "stdcall" (cstring, cstring, c.ulong) -> c.ulong,
	mysql_real_escape_string:         proc "stdcall" (^MYSQL, cstring, cstring, c.ulong) -> c.ulong,
	mysql_thread_safe:                proc "stdcall" () -> c.uint,
	mysql_warning_count:              proc "stdcall" (^MYSQL) -> c.uint,
	mysql_sqlstate:                   proc "stdcall" (^MYSQL) -> cstring,
	mysql_server_init:                proc "stdcall" (c.int, ^cstring, ^cstring) -> c.int,
	mysql_server_end:                 proc "stdcall" (),
	mysql_thread_end:                 proc "stdcall" (),
	mysql_thread_init:                proc "stdcall" () -> my_bool,
	mysql_set_server_option:          proc "stdcall" (^MYSQL, enum_mysql_set_option) -> c.int,
	mysql_get_client_info:            proc "stdcall" () -> cstring,
	mysql_get_client_version:         proc "stdcall" () -> c.ulong,
	mariadb_connection:               proc "stdcall" (^MYSQL) -> my_bool,
	mysql_get_server_name:            proc "stdcall" (^MYSQL) -> cstring,
	mariadb_get_charset_by_name:      proc "stdcall" (cstring) -> ^MARIADB_CHARSET_INFO,
	mariadb_get_charset_by_nr:        proc "stdcall" (c.uint) -> ^MARIADB_CHARSET_INFO,
	mariadb_convert_string:           proc "stdcall" (cstring, ^c.size_t, ^MARIADB_CHARSET_INFO, cstring, ^c.size_t, ^MARIADB_CHARSET_INFO, ^c.int) -> c.size_t,
	mysql_optionsv:                   proc(^MYSQL, mysql_option) -> c.int,
	mysql_get_optionv:                proc(^MYSQL, mysql_option, rawptr) -> c.int,
	mysql_get_option:                 proc "stdcall" (^MYSQL, mysql_option, rawptr) -> c.int,
	mysql_hex_string:                 proc "stdcall" (cstring, cstring, c.ulong) -> c.ulong,
	mysql_get_socket:                 proc "stdcall" (^MYSQL) -> my_socket,
	mysql_get_timeout_value:          proc "stdcall" (^MYSQL) -> c.uint,
	mysql_get_timeout_value_ms:       proc "stdcall" (^MYSQL) -> c.uint,
	mariadb_reconnect:                proc "stdcall" (^MYSQL) -> my_bool,
	mysql_stmt_init:                  proc "stdcall" (^MYSQL) -> ^MYSQL_STMT,
	mysql_stmt_prepare:               proc "stdcall" (^MYSQL_STMT, cstring, c.ulong) -> c.int,
	mysql_stmt_execute:               proc "stdcall" (^MYSQL_STMT) -> c.int,
	mysql_stmt_fetch:                 proc "stdcall" (^MYSQL_STMT) -> c.int,
	mysql_stmt_fetch_column:          proc "stdcall" (^MYSQL_STMT, ^MYSQL_BIND, c.uint, c.ulong) -> c.int,
	mysql_stmt_store_result:          proc "stdcall" (^MYSQL_STMT) -> c.int,
	mysql_stmt_param_count:           proc "stdcall" (^MYSQL_STMT) -> c.ulong,
	mysql_stmt_attr_set:              proc "stdcall" (^MYSQL_STMT, enum_stmt_attr_type, rawptr) -> my_bool,
	mysql_stmt_attr_get:              proc "stdcall" (^MYSQL_STMT, enum_stmt_attr_type, rawptr) -> my_bool,
	mysql_stmt_bind_param:            proc "stdcall" (^MYSQL_STMT, ^MYSQL_BIND) -> my_bool,
	mysql_stmt_bind_result:           proc "stdcall" (^MYSQL_STMT, ^MYSQL_BIND) -> my_bool,
	mysql_stmt_close:                 proc "stdcall" (^MYSQL_STMT) -> my_bool,
	mysql_stmt_reset:                 proc "stdcall" (^MYSQL_STMT) -> my_bool,
	mysql_stmt_free_result:           proc "stdcall" (^MYSQL_STMT) -> my_bool,
	mysql_stmt_send_long_data:        proc "stdcall" (^MYSQL_STMT, c.uint, cstring, c.ulong) -> my_bool,
	mysql_stmt_result_metadata:       proc "stdcall" (^MYSQL_STMT) -> ^MYSQL_RES,
	mysql_stmt_param_metadata:        proc "stdcall" (^MYSQL_STMT) -> ^MYSQL_RES,
	mysql_stmt_errno:                 proc "stdcall" (^MYSQL_STMT) -> c.uint,
	mysql_stmt_error:                 proc "stdcall" (^MYSQL_STMT) -> cstring,
	mysql_stmt_sqlstate:              proc "stdcall" (^MYSQL_STMT) -> cstring,
	mysql_stmt_row_seek:              proc "stdcall" (^MYSQL_STMT, MYSQL_ROW_OFFSET) -> MYSQL_ROW_OFFSET,
	mysql_stmt_row_tell:              proc "stdcall" (^MYSQL_STMT) -> MYSQL_ROW_OFFSET,
	mysql_stmt_data_seek:             proc "stdcall" (^MYSQL_STMT, c.ulonglong),
	mysql_stmt_num_rows:              proc "stdcall" (^MYSQL_STMT) -> c.ulonglong,
	mysql_stmt_affected_rows:         proc "stdcall" (^MYSQL_STMT) -> c.ulonglong,
	mysql_stmt_insert_id:             proc "stdcall" (^MYSQL_STMT) -> c.ulonglong,
	mysql_stmt_field_count:           proc "stdcall" (^MYSQL_STMT) -> c.uint,
	mysql_stmt_next_result:           proc "stdcall" (^MYSQL_STMT) -> c.int,
	mysql_stmt_more_results:          proc "stdcall" (^MYSQL_STMT) -> my_bool,
	mariadb_stmt_execute_direct:      proc "stdcall" (^MYSQL_STMT, cstring, c.size_t) -> c.int,
	mysql_reset_connection:           proc "stdcall" (^MYSQL) -> c.int,
}

// ─── st_mariadb_methods (connection plugin methods) ─────────────────────────

st_mariadb_methods :: struct {
	db_connect:                         proc(^MYSQL, cstring, cstring, cstring, cstring, c.uint, cstring, c.ulong) -> ^MYSQL,
	db_close:                           proc(^MYSQL),
	db_command:                         proc(^MYSQL, enum_server_command, cstring, c.size_t, my_bool, rawptr) -> c.int,
	db_skip_result:                     proc(^MYSQL),
	db_read_query_result:               proc(^MYSQL) -> c.int,
	db_read_rows:                       proc(^MYSQL, ^MYSQL_FIELD, c.uint) -> ^MYSQL_DATA,
	db_read_one_row:                    proc(^MYSQL, c.uint, MYSQL_ROW, ^c.ulong) -> c.int,
	db_supported_buffer_type:           proc(enum_field_types) -> my_bool,
	db_read_prepare_response:           proc(^MYSQL_STMT) -> my_bool,
	db_read_stmt_result:                proc(^MYSQL) -> c.int,
	db_stmt_get_result_metadata:        proc(^MYSQL_STMT) -> my_bool,
	db_stmt_get_param_metadata:         proc(^MYSQL_STMT) -> my_bool,
	db_stmt_read_all_rows:              proc(^MYSQL_STMT) -> c.int,
	db_stmt_fetch:                      proc(^MYSQL_STMT, ^^u8) -> c.int,
	db_stmt_fetch_to_bind:              proc(^MYSQL_STMT, ^u8) -> c.int,
	db_stmt_flush_unbuffered:           proc(^MYSQL_STMT),
	set_error:                          proc(^MYSQL, c.uint, cstring, cstring),
	invalidate_stmts:                   proc(^MYSQL, cstring),
	api:                                ^st_mariadb_api,
	db_read_execute_response:           proc(^MYSQL_STMT) -> c.int,
	db_execute_generate_request:        proc(^MYSQL_STMT, ^c.size_t, my_bool) -> ^u8,
}

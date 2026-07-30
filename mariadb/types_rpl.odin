package mariadb

import "core:c"

// ─── Replication Constants ──────────────────────────────────────────────────

MARIADB_RPL_VERSION :: 0x0002
MARIADB_RPL_REQUIRED_VERSION :: 0x0002
RPL_BINLOG_MAGIC_SIZE :: 4
EVENT_HEADER_OFS :: 20

// Protocol flags
MARIADB_RPL_BINLOG_DUMP_NON_BLOCK :: 1
MARIADB_RPL_BINLOG_SEND_ANNOTATE_ROWS :: 2
MARIADB_RPL_IGNORE_HEARTBEAT :: (1 << 17)

// GTID flags
FL_STMT_END :: 1
FL_STANDALONE :: 0x01
FL_GROUP_COMMIT_ID :: 0x02
FL_TRANSACTIONAL :: 0x04
FL_ALLOW_PARALLEL :: 0x08
FL_WAITED :: 0x10
FL_DDL :: 0x20
FL_PREPARED_XA :: 0x40
FL_COMPLETED_XA :: 0x80

// Semi-sync
SEMI_SYNC_INDICATOR :: 0xEF
SEMI_SYNC_ACK_REQ :: 0x01

// ROWS_EVENT flags
STMT_END_F :: 0x01
NO_FOREIGN_KEY_CHECKS_F :: 0x02
RELAXED_UNIQUE_KEY_CHECKS_F :: 0x04
COMPLETE_ROWS_F :: 0x08
NO_CHECK_CONSTRAINT_CHECKS_F :: 0x80

// Log Event flags
LOG_EVENT_BINLOG_IN_USE_F :: 0x0001
LOG_EVENT_FORCED_ROTATE_F :: 0x0002
LOG_EVENT_THREAD_SPECIFIC_F :: 0x0004
LOG_EVENT_SUPPRESS_USE_F :: 0x0008
LOG_EVENT_UPDATE_TABLE_MAP_F :: 0x0010
LOG_EVENT_ARTIFICIAL_F :: 0x0020
LOG_EVENT_RELAY_LOG_F :: 0x0040
LOG_EVENT_IGNORABLE_F :: 0x0080
LOG_EVENT_NO_FILTER_F :: 0x0100
LOG_EVENT_MTS_ISOLATE_F :: 0x0200
LOG_EVENT_SKIP_REPLICATION_F :: 0x8000

// QFLAGS2
OPTION_AUTO_IS_NULL :: 0x00040000
OPTION_NOT_AUTOCOMMIT :: 0x00080000
OPTION_NO_FOREIGN_KEY_CHECKS :: 0x04000000
OPTION_RELAXED_UNIQUE_CHECKS :: 0x08000000

// SQL modes
MODE_REAL_AS_FLOAT :: 0x00000001
MODE_PIPES_AS_CONCAT :: 0x00000002
MODE_ANSI_QUOTES :: 0x00000004
MODE_IGNORE_SPACE :: 0x00000008
MODE_ONLY_FULL_GROUP_BY :: 0x00000020
MODE_NO_UNSIGNED_SUBTRACTION :: 0x00000040
MODE_NO_DIR_IN_CREATE :: 0x00000080
MODE_POSTGRESQL :: 0x00000100
MODE_ORACLE :: 0x00000200
MODE_MSSQL :: 0x00000400
MODE_DB2 :: 0x00000800
MODE_MAXDB :: 0x00001000
MODE_NO_KEY_OPTIONS :: 0x00002000
MODE_NO_TABLE_OPTIONS :: 0x00004000
MODE_NO_FIELD_OPTIONS :: 0x00008000
MODE_MYSQL323 :: 0x00010000
MODE_MYSQL40 :: 0x00020000
MODE_ANSI :: 0x00040000
MODE_NO_AUTO_VALUE_ON_ZERO :: 0x00080000
MODE_NO_BACKSLASH_ESCAPES :: 0x00100000
MODE_STRICT_TRANS_TABLES :: 0x00200000
MODE_STRICT_ALL_TABLES :: 0x00400000
MODE_NO_ZERO_IN_DATE :: 0x00800000
MODE_NO_ZERO_DATE :: 0x01000000
MODE_INVALID_DATES :: 0x02000000
MODE_ERROR_FOR_DIVISION_BY_ZERO :: 0x04000000
MODE_TRADITIONAL :: 0x08000000
MODE_NO_AUTO_CREATE_USER :: 0x10000000
MODE_HIGH_NOT_PRECEDENCE :: 0x20000000
MODE_NO_ENGINE_SUBSTITUTION :: 0x40000000
MODE_PAD_CHAR_TO_FULL_LENGTH :: 0x80000000

// ─── mariadb_rpl_option ─────────────────────────────────────────────────────

mariadb_rpl_option :: enum c.int {
	MARIADB_RPL_FILENAME,
	MARIADB_RPL_START,
	MARIADB_RPL_SERVER_ID,
	MARIADB_RPL_FLAGS,
	MARIADB_RPL_GTID_CALLBACK,
	MARIADB_RPL_GTID_DATA,
	MARIADB_RPL_BUFFER,
	MARIADB_RPL_VERIFY_CHECKSUM,
	MARIADB_RPL_UNCOMPRESS,
	MARIADB_RPL_HOST,
	MARIADB_RPL_PORT,
	MARIADB_RPL_EXTRACT_VALUES,
	MARIADB_RPL_SEMI_SYNC,
}

// ─── mariadb_rpl_event (event types) ────────────────────────────────────────

mariadb_rpl_event :: enum c.int {
	UNKNOWN_EVENT,
	START_EVENT_V3,
	QUERY_EVENT,
	STOP_EVENT,
	ROTATE_EVENT,
	INTVAR_EVENT,
	LOAD_EVENT,
	SLAVE_EVENT,
	CREATE_FILE_EVENT,
	APPEND_BLOCK_EVENT,
	EXEC_LOAD_EVENT,
	DELETE_FILE_EVENT,
	NEW_LOAD_EVENT,
	RAND_EVENT,
	USER_VAR_EVENT,
	FORMAT_DESCRIPTION_EVENT,
	XID_EVENT,
	BEGIN_LOAD_QUERY_EVENT,
	EXECUTE_LOAD_QUERY_EVENT,
	TABLE_MAP_EVENT,
	PRE_GA_WRITE_ROWS_EVENT  = 20,
	PRE_GA_UPDATE_ROWS_EVENT = 21,
	PRE_GA_DELETE_ROWS_EVENT = 22,
	WRITE_ROWS_EVENT_V1      = 23,
	UPDATE_ROWS_EVENT_V1     = 24,
	DELETE_ROWS_EVENT_V1     = 25,
	INCIDENT_EVENT           = 26,
	HEARTBEAT_LOG_EVENT      = 27,
	IGNORABLE_LOG_EVENT      = 28,
	ROWS_QUERY_LOG_EVENT     = 29,
	WRITE_ROWS_EVENT         = 30,
	UPDATE_ROWS_EVENT        = 31,
	DELETE_ROWS_EVENT        = 32,
	GTID_LOG_EVENT           = 33,
	ANONYMOUS_GTID_LOG_EVENT = 34,
	PREVIOUS_GTIDS_LOG_EVENT = 35,
	TRANSACTION_CONTEXT_EVENT = 36,
	VIEW_CHANGE_EVENT        = 37,
	XA_PREPARE_LOG_EVENT     = 38,
	PARTIAL_UPDATE_ROWS_EVENT = 39,
	MYSQL_EVENTS_END,
	MARIA_EVENTS_BEGIN       = 160,
	ANNOTATE_ROWS_EVENT      = 160,
	BINLOG_CHECKPOINT_EVENT  = 161,
	GTID_EVENT               = 162,
	GTID_LIST_EVENT          = 163,
	START_ENCRYPTION_EVENT   = 164,
	QUERY_COMPRESSED_EVENT   = 165,
	WRITE_ROWS_COMPRESSED_EVENT_V1 = 166,
	UPDATE_ROWS_COMPRESSED_EVENT_V1 = 167,
	DELETE_ROWS_COMPRESSED_EVENT_V1 = 168,
	WRITE_ROWS_COMPRESSED_EVENT = 169,
	UPDATE_ROWS_COMPRESSED_EVENT = 170,
	DELETE_ROWS_COMPRESSED_EVENT = 171,
	ENUM_END_EVENT,
}

// ─── mariadb_row_event_type ─────────────────────────────────────────────────

mariadb_row_event_type :: enum c.int {
	WRITE_ROWS  = 0,
	UPDATE_ROWS = 1,
	DELETE_ROWS = 2,
}

// ─── mariadb_rpl_status_code ────────────────────────────────────────────────

mariadb_rpl_status_code :: enum c.int {
	Q_FLAGS2_CODE                              = 0x00,
	Q_SQL_MODE_CODE                            = 0x01,
	Q_CATALOG_CODE                             = 0x02,
	Q_AUTO_INCREMENT_CODE                      = 0x03,
	Q_CHARSET_CODE                             = 0x04,
	Q_TIMEZONE_CODE                            = 0x05,
	Q_CATALOG_NZ_CODE                          = 0x06,
	Q_LC_TIME_NAMES_CODE                       = 0x07,
	Q_CHARSET_DATABASE_CODE                    = 0x08,
	Q_TABLE_MAP_FOR_UPDATE_CODE                = 0x09,
	Q_MASTER_DATA_WRITTEN_CODE                 = 0x0A,
	Q_INVOKERS_CODE                            = 0x0B,
	Q_UPDATED_DB_NAMES_CODE                    = 0x0C,
	Q_MICROSECONDS_CODE                        = 0x0D,
	Q_COMMIT_TS_CODE                           = 0x0E,
	Q_COMMIT_TS2_CODE                          = 0x0F,
	Q_EXPLICIT_DEFAULTS_FOR_TIMESTAMP_CODE     = 0x10,
	Q_DDL_LOGGED_WITH_XID_CODE                 = 0x11,
	Q_DEFAULT_COLLATION_FOR_UTF8_CODE          = 0x12,
	Q_SQL_REQUIRE_PRIMARY_KEY_CODE             = 0x13,
	Q_DEFAULT_TABLE_ENCRYPTION_CODE            = 0x14,
	Q_HRNOW                                    = 128,
	Q_XID                                       = 129,
}

// ─── opt_metadata_field_type ────────────────────────────────────────────────

opt_metadata_field_type :: enum c.int {
	SIGNEDNESS               = 1,
	DEFAULT_CHARSET,
	COLUMN_CHARSET,
	COLUMN_NAME,
	SET_STR_VALUE,
	ENUM_STR_VALUE,
	GEOMETRY_TYPE,
	SIMPLE_PRIMARY_KEY,
	PRIMARY_KEY_WITH_PREFIX,
	ENUM_AND_SET_DEFAULT_CHARSET,
	ENUM_AND_SET_COLUMN_CHARSET,
}

// ─── MARIADB_STRING ─────────────────────────────────────────────────────────

MARIADB_STRING :: struct {
	str:    cstring,
	length: c.size_t,
}

// ─── MARIADB_GTID ───────────────────────────────────────────────────────────

MARIADB_GTID :: struct {
	domain_id:   c.uint,
	server_id:   c.uint,
	sequence_nr: c.ulonglong,
}

// The number of event types (ENUM_END_EVENT from mariadb_rpl_event enum).
// Using a numeric constant since Odin does not allow enum values as array bounds.
RPL_EVENT_COUNT :: 172

// ─── MARIADB_RPL (replication handle) ───────────────────────────────────────

MARIADB_RPL :: struct {
	version:          c.uint,
	mysql:            ^MYSQL,
	filename:         cstring,
	filename_length:  u32,
	server_id:        u32,
	start_position:   c.ulong,
	flags:            u16,
	fd_header_len:    u8,
	use_checksum:     u8,
	artificial_checksum: u8,
	verify_checksum:  u8,
	post_header_len:  [RPL_EVENT_COUNT]u8,
	fp:               rawptr, // MA_FILE *
	error_no:         u32,
	error_msg:        [MYSQL_ERRMSG_SIZE]u8,
	uncompress:       u8,
	host:             cstring,
	port:             u32,
	extract_values:   u8,
	nonce:            [12]u8,
	encrypted:        u8,
	is_semi_sync:     u8,
}

// ─── MARIADB_RPL_VALUE ──────────────────────────────────────────────────────

MARIADB_RPL_VALUE :: struct {
	field_type: enum_field_types,
	is_null:    u8,
	is_signed:  u8,
	val:        struct #raw_union {
		ll:  i64,
		ull: u64,
		f:   f32,
		d:   f64,
		tm:  MYSQL_TIME,
		str: MARIADB_STRING,
	},
}

// ─── MARIADB_RPL_ROW ────────────────────────────────────────────────────────

MARIADB_RPL_ROW :: struct {
	column_count: u32,
	columns:      ^MARIADB_RPL_VALUE,
	next:         ^MARIADB_RPL_ROW,
}

// ─── Event structures ───────────────────────────────────────────────────────

MARIADB_RPL_ROTATE_EVENT :: struct {
	position: c.ulonglong,
	filename: MARIADB_STRING,
}

MARIADB_RPL_QUERY_EVENT :: struct {
	thread_id: u32,
	seconds:   u32,
	database:  MARIADB_STRING,
	errornr:   u32,
	status:    MARIADB_STRING,
	statement: MARIADB_STRING,
}

MARIADB_RPL_PREVIOUS_GTID_EVENT :: struct {
	content: MARIADB_CONST_DATA,
}

MARIADB_RPL_GTID_LIST_EVENT :: struct {
	gtid_cnt: u32,
	gtid:     ^MARIADB_GTID,
}

MARIADB_RPL_FORMAT_DESCRIPTION_EVENT :: struct {
	format:              u16,
	server_version:      cstring,
	timestamp:           u32,
	header_len:          u8,
	post_header_lengths: MARIADB_STRING,
}

MARIADB_RPL_CHECKPOINT_EVENT :: struct {
	filename: MARIADB_STRING,
}

MARIADB_RPL_XID_EVENT :: struct {
	transaction_nr: u64,
}

MARIADB_RPL_GTID_EVENT :: struct {
	sequence_nr: u64,
	domain_id:   u32,
	flags:       u8,
	commit_id:   u64,
	format_id:   u32,
	gtrid_len:   u8,
	bqual_len:   u8,
	xid:         MARIADB_STRING,
}

MARIADB_RPL_ANNOTATE_ROWS_EVENT :: struct {
	statement: MARIADB_STRING,
}

MARIADB_RPL_TABLE_MAP_EVENT :: struct {
	table_id:               c.ulonglong,
	database:               MARIADB_STRING,
	table:                  MARIADB_STRING,
	column_count:           u32,
	column_types:           MARIADB_STRING,
	metadata:               MARIADB_STRING,
	null_indicator:         ^u8,
	signed_indicator:       ^u8,
	column_names:           MARIADB_CONST_DATA,
	geometry_types:         MARIADB_CONST_DATA,
	default_charset:        u32,
	column_charsets:        MARIADB_CONST_DATA,
	simple_primary_keys:    MARIADB_CONST_DATA,
	prefixed_primary_keys:  MARIADB_CONST_DATA,
	set_values:             MARIADB_CONST_DATA,
	enum_values:            MARIADB_CONST_DATA,
	enum_set_default_charset: u8,
	enum_set_column_charsets: MARIADB_CONST_DATA,
}

MARIADB_RPL_RAND_EVENT :: struct {
	first_seed:  c.ulonglong,
	second_seed: c.ulonglong,
}

MARIADB_RPL_INTVAR_EVENT :: struct {
	value: c.ulonglong,
	type:  u8,
}

MARIADB_BEGIN_LOAD_QUERY_EVENT :: struct {
	file_id: u32,
	data:    ^u8,
}

MARIADB_START_ENCRYPTION_EVENT :: struct {
	scheme:    u8,
	key_version: u32,
	nonce:     [12]u8,
}

MARIADB_EXECUTE_LOAD_QUERY_EVENT :: struct {
	thread_id:      u32,
	execution_time: u32,
	schema:         MARIADB_STRING,
	error_code:     u16,
	file_id:        u32,
	ofs1:           u32,
	ofs2:           u32,
	duplicate_flag: u8,
	status_vars:    MARIADB_STRING,
	statement:      MARIADB_STRING,
}

MARIADB_RPL_USERVAR_EVENT :: struct {
	name:       MARIADB_STRING,
	is_null:    u8,
	type:       u8,
	charset_nr: u32,
	value:      MARIADB_STRING,
	flags:      u8,
}

MARIADB_RPL_ROWS_EVENT :: struct {
	type:               mariadb_row_event_type,
	table_id:           u64,
	flags:              u16,
	column_count:       u32,
	column_bitmap:      ^u8,
	column_update_bitmap: ^u8,
	null_bitmap:        ^u8,
	row_data_size:      c.size_t,
	row_data:           rawptr,
	extra_data_size:    c.size_t,
	extra_data:         rawptr,
	compressed:         u8,
	row_count:          u32,
}

MARIADB_RPL_HEARTBEAT_EVENT :: struct {
	filename: MARIADB_STRING,
}

MARIADB_RPL_XA_PREPARE_LOG_EVENT :: struct {
	one_phase: u8,
	format_id: u32,
	gtrid_len: u32,
	bqual_len: u32,
	xid:       MARIADB_STRING,
}

MARIADB_GTID_LOG_EVENT :: struct {
	commit_flag: u8,
	source_id:   [16]u8,
	sequence_nr: u64,
}

// ─── MARIADB_RPL_EVENT (main replication event) ─────────────────────────────

MARIADB_RPL_EVENT :: struct {
	memroot:        MA_MEM_ROOT,
	raw_data:       ^u8,
	raw_data_size:  c.size_t,
	raw_data_ofs:   c.size_t,
	checksum:       c.uint,
	ok:             u8,
	event_type:     mariadb_rpl_event,
	timestamp:      c.uint,
	server_id:      c.uint,
	event_length:   c.uint,
	next_event_pos: c.uint,
	flags:          c.short,
	event:          struct #raw_union {
		rotate:            MARIADB_RPL_ROTATE_EVENT,
		query:             MARIADB_RPL_QUERY_EVENT,
		format_description: MARIADB_RPL_FORMAT_DESCRIPTION_EVENT,
		gtid_list:         MARIADB_RPL_GTID_LIST_EVENT,
		checkpoint:        MARIADB_RPL_CHECKPOINT_EVENT,
		xid:               MARIADB_RPL_XID_EVENT,
		gtid:              MARIADB_RPL_GTID_EVENT,
		annotate_rows:     MARIADB_RPL_ANNOTATE_ROWS_EVENT,
		table_map:         MARIADB_RPL_TABLE_MAP_EVENT,
		rand:              MARIADB_RPL_RAND_EVENT,
		intvar:            MARIADB_RPL_INTVAR_EVENT,
		uservar:           MARIADB_RPL_USERVAR_EVENT,
		rows:              MARIADB_RPL_ROWS_EVENT,
		heartbeat:         MARIADB_RPL_HEARTBEAT_EVENT,
		xa_prepare_log:    MARIADB_RPL_XA_PREPARE_LOG_EVENT,
		begin_load_query:  MARIADB_BEGIN_LOAD_QUERY_EVENT,
		execute_load_query: MARIADB_EXECUTE_LOAD_QUERY_EVENT,
		gtid_log:          MARIADB_GTID_LOG_EVENT,
		start_encryption:  MARIADB_START_ENCRYPTION_EVENT,
		previous_gtid:     MARIADB_RPL_PREVIOUS_GTID_EVENT,
	},
	is_semi_sync:       u8,
	semi_sync_flags:    u8,
	rpl:                ^MARIADB_RPL,
}

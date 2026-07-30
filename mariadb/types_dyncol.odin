package mariadb

import "core:c"

// ─── Dynamic Column Type ────────────────────────────────────────────────────

DYNAMIC_COLUMN :: DYNAMIC_STRING

// ─── enum_dyncol_func_result ────────────────────────────────────────────────

enum_dyncol_func_result :: enum c.int {
	ER_DYNCOL_OK              = 0,
	ER_DYNCOL_YES             = 1,
	ER_DYNCOL_FORMAT          = -1,
	ER_DYNCOL_LIMIT           = -2,
	ER_DYNCOL_RESOURCE        = -3,
	ER_DYNCOL_DATA            = -4,
	ER_DYNCOL_UNKNOWN_CHARSET = -5,
	ER_DYNCOL_TRUNCATED       = 2,
}

// ─── enum_dynamic_column_type ───────────────────────────────────────────────

enum_dynamic_column_type :: enum c.int {
	DYN_COL_NULL    = 0,
	DYN_COL_INT,
	DYN_COL_UINT,
	DYN_COL_DOUBLE,
	DYN_COL_STRING,
	DYN_COL_DECIMAL,
	DYN_COL_DATETIME,
	DYN_COL_DATE,
	DYN_COL_TIME,
	DYN_COL_DYNCOL,
}

DYNAMIC_COLUMN_TYPE :: enum_dynamic_column_type

// ─── DYNAMIC_COLUMN_VALUE ───────────────────────────────────────────────────

DYNAMIC_COLUMN_VALUE :: struct {
	type: DYNAMIC_COLUMN_TYPE,
	x: struct #raw_union {
		long_value:  i64,
		ulong_value: u64,
		double_value: f64,
		string: struct {
			value:   MYSQL_LEX_STRING,
			charset: ^MARIADB_CHARSET_INFO,
		},
		time_value: MYSQL_TIME,
	},
}

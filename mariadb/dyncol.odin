package mariadb

import "core:c"

when ODIN_OS != .Windows {
	foreign import lib "system:mariadb"
} else {
	foreign import lib "mariadb.lib"
}

// ─── Dynamic Column Functions ───────────────────────────────────────────────

foreign lib {
	mariadb_dyncol_create_many_num :: proc(
		str: ^DYNAMIC_COLUMN,
		column_count: c.uint,
		column_numbers: ^c.uint,
		values: ^DYNAMIC_COLUMN_VALUE,
		new_string: my_bool,
	) -> enum_dyncol_func_result ---

	mariadb_dyncol_create_many_named :: proc(
		str: ^DYNAMIC_COLUMN,
		column_count: c.uint,
		column_keys: ^MYSQL_LEX_STRING,
		values: ^DYNAMIC_COLUMN_VALUE,
		new_string: my_bool,
	) -> enum_dyncol_func_result ---

	mariadb_dyncol_update_many_num :: proc(
		str: ^DYNAMIC_COLUMN,
		add_column_count: c.uint,
		column_keys: ^c.uint,
		values: ^DYNAMIC_COLUMN_VALUE,
	) -> enum_dyncol_func_result ---

	mariadb_dyncol_update_many_named :: proc(
		str: ^DYNAMIC_COLUMN,
		add_column_count: c.uint,
		column_keys: ^MYSQL_LEX_STRING,
		values: ^DYNAMIC_COLUMN_VALUE,
	) -> enum_dyncol_func_result ---

	mariadb_dyncol_exists_num   :: proc(org: ^DYNAMIC_COLUMN, column_nr: c.uint) -> enum_dyncol_func_result ---
	mariadb_dyncol_exists_named :: proc(str: ^DYNAMIC_COLUMN, name: ^MYSQL_LEX_STRING) -> enum_dyncol_func_result ---

	mariadb_dyncol_list_num   :: proc(str: ^DYNAMIC_COLUMN, count: ^c.uint, nums: ^^c.uint) -> enum_dyncol_func_result ---
	mariadb_dyncol_list_named :: proc(str: ^DYNAMIC_COLUMN, count: ^c.uint, names: ^^MYSQL_LEX_STRING) -> enum_dyncol_func_result ---

	mariadb_dyncol_get_num   :: proc(org: ^DYNAMIC_COLUMN, column_nr: c.uint, store_it_here: ^DYNAMIC_COLUMN_VALUE) -> enum_dyncol_func_result ---
	mariadb_dyncol_get_named :: proc(str: ^DYNAMIC_COLUMN, name: ^MYSQL_LEX_STRING, store_it_here: ^DYNAMIC_COLUMN_VALUE) -> enum_dyncol_func_result ---

	mariadb_dyncol_has_names :: proc(str: ^DYNAMIC_COLUMN) -> my_bool ---

	mariadb_dyncol_check :: proc(str: ^DYNAMIC_COLUMN) -> enum_dyncol_func_result ---
	mariadb_dyncol_json  :: proc(str: ^DYNAMIC_COLUMN, json: ^DYNAMIC_STRING) -> enum_dyncol_func_result ---

	mariadb_dyncol_free :: proc(str: ^DYNAMIC_COLUMN) ---

	mariadb_dyncol_val_str  :: proc(str: ^DYNAMIC_STRING, val: ^DYNAMIC_COLUMN_VALUE, cs: ^MARIADB_CHARSET_INFO, quote: u8) -> enum_dyncol_func_result ---
	mariadb_dyncol_val_long :: proc(ll: ^i64, val: ^DYNAMIC_COLUMN_VALUE) -> enum_dyncol_func_result ---
	mariadb_dyncol_val_double :: proc(dbl: ^f64, val: ^DYNAMIC_COLUMN_VALUE) -> enum_dyncol_func_result ---

	mariadb_dyncol_unpack :: proc(
		str: ^DYNAMIC_COLUMN,
		count: ^c.uint,
		names: ^^MYSQL_LEX_STRING,
		vals: ^^DYNAMIC_COLUMN_VALUE,
	) -> enum_dyncol_func_result ---

	mariadb_dyncol_column_cmp_named :: proc(s1: ^MYSQL_LEX_STRING, s2: ^MYSQL_LEX_STRING) -> c.int ---
	mariadb_dyncol_column_count     :: proc(str: ^DYNAMIC_COLUMN, column_count: ^c.uint) -> enum_dyncol_func_result ---
	mariadb_dyncol_prepare_decimal  :: proc(value: ^DYNAMIC_COLUMN_VALUE) ---
}

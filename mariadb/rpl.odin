package mariadb

import "core:c"

when ODIN_OS != .Windows {
	foreign import lib "system:mariadb"
} else {
	foreign import lib "mariadb.lib"
}

// ─── Replication API ────────────────────────────────────────────────────────
// Note: mariadb_rpl_optionsv and mariadb_rpl_get_optionsv are variadic in C.
// They are declared here without variadic support since Odin foreign blocks
// do not support #c_vararg. For most uses the fixed options work.

foreign lib {
	mariadb_rpl_init_ex :: proc(mysql: ^MYSQL, version: c.uint) -> ^MARIADB_RPL ---
	mariadb_rpl_error   :: proc(rpl: ^MARIADB_RPL) -> cstring ---
	mariadb_rpl_errno   :: proc(rpl: ^MARIADB_RPL) -> u32 ---
	mariadb_rpl_optionsv    :: proc(rpl: ^MARIADB_RPL, option: mariadb_rpl_option) -> c.int ---
	mariadb_rpl_get_optionsv :: proc(rpl: ^MARIADB_RPL, option: mariadb_rpl_option) -> c.int ---
	mariadb_rpl_open  :: proc(rpl: ^MARIADB_RPL) -> c.int ---
	mariadb_rpl_close :: proc(rpl: ^MARIADB_RPL) ---
	mariadb_rpl_fetch :: proc(rpl: ^MARIADB_RPL, event: ^MARIADB_RPL_EVENT) -> ^MARIADB_RPL_EVENT ---
	mariadb_free_rpl_event :: proc(event: ^MARIADB_RPL_EVENT) ---
	mariadb_rpl_extract_rows :: proc(
		rpl: ^MARIADB_RPL,
		tm_event: ^MARIADB_RPL_EVENT,
		row_event: ^MARIADB_RPL_EVENT,
	) -> ^MARIADB_RPL_ROW ---
}

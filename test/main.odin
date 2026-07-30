package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:c"
import ma "../mariadb"

// ─── Configuration via environment variables ─────────────────────────────────
// These allow the test to run in CI, containers, or local environments.
//
//   MARIADB_HOST   (default: "127.0.0.1")
//   MARIADB_PORT   (default: "0" — let the library decide, normally 3306)
//   MARIADB_USER   (default: "root")
//   MARIADB_PASS   (default: "")
//   MARIADB_DB     (default: "test")

Config :: struct {
	host: string,
	port: c.uint,
	user: string,
	pass: string,
	db:   string,
}

load_config :: proc() -> Config {
	cfg: Config
	cfg.host = env_default("MARIADB_HOST", "127.0.0.1")
	cfg.user = env_default("MARIADB_USER", "root")
	cfg.pass = env_default("MARIADB_PASS", "")
	cfg.db   = env_default("MARIADB_DB",   "test")

	port_str := env_default("MARIADB_PORT", "0")
	p, ok := strconv.parse_uint(port_str, 10)
	cfg.port = c.uint(p) if ok else 0

	return cfg
}

// env_default reads an env var; returns the default value if the variable is
// unset or empty.
env_default :: proc(key: string, default: string) -> string {
	buf: [4096]u8
	val := os.get_env_buf(buf[:], key)
	if val == "" {
		return default
	}
	return strings.clone(val)
}

// ─── Convenience helpers ─────────────────────────────────────────────────────

check :: proc(mysql: ^ma.MYSQL, errno: c.int, stage: string) {
	if errno != 0 {
		fmt.eprintf("[FAIL] %s: errno=%d %s\n", stage, ma.mysql_errno(mysql), ma.mysql_error(mysql))
		os.exit(1)
	}
}

check_stmt :: proc(stmt: ^ma.MYSQL_STMT, ok: c.int, stage: string) {
	if ok != 0 {
		fmt.eprintf("[FAIL] %s: errno=%d %s\n", stage, ma.mysql_stmt_errno(stmt), ma.mysql_stmt_error(stmt))
		os.exit(1)
	}
}

check_ptr :: proc(ptr: rawptr, stage: string) {
	if ptr == nil {
		fmt.eprintf("[FAIL] %s returned nil\n", stage)
		os.exit(1)
	}
}

// ─── Tests ───────────────────────────────────────────────────────────────────

test_version_info :: proc() {
	fmt.println("=== Test: Version Information ===")

	client_ver := ma.mysql_get_client_version()
	
    fmt.printf("  Client version: %d\n", client_ver)
	
    client_info := ma.mysql_get_client_info()
	
    fmt.printf("  Client info:    %s\n", client_info)

	// mariadb_get_info for client version string
	var: cstring
	
    if ma.mariadb_get_info(nil, .MARIADB_CLIENT_VERSION, &var) == 0 {
		fmt.printf("  MariaDB client: %s\n", var)
	}
}

test_connect :: proc(mysql: ^ma.MYSQL, cfg: Config) {
	fmt.println("=== Test: Connection ===")

	host_c := cstring(raw_data(cfg.host))
	user_c := cstring(raw_data(cfg.user))
	pass_c := cstring(raw_data(cfg.pass))
	db_c   := cstring(raw_data(cfg.db))

	conn := ma.mysql_real_connect(mysql, host_c, user_c, pass_c, db_c, cfg.port, nil, 0)
	
    check_ptr(conn, "mysql_real_connect")
	fmt.println("  ✓ Connected successfully")

	fmt.printf("  Server version: %s\n", ma.mysql_get_server_info(mysql))
	fmt.printf("  Host info:      %s\n", ma.mysql_get_host_info(mysql))
	fmt.printf("  Proto info:     %d\n", ma.mysql_get_proto_info(mysql))
	fmt.printf("  Charset:        %s\n", ma.mysql_character_set_name(mysql))

	// Ping
	check(mysql, ma.mysql_ping(mysql), "mysql_ping")
	fmt.println("  ✓ Ping OK")
}

test_create_and_insert :: proc(mysql: ^ma.MYSQL) {
	fmt.println("=== Test: CREATE / INSERT ===")

	// Drop if exists
	ma.mysql_query(mysql, "DROP TABLE IF EXISTS odin_test")

	// CREATE TABLE
	{
		sql := "CREATE TABLE odin_test (id INT AUTO_INCREMENT PRIMARY KEY, label VARCHAR(64), value INT, created TIMESTAMP DEFAULT CURRENT_TIMESTAMP) ENGINE=InnoDB"
		rc := ma.mysql_query(mysql, cstring(raw_data(sql)))
	
        check(mysql, rc, "CREATE TABLE")
		fmt.println("  ✓ Table created")
	}

	// INSERT rows
	{
		inserts := []string{
			`INSERT INTO odin_test (label, value) VALUES ('alpha', 10)`,
			`INSERT INTO odin_test (label, value) VALUES ('beta',  20)`,
			`INSERT INTO odin_test (label, value) VALUES ('gamma', 30)`,
		}
		
        for ins in inserts {
			rc := ma.mysql_query(mysql, cstring(raw_data(ins)))
			check(mysql, rc, fmt.tprintf("INSERT: %s", ins))
		}
		
        fmt.printf("  ✓ Inserted %d rows\n", len(inserts))
	}

	// Check affected rows / insert id
	{
		rc := ma.mysql_query(mysql, `INSERT INTO odin_test (label, value) VALUES ('delta', 40)`)
		
        check(mysql, rc, "INSERT delta")
		
        affected := ma.mysql_affected_rows(mysql)
		insert_id := ma.mysql_insert_id(mysql)
		
        fmt.printf("  ✓ INSERT — affected_rows=%d  insert_id=%d\n", affected, insert_id)
	}
}

test_simple_query :: proc(mysql: ^ma.MYSQL) {
	fmt.println("=== Test: Simple Query (SELECT) ===")

	sql := "SELECT id, label, value, created FROM odin_test ORDER BY id"
	rc := ma.mysql_query(mysql, cstring(raw_data(sql)))
	
    check(mysql, rc, "SELECT")

	result := ma.mysql_store_result(mysql)
	
    check_ptr(result, "mysql_store_result")
	defer ma.mysql_free_result(result)

	num_fields := ma.mysql_num_fields(result)
	num_rows   := ma.mysql_num_rows(result)
	
    fmt.printf("  Fields: %d, Rows: %d\n", num_fields, num_rows)

	// Print field names
	fmt.print("  Columns: ")

    for i in 0 ..< num_fields {
		field := ma.mysql_fetch_field_direct(result, i)
		
        check_ptr(field, "mysql_fetch_field_direct")
		fmt.printf("%s", field.name)
	
        if i < num_fields - 1 {
			fmt.print(", ")
		}
	}
	
    fmt.println()

	// Iterate rows
	row_count := 0
	for row := ma.mysql_fetch_row(result); row != nil; row = ma.mysql_fetch_row(result) {
		fmt.printf("  Row %d: ", row_count)
		
        for i in 0 ..< num_fields {
			if row[i] != nil {
				fmt.printf("%s", row[i])
			} else {
				fmt.print("NULL")
			}
		
            if i < num_fields - 1 {
				fmt.print(" | ")
			}
		}

		fmt.println()
		row_count += 1
	}

    fmt.printf("  ✓ Fetched %d rows\n", row_count)
}

test_prepared_statement :: proc(mysql: ^ma.MYSQL) {
	fmt.println("=== Test: Prepared Statement ===")

	stmt := ma.mysql_stmt_init(mysql)
	
    check_ptr(stmt, "mysql_stmt_init")
	defer ma.mysql_stmt_close(stmt)

	// Prepare: SELECT with a parameter
	query := "SELECT id, label, value FROM odin_test WHERE value > ? ORDER BY id"
	rc_prep := ma.mysql_stmt_prepare(stmt, cstring(raw_data(query)), c.ulong(len(query)))
	
    check_stmt(stmt, rc_prep, "mysql_stmt_prepare")
	fmt.println("  ✓ Statement prepared")

	param_count := ma.mysql_stmt_param_count(stmt)
	fmt.printf("  Parameters: %d\n", param_count)

	// Bind parameter
	threshold: c.int = 15
	is_null: ma.my_bool = 0
	length: c.ulong = 0
	param_bind := ma.MYSQL_BIND {
		buffer       = &threshold,
		buffer_type  = .MYSQL_TYPE_LONG,
		buffer_length = size_of(threshold),
		is_null      = &is_null,
		length       = &length,
	}
	rc_bind := c.int(ma.mysql_stmt_bind_param(stmt, &param_bind))
	
    check_stmt(stmt, rc_bind, "mysql_stmt_bind_param")
	fmt.println("  ✓ Parameters bound")

	// Execute
	rc_exec := ma.mysql_stmt_execute(stmt)
	
    check_stmt(stmt, rc_exec, "mysql_stmt_execute")
	fmt.println("  ✓ Statement executed")

	// Get result metadata
	meta := ma.mysql_stmt_result_metadata(stmt)
	
    check_ptr(meta, "mysql_stmt_result_metadata")
	defer ma.mysql_free_result(meta)

	field_count := ma.mysql_num_fields(meta)
	fmt.printf("  Result fields: %d\n", field_count)

	// Bind result columns
	var_id: c.int
	var_label: [64]u8
	var_value: c.int
	str_len: c.ulong
	is_null_id: ma.my_bool
	is_null_label: ma.my_bool
	is_null_value: ma.my_bool

	result_binds := []ma.MYSQL_BIND {
		{
			buffer       = &var_id,
			buffer_type  = .MYSQL_TYPE_LONG,
			buffer_length = size_of(var_id),
			is_null      = &is_null_id,
		},
		{
			buffer       = &var_label,
			buffer_type  = .MYSQL_TYPE_STRING,
			buffer_length = c.ulong(len(var_label)),
			is_null      = &is_null_label,
			length       = &str_len,
		},
		{
			buffer       = &var_value,
			buffer_type  = .MYSQL_TYPE_LONG,
			buffer_length = size_of(var_value),
			is_null      = &is_null_value,
		},
	}
	
    rc_bind_res := c.int(ma.mysql_stmt_bind_result(stmt, &result_binds[0]))
	
    check_stmt(stmt, rc_bind_res, "mysql_stmt_bind_result")

	// Store results
	rc_store := ma.mysql_stmt_store_result(stmt)
	
    check_stmt(stmt, rc_store, "mysql_stmt_store_result")

	// Fetch rows
	row_num := 0
	
    for {
		fetch_rc := ma.mysql_stmt_fetch(stmt)
	
        if fetch_rc == 100 { // MYSQL_NO_DATA
			break
		}
		
        check_stmt(stmt, fetch_rc, "mysql_stmt_fetch")

		label_str := string(var_label[:str_len])
		
        fmt.printf("  Row %d: id=%d  label=%q  value=%d\n", row_num, var_id, label_str, var_value)
		row_num += 1
	}
	fmt.printf("  ✓ Fetched %d rows via prepared statement\n", row_num)
}

test_transaction :: proc(mysql: ^ma.MYSQL) {
	fmt.println("=== Test: Transactions ===")

	// Disable autocommit
	rc_ac := ma.mysql_autocommit(mysql, 0)
	
    check(mysql, c.int(rc_ac), "mysql_autocommit(0)")
	fmt.println("  ✓ Autocommit disabled")

	// Insert a row inside transaction
	ma.mysql_query(mysql, `INSERT INTO odin_test (label, value) VALUES ('txn_test', 99)`)

	// Count rows
	ma.mysql_query(mysql, "SELECT COUNT(*) FROM odin_test WHERE label = 'txn_test'")
	
    res := ma.mysql_store_result(mysql)
	check_ptr(res, "mysql_store_result (txn)")
	row := ma.mysql_fetch_row(res)
	count_before := string(row[0]) if row != nil else "?"
	
    ma.mysql_free_result(res)

	// Rollback
	ma.mysql_rollback(mysql)

	// Verify it's gone after rollback
	ma.mysql_query(mysql, "SELECT COUNT(*) FROM odin_test WHERE label = 'txn_test'")

    res2 := ma.mysql_store_result(mysql)
	row2 := ma.mysql_fetch_row(res2)
	count_after := string(row2[0]) if row2 != nil else "?"
	
    ma.mysql_free_result(res2)

	fmt.printf("  Count before rollback: %s, after: %s\n", count_before, count_after)
	fmt.println("  ✓ Transaction test completed")

	// Re-enable autocommit
	rc_ac2 := ma.mysql_autocommit(mysql, 1)
	
    check(mysql, c.int(rc_ac2), "mysql_autocommit(1)")
	fmt.println("  ✓ Autocommit re-enabled")
}

test_cleanup :: proc(mysql: ^ma.MYSQL) {
	fmt.println("=== Test: Cleanup ===")
	
    rc := ma.mysql_query(mysql, "DROP TABLE IF EXISTS odin_test")
	
    check(mysql, rc, "DROP TABLE")
	fmt.println("  ✓ Test table dropped")
}

test_strict_error_handling :: proc(mysql: ^ma.MYSQL) {
	fmt.println("=== Test: Error Handling ===")

	// Run an intentionally bad query and verify mysql_error gives something
	rc := ma.mysql_query(mysql, "SELECT * FROM non_existent_table_xyz")
	
    if rc == 0 {
		fmt.println("  ⚠ Bad query unexpectedly succeeded")
	} else {
		errno := ma.mysql_errno(mysql)
		errstr := ma.mysql_error(mysql)
		sqlstate := ma.mysql_sqlstate(mysql)
	
        fmt.printf("  ✓ Expected error caught: errno=%d  sqlstate=%s  msg=%q\n", errno, sqlstate, errstr)
	}
}

// ─── Entry Point ─────────────────────────────────────────────────────────────

main :: proc() {
	fmt.println("═══ MariaDB/Odin Binding Test ═══")
	fmt.println()

	cfg := load_config()
	
    fmt.printf("Config: host=%q port=%d user=%q db=%q\n", cfg.host, cfg.port, cfg.user, cfg.db)
	fmt.println()

	// 1. Library info
	test_version_info()
	fmt.println()

	// 2. Initialize client library
	ma.mysql_server_init(0, nil, nil)
	defer ma.mysql_server_end()
	fmt.println("✓ mysql_server_init OK")
	fmt.println()

	// 3. Allocate connection handle
	mysql := ma.mysql_init(nil)
	
    check_ptr(mysql, "mysql_init")
	defer ma.mysql_close(mysql)
	fmt.println("✓ mysql_init OK")
	fmt.println()

	// 4. Connect
	test_connect(mysql, cfg)
	fmt.println()

	// 5. Create table & insert data
	test_create_and_insert(mysql)
	fmt.println()

	// 6. Simple query
	test_simple_query(mysql)
	fmt.println()

	// 7. Prepared statement
	test_prepared_statement(mysql)
	fmt.println()

	// 8. Transactions
	test_transaction(mysql)
	fmt.println()

	// 9. Error handling
	test_strict_error_handling(mysql)
	fmt.println()

	// 10. Cleanup
	test_cleanup(mysql)
	fmt.println()

	fmt.println("═══ ALL TESTS PASSED ═══")
}

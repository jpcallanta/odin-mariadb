# odin-maria-dev

Odin bindings for [MariaDB Connector/C](https://mariadb.com/docs/clients/mariadb-connectors/connector-c/) (libmariadb-dev).

## Requirements

- Odin compiler (tested with dev-2026-07-nightly)
- libmariadb-dev (package version 3.4.9)

On Debian/Ubuntu:

    sudo apt install libmariadb-dev

## Usage

```odin
package main

import "core:fmt"
import ma "mariadb"

main :: proc() {
    // Initialize the client library
    ma.mysql_server_init(0, nil, nil)
    defer ma.mysql_server_end()

    // Initialize a connection handle
    mysql := ma.mysql_init(nil)

    defer ma.mysql_close(mysql)

    // Connect to a server
    conn := ma.mysql_real_connect(mysql, "127.0.0.1", "user", "password", "db", 0, nil, 0)
    
    if conn == nil {
        fmt.eprintln("Connection failed:", ma.mysql_error(mysql))
    
        return
    }

    // Execute a query
    if ma.mysql_query(mysql, "SELECT 1") != 0 {
        fmt.eprintln("Query failed:", ma.mysql_error(mysql))
        
        return
    }

    // Get and iterate over results
    result := ma.mysql_store_result(mysql)
    
    defer ma.mysql_free_result(result)

    for row := ma.mysql_fetch_row(result); row != nil; row = ma.mysql_fetch_row(result) {
        fmt.println(row[0])
    }
}
```

## Testing

The repository includes an integration test program under `test/` that exercises
the bindings against a live MariaDB/MySQL server. It covers:

- Library and client version information
- Connection handling (real connect, ping, server info)
- CREATE TABLE / INSERT (affected rows, insert id)
- Simple queries (SELECT with field metadata and row iteration)
- Prepared statements (parameter binding, result binding, fetch)
- Transactions (autocommit, rollback)
- Error handling (bad query via mysql_error/mysql_errno/mysql_sqlstate)
- Cleanup (test table dropped at the end of the run)

### Prerequisites

- A running MariaDB/MySQL server
- `libmariadb-dev` installed (see [Requirements](#requirements))

### Configuration

The test reads its connection settings from environment variables:

A `test/env.example` template is provided with placeholder values. Copy it to
`test/env` (which is gitignored), fill in your connection settings, and source
it:

    cp test/env.example test/env
    # edit test/env with your connection settings
    source test/env

### Building and running

From the repository root:

    odin run test

or build the binary first:

    odin build test -out:mariadb_test
    ./mariadb_test

### Notes

- The test creates a `odin_test` table, so the configured user needs DDL
  privileges on the target database.
- The table is dropped again during cleanup at the end of a successful run.

## Package Structure

The binding is split into purpose-based files under the `mariadb/` directory to avoid a single monolithic file.

| File | Description |
|------|-------------|
| `mariadb.odin` | Package declaration, foreign library import |
| `types.odin` | Core structs: MYSQL, MYSQL_RES, MYSQL_FIELD, NET, API function table, methods |
| `types_stmt.odin` | Prepared statement types: MYSQL_STMT, MYSQL_BIND, enums |
| `types_rpl.odin` | Replication types: MARIADB_RPL, MARIADB_RPL_EVENT, event structs, flags |
| `types_dyncol.odin` | Dynamic column types: DYNAMIC_COLUMN, DYNAMIC_COLUMN_VALUE |
| `types_plugin.odin` | Plugin types: client plugin headers, PVIO, TLS, auth |
| `enum.odin` | Enums and constants (field types, options, client flags, server status) |
| `errmsg.odin` | Client error codes (CR_*) |
| `version.odin` | Library version constants |
| `connect.odin` | Connection management, SSL, transactions, server info |
| `query.odin` | Query execution, result handling, field metadata, multi-result |
| `stmt.odin` | Prepared statement functions |
| `async.odin` | Non-blocking async API (start/cont function pairs) |
| `util.odin` | String escaping, password hashing, charset conversion, config |
| `net.odin` | Internal network and PVIO protocol functions |
| `plugin.odin` | Plugin loading, TLS functions, charset variables |
| `list.odin` | Linked list utilities |
| `dyncol.odin` | Dynamic column functions |
| `rpl.odin` | Replication stream functions |

## API Coverage

The bindings cover the full public API of MariaDB Connector/C 3.4.9, including:

- Connection management (TCP, Unix socket, SSL)
- Transaction control (autocommit, commit, rollback)
- Query execution (text protocol, prepared statements)
- Result set navigation (row iteration, field metadata)
- Dynamic columns
- Replication stream (binlog dump)
- Non-blocking async API
- Client plugin system
- TLS/SSL configuration
- Error handling

## Platform Support

- Linux (primary target, tested with x86_64)
- Windows (basic support via conditional import, untested)

## Notes

- Variadic C functions (mysql_optionsv, mariadb_get_infov, etc.) are declared
  without variadic support due to current Odin foreign block limitations.
  Use the non-variadic equivalents where available.
- The calling convention defaults to the C ABI (STDCALL is equivalent to the
  C calling convention on x86_64).

## MIT LICENSE

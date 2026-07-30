package mariadb

import "core:c"

when ODIN_OS != .Windows {
	foreign import lib "system:mariadb"
} else {
	foreign import lib "mariadb.lib"
}

// ─── Linked List Utilities (ma_list.h) ──────────────────────────────────────

foreign lib {
	list_add     :: proc(root: ^LIST, element: ^LIST) -> ^LIST ---
	list_delete  :: proc(root: ^LIST, element: ^LIST) -> ^LIST ---
	list_cons    :: proc(data: rawptr, root: ^LIST) -> ^LIST ---
	list_reverse :: proc(root: ^LIST) -> ^LIST ---
	list_free    :: proc(root: ^LIST, free_data: c.uint) ---
	list_length  :: proc(list: ^LIST) -> c.uint ---
	list_walk    :: proc(list: ^LIST, action: proc "stdcall" (rawptr, rawptr) -> c.int, argument: cstring) -> c.int ---
}

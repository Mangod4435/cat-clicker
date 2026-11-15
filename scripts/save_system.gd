class_name SaveSystem
extends RefCounted
## Port of SaveSystem.cs. Uses a file in user:// (IndexedDB on web exports) instead of PlayerPrefs.
## The file stores the JSON plus a hash of it, so hand-edited saves are rejected.

const SAVE_PATH := "user://cat_clicker_save.json"
const SALT := "cat-clicker-save-v1"


static func get_default() -> Dictionary:
	var upgrades := {}
	var revealed := {}
	for n in UpgradeAPI.names():
		upgrades[n] = 0
		revealed[n] = false
	return {"cats": 0.0, "upgrades": upgrades, "revealed": revealed, "sound_on": true}


static func _hash(json: String) -> String:
	return (json + SALT).sha256_text()


static func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


static func save_data(data: Dictionary) -> void:
	var json := JSON.stringify(data)
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("[SaveSystem] Could not open save file: %s" % error_string(FileAccess.get_open_error()))
		return
	file.store_string(JSON.stringify({"json": json, "hash": _hash(json)}))
	file.close()


static func load_data() -> Dictionary:
	if not has_save():
		print("[SaveSystem] No save found")
		return get_default()

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return get_default()

	var outer = JSON.parse_string(file.get_as_text())
	if typeof(outer) != TYPE_DICTIONARY or not outer.has("json") or not outer.has("hash"):
		push_warning("[SaveSystem] Save file was invalid, using defaults")
		return get_default()

	# protect against fake injected saves
	if _hash(str(outer["json"])) != str(outer["hash"]):
		push_warning("[SaveSystem] Save hash mismatch, using defaults")
		return get_default()

	var inner = JSON.parse_string(str(outer["json"]))
	if typeof(inner) != TYPE_DICTIONARY:
		push_warning("[SaveSystem] Save data was invalid, using defaults")
		return get_default()
	return inner


static func destroy_save() -> void:
	if has_save():
		DirAccess.open("user://").remove(SAVE_PATH.get_file())
	print("[SaveSystem] Save destroyed")

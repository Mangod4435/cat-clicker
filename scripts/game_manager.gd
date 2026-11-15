extends Node
## Autoload "GameManager". Port of GameManager.cs + SaveSystem.cs merged into one script.
## Upgrade levels / reveal flags live in dictionaries keyed by the names in UpgradeAPI.DATA,
## so there is no per-upgrade property or switch statement anymore.
## Saves are JSON in user:// (IndexedDB on web exports) plus a hash of the JSON,
## so hand-edited saves are rejected.

const AUTO_SAVE_INTERVAL := 30.0

const SAVE_PATH := "user://cat_clicker_save.json"
const SAVE_SALT := "cat-clicker-save-v1"

var cats: float = 0.0
var cpc: float = 1.0 # cats per click
var cps: float = 0.0 # cats per second
var sound_on: bool = true # persisted settings

var _upgrades: Dictionary = {}
var _revealed: Dictionary = {}

var _cps_timer := 0.0
var _auto_save_timer := 0.0
var _save_loaded := false


func _ready() -> void:
	_load_game()
	_save_loaded = true


func _process(delta: float) -> void:
	_auto_save_timer += delta
	if _auto_save_timer >= AUTO_SAVE_INTERVAL:
		save_game()
		_auto_save_timer = 0.0


func _physics_process(delta: float) -> void:
	_cps_timer += delta
	if _cps_timer >= 1.0:
		add_cat(cps)
		_cps_timer = 0.0


func _notification(what: int) -> void:
	if not _save_loaded:
		return
	# Save when the tab/window loses focus, the app is paused, or the window is closed
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT, NOTIFICATION_WM_WINDOW_FOCUS_OUT, \
		NOTIFICATION_APPLICATION_PAUSED, NOTIFICATION_WM_CLOSE_REQUEST:
			save_game()


# ---------------------------------------------------------------- API

func add_cat(amount: float = 1.0) -> void:
	cats += amount


func set_cat(amount: float = 0.0) -> void:
	cats = amount


func get_upgrade(upgrade_name: String) -> int:
	return _upgrades.get(upgrade_name, 0)


func add_upgrade(upgrade_name: String, amount: int = 1) -> void:
	if not UpgradeAPI.exists(upgrade_name):
		push_error("That upgrade not found (%s)" % upgrade_name)
		return
	_upgrades[upgrade_name] = get_upgrade(upgrade_name) + amount
	_recalculate()


func set_revealed(upgrade_name: String, value: bool) -> void:
	if not UpgradeAPI.exists(upgrade_name):
		push_error("That upgrade not found (%s)" % upgrade_name)
		return
	_revealed[upgrade_name] = value


func get_revealed(upgrade_name: String) -> bool:
	return _revealed.get(upgrade_name, false)


# ------------------------------------------------------- Save / Load

func save_game() -> void:
	_write_save({
		"cats": snappedf(cats, 0.00001),
		"cpc": cpc,
		"cps": cps,
		"upgrades": _upgrades,
		"revealed": _revealed,
		"sound_on": sound_on,
	})
	print("[GameManager] Game Saved")


func reset_game() -> void:
	_destroy_save()
	_load_game()


func _load_game() -> void:
	var data := _read_save()
	cats = snappedf(float(data.get("cats", 0.0)), 0.00001)

	var saved_upgrades: Dictionary = data.get("upgrades", {})
	var saved_revealed: Dictionary = data.get("revealed", {})
	sound_on = bool(data.get("sound_on", true))
	_upgrades.clear()
	_revealed.clear()
	for n in UpgradeAPI.names():
		_upgrades[n] = int(saved_upgrades.get(n, 0))
		_revealed[n] = bool(saved_revealed.get(n, false))
	_recalculate()


# ----------------------------------------------------- Save internals

## Default state, used when there is no (valid) save yet.
func _default_data() -> Dictionary:
	var upgrades := {}
	var revealed := {}
	for n in UpgradeAPI.names():
		upgrades[n] = 0
		revealed[n] = false
	return {"cats": 0.0, "upgrades": upgrades, "revealed": revealed, "sound_on": true}


func _save_hash(json: String) -> String:
	return (json + SAVE_SALT).sha256_text()


func _has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func _write_save(data: Dictionary) -> void:
	var json := JSON.stringify(data)
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("[GameManager] Could not open save file: %s" % error_string(FileAccess.get_open_error()))
		return
	file.store_string(JSON.stringify({"json": json, "hash": _save_hash(json)}))
	file.close()


func _read_save() -> Dictionary:
	if not _has_save():
		print("[GameManager] No save found")
		return _default_data()

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return _default_data()

	var outer = JSON.parse_string(file.get_as_text())
	if typeof(outer) != TYPE_DICTIONARY or not outer.has("json") or not outer.has("hash"):
		push_warning("[GameManager] Save file was invalid, using defaults")
		return _default_data()

	# protect against fake injected saves
	if _save_hash(str(outer["json"])) != str(outer["hash"]):
		push_warning("[GameManager] Save hash mismatch, using defaults")
		return _default_data()

	var inner = JSON.parse_string(str(outer["json"]))
	if typeof(inner) != TYPE_DICTIONARY:
		push_warning("[GameManager] Save data was invalid, using defaults")
		return _default_data()
	return inner


func _destroy_save() -> void:
	if _has_save():
		DirAccess.open("user://").remove(SAVE_PATH.get_file())
	print("[GameManager] Save destroyed")


# ----------------------------------------------------------- Helpers

func _recalculate() -> void:
	cpc = 1.0
	cps = 0.0
	for n in UpgradeAPI.names():
		var level: int = _upgrades.get(n, 0)
		cpc += level * float(UpgradeAPI.DATA[n]["cpc"])
		cps += level * float(UpgradeAPI.DATA[n]["cps"])

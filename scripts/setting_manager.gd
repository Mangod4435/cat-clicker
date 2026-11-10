extends Node
## Autoload "SettingManager". Port of Settingmanager.cs + SaveSettingSystem.cs + SettingData.cs.

const PREF_PATH := "user://cat_clicker_settings.json"

var sound: bool = false # same default as the Unity version (no pref file -> sound off)


func _ready() -> void:
	load_settings()


func set_sound(b: bool) -> void:
	sound = b


func save_settings() -> void:
	var file := FileAccess.open(PREF_PATH, FileAccess.WRITE)
	if file == null:
		push_error("[SettingManager] Could not save settings")
		return
	file.store_string(JSON.stringify({"isSoundOpen": sound}))
	file.close()


func load_settings() -> void:
	if not FileAccess.file_exists(PREF_PATH):
		sound = false
		save_settings()
		return
	var file := FileAccess.open(PREF_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text()) if file else null
	sound = bool(data.get("isSoundOpen", false)) if typeof(data) == TYPE_DICTIONARY else false

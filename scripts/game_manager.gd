extends Node
## Autoload "GameManager". Port of GameManager.cs.
## Upgrade levels / reveal flags live in dictionaries keyed by the names in UpgradeAPI.DATA,
## so there is no per-upgrade property or switch statement anymore.

const AUTO_SAVE_INTERVAL := 30.0

var cats: float = 0.0
var cpc: float = 1.0 # cats per click
var cps: float = 0.0 # cats per second

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
	SaveSystem.save_data({
		"cats": snappedf(cats, 0.00001),
		"cpc": cpc,
		"cps": cps,
		"upgrades": _upgrades,
		"revealed": _revealed,
	})


func _load_game() -> void:
	var data := SaveSystem.load_data()
	cats = snappedf(float(data.get("cats", 0.0)), 0.00001)

	var saved_upgrades: Dictionary = data.get("upgrades", {})
	var saved_revealed: Dictionary = data.get("revealed", {})
	_upgrades.clear()
	_revealed.clear()
	for n in UpgradeAPI.names():
		_upgrades[n] = int(saved_upgrades.get(n, 0))
		_revealed[n] = bool(saved_revealed.get(n, false))
	_recalculate()


func reset_game() -> void:
	SaveSystem.destroy_save()
	_load_game()


# ----------------------------------------------------------- Helpers

func _recalculate() -> void:
	cpc = 1.0
	cps = 0.0
	for n in UpgradeAPI.names():
		var level: int = _upgrades.get(n, 0)
		cpc += level * float(UpgradeAPI.DATA[n]["cpc"])
		cps += level * float(UpgradeAPI.DATA[n]["cps"])

extends TextureButton
## Port of CatButton.cs, SettingButton.cs, ResetButton.cs and SaveButton.cs, collapsed into one script.
## Pick a ButtonType in the inspector; every method switches on it (GDScript match) to pick its behavior.

enum ButtonType { CAT, SETTING, RESET, SAVE }

@export var button_type: ButtonType
@export var cat: Control
@export var upgrade_menu: Control
@onready var _meow: AudioStreamPlayer = get_node_or_null("Meow")

var _settings_open := false

func _ready() -> void:
	match button_type:
		ButtonType.CAT, ButtonType.SETTING:
			pivot_offset = size / 2.0

func _physics_process(delta: float) -> void:
	match button_type:
		ButtonType.CAT:
			rotation_degrees += 22.5 * delta # slow clockwise spin

func _process(_delta: float) -> void:
	match button_type:
		ButtonType.CAT:
			scale = Vector2.ONE * (0.8 if get_draw_mode() == BaseButton.DRAW_PRESSED else 1.0)
		ButtonType.SETTING:
			rotation_degrees = 45.0 if _settings_open else 15.0

func on_clicked() -> void:
	match button_type:
		ButtonType.CAT:
			GameManager.add_cat(GameManager.cpc)
			if SettingManager.sound: _meow.play()
		ButtonType.SETTING:
			_settings_open = not _settings_open
		ButtonType.RESET:
			GameManager.reset_game()
			cat.rotation = 0.0
			if upgrade_menu:
				upgrade_menu.close()
		ButtonType.SAVE:
			GameManager.save_game()

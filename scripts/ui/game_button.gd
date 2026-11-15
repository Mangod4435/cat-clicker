extends TextureButton
## Port of CatButton.cs, ResetButton.cs and SaveButton.cs, collapsed into one script.
## Pick a ButtonType in the inspector; every method switches on it (GDScript match) to pick its behavior.

enum ButtonType { CAT, RESET, SAVE, SETTING}

@export var button_type: ButtonType
@onready var _meow: AudioStreamPlayer = get_node_or_null("Meow")
var _setting_panel: PanelContainer

func _ready() -> void:
	match button_type:
		ButtonType.CAT:
			pivot_offset = size / 2.0
		ButtonType.SETTING:
			_setting_panel = get_node("/root/Main/SettingPanel")
			_setting_panel.modulate.a = 1
			_setting_panel.visible = false

func _process(delta: float) -> void:
	match button_type:
		ButtonType.CAT:
			rotation_degrees += 22.5 * delta # slow clockwise spin
			scale = Vector2.ONE * (0.8 if get_draw_mode() == BaseButton.DRAW_PRESSED else 1.0)

func on_clicked() -> void:
	match button_type:
		ButtonType.CAT:
			GameManager.add_cat(GameManager.cpc)
			_meow.play()
		ButtonType.RESET: GameManager.reset_game()
		ButtonType.SAVE: GameManager.save_game()
		ButtonType.SETTING:
			_setting_panel.visible = not _setting_panel.visible

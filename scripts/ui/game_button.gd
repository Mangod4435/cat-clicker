extends TextureButton
## Port of CatButton.cs, ResetButton.cs and SaveButton.cs, collapsed into one script.
## Pick a ButtonType in the inspector; every method switches on it (GDScript match) to pick its behavior.

enum ButtonType { CAT, RESET, SAVE, SETTING}

@export var button_type: ButtonType
@onready var _meow: AudioStreamPlayer = get_node_or_null("Meow")
var _setting_panel: PanelContainer
var _sound_toggle: CheckButton

func _ready() -> void:
	match button_type:
		ButtonType.CAT:
			pivot_offset = size / 2.0
		ButtonType.SETTING:
			_setting_panel = get_node("/root/Main/SettingPanel")
			_setting_panel.modulate.a = 1
			_setting_panel.visible = false
			_sound_toggle = _setting_panel.get_node("Margin/VBox/SoundRow/SoundToggle")
			_sound_toggle.button_pressed = GameManager.sound_on # sync UI with saved state
			_sound_toggle.toggled.connect(_on_toggled)
			_apply_sound()

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
		ButtonType.RESET:
			GameManager.reset_game()
			_apply_sound() # reset may restore sound, re-sync the bus
		ButtonType.SAVE: GameManager.save_game()
		ButtonType.SETTING:
			_sound_toggle.button_pressed = GameManager.sound_on # re-sync before showing
			_setting_panel.visible = not _setting_panel.visible


func _on_toggled(toggled_on: bool) -> void:
	GameManager.sound_on = toggled_on
	_apply_sound()


func _apply_sound() -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), not GameManager.sound_on)

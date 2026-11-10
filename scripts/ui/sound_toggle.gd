extends CheckButton
## Port of SoundToggle.cs


func _ready() -> void:
	set_pressed_no_signal(SettingManager.sound)


## Connect the "toggled" signal to this yourself.
func on_toggled(pressed: bool) -> void:
	SettingManager.set_sound(pressed)
	SettingManager.save_settings()

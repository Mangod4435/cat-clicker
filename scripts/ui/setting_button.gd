extends TextureButton
## Port of SettingButton.cs (the gear). Rotates 15 deg closed / 45 deg open.


func _ready() -> void:
	pivot_offset = size / 2.0


func _process(_delta: float) -> void:
	rotation_degrees = 45.0 if UIState.state == UIState.OpenedInterface.SETTING else 15.0


## Connect the "pressed" signal to this yourself.
func on_clicked() -> void:
	UIState.state = (
		UIState.OpenedInterface.NONE
		if UIState.state == UIState.OpenedInterface.SETTING
		else UIState.OpenedInterface.SETTING
	)

extends TextureButton
## Port of ResetButton.cs

@export var cat: Control


## Connect the "pressed" signal to this yourself.
func on_clicked() -> void:
	GameManager.reset_game()
	cat.rotation = 0.0
	UIState.state = UIState.OpenedInterface.NONE

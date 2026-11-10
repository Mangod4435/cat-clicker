extends TextureButton
## Manual save button (was wired to GameManager.SaveGame in the Unity scene).


## Connect the "pressed" signal to this yourself.
func on_clicked() -> void:
	GameManager.save_game()

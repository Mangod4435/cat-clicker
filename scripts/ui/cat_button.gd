extends TextureButton
## Port of CatButton.cs + PressedEvent.cs. Child node "Meow" is an AudioStreamPlayer.
## The "held down" shrink is read straight from the button state, so no signals are needed for it.

@onready var _meow: AudioStreamPlayer = $Meow


func _ready() -> void:
	pivot_offset = size / 2.0


func _physics_process(delta: float) -> void:
	rotation_degrees += 22.5 * delta # slow clockwise spin


func _process(_delta: float) -> void:
	scale = Vector2.ONE * (0.8 if get_draw_mode() == BaseButton.DRAW_PRESSED else 1.0)
	_meow.volume_db = 0.0 if SettingManager.sound else -80.0


## Connect the "pressed" signal to this yourself.
func on_clicked() -> void:
	GameManager.add_cat(GameManager.cpc)
	_meow.play()

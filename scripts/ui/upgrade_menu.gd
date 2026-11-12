extends TextureButton
## Port of UpgradeMenu.cs. This is the toggle button; its child "Panel" holds the upgrade list.
## When open, the button (and its panel) slide left and the cat shifts to make room.

@export var panel: Control
@export var shift_with_cat: Array[Control] = [] # e.g. the cats counter

const SLIDE := 960.0
const CAT_SHIFT := 410.0

@onready var cat: Control = get_node("/root/Main/CenterZone")
@onready var _closed_pos: Vector2 = position
@onready var _cat_closed_pos: Vector2 = cat.position
var _shift_closed_pos: Array[Vector2] = []
var _is_open := false


func _ready() -> void:
	for c in shift_with_cat:
		_shift_closed_pos.append(c.position)


func _process(_delta: float) -> void:
	position = _closed_pos + (Vector2(-SLIDE, 0) if _is_open else Vector2.ZERO)
	panel.visible = _is_open # was MainControl's job; it no longer exists
	var cat_offset := Vector2(-CAT_SHIFT, 0) if _is_open else Vector2.ZERO
	cat.position = _cat_closed_pos + cat_offset
	for i in shift_with_cat.size():
		shift_with_cat[i].position = _shift_closed_pos[i] + cat_offset


## Connect the "pressed" signal to this yourself.
func on_clicked() -> void:
	_is_open = not _is_open


## Close the menu (e.g. when the game is reset).
func close() -> void:
	_is_open = false

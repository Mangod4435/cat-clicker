extends TextureButton
## Port of UpgradeMenu.cs. This is the toggle button; its child "Panel" holds the upgrade list.
## When open, the button (and its panel) slide left and the cat shifts to make room.

@export var cat: Control
@export var panel: Control
@export var shift_with_cat: Array[Control] = [] # e.g. the cats counter

const SLIDE := 960.0
const CAT_SHIFT := 410.0

var _closed_pos: Vector2
var _cat_closed_pos: Vector2
var _shift_closed_pos: Array[Vector2] = []


func _ready() -> void:
	_closed_pos = position
	_cat_closed_pos = cat.position
	for c in shift_with_cat:
		_shift_closed_pos.append(c.position)


func _process(_delta: float) -> void:
	var is_open := UIState.state == UIState.OpenedInterface.UPGRADE
	position = _closed_pos + (Vector2(-SLIDE, 0) if is_open else Vector2.ZERO)
	var cat_offset := Vector2(-CAT_SHIFT, 0) if is_open else Vector2.ZERO
	cat.position = _cat_closed_pos + cat_offset
	for i in shift_with_cat.size():
		shift_with_cat[i].position = _shift_closed_pos[i] + cat_offset


## Connect the "pressed" signal to this yourself.
func on_clicked() -> void:
	UIState.state = (
		UIState.OpenedInterface.NONE
		if UIState.state == UIState.OpenedInterface.UPGRADE
		else UIState.OpenedInterface.UPGRADE
	)
